//
//  VideoCaptureViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/25.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation

enum SimpleFilter {
    case sepia
    case blur(CGFloat)
    case mosaic(CGFloat)
    case twist(CGFloat, CGFloat)    // radius, angle
    
    var name: String {
        switch self {
        case .sepia:
            return "セピア"
        case .blur:
            return "ぼかし"
        case .mosaic:
            return "モザイク"
        case .twist:
            return "渦巻き"
        }
    }
    
    func ciFilter(center: CGPoint, intensity: CGFloat = 1.0) -> CIFilter {
        switch self {
        case .sepia:
            return CIFilter(
                name: "CISepiaTone",
                parameters: [
                    kCIInputIntensityKey: intensity
                ]
            )!
        case .blur(let size):
            return CIFilter(
                name: "CIGaussianBlur",
                parameters: [
                    kCIInputRadiusKey: intensity * size
                ]
            )!
        case .mosaic(let size):
            return CIFilter(
                name: "CIPixellate",
                parameters: [
                    kCIInputScaleKey: (intensity * size) + 1.0
                ]
            )!
        case .twist(let radius, let angle):
            return CIFilter(
                name: "CIVortexDistortion",
                parameters: [
                    kCIInputCenterKey: CIVector(cgPoint: center),
//                    kCIInputRadiusKey: intensity * radius,
                    kCIInputAngleKey: intensity * angle
                ]
            )!
        }
    }
}

class VideoCaptureViewController: UIViewController {

    fileprivate let captureSession = AVCaptureSession()
    fileprivate var filter: SimpleFilter = .blur(20)
    
    @IBOutlet weak var coreImageView: CoreImageView!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coreImageView.context = EAGLContext(api: .openGLES2)!
        
        // カメラのセットアップ
        self.setCameraFace(.back)
        self.setupCamera()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.captureSession.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filterButtonDidTap(_ sender: Any) {
        self.proposeFilter()
    }
}

fileprivate extension VideoCaptureViewController {
    func proposeFilter() {
        let actionSheet = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        
        let filters: [SimpleFilter] = [
            .sepia,
            .mosaic(40),
            .blur(20),
            .twist(100, CGFloat.pi * 50.0)
        ]
        for filter in filters {
            actionSheet.addAction(UIAlertAction(title: filter.name, style: .default) { (action) in
                self.filter = filter
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func setCameraFace(_ position: AVCaptureDevice.Position) -> Bool {
        // position に対するカメラを探す
        guard
            let videoDevice = AVCaptureDevice.captureDevices(for: position).first,
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
            else {
                return false
        }
        
        // キャプチャセッションの入力を入れ替え
        if self.captureSession.isRunning {
            self.captureSession.beginConfiguration()
        }
        defer {
            if self.captureSession.isRunning {
                self.captureSession.commitConfiguration()
            }
        }
        
        let installedVideoInputDevice = self.captureSession.installedCaptureDeviceInputs().first
        
        // 既にデバイスが設定されている場合は入れ替え
        if let videoInputDevice = installedVideoInputDevice {
            self.captureSession.removeInput(videoInputDevice)
        }
        if self.captureSession.canAddInput(videoInput) {
            self.captureSession.addInput(videoInput)
            
            return true
        } else {
            if let videoInputDevice = installedVideoInputDevice {
                self.captureSession.addInput(videoInputDevice)
            }
            
            return false
        }
    }
    
    func setupCamera() {
        if self.captureSession.canSetSessionPreset(.medium) {
            self.captureSession.sessionPreset = .medium
        }
        
        // ビデオキャプチャ
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "", attributes: []))
        self.captureSession.addOutput(videoOutput)
    }
}

fileprivate extension AVCaptureDevice {
    static func captureDevices(for position: AVCaptureDevice.Position) -> [AVCaptureDevice] {
        return AVCaptureDevice.devices(for: .video).compactMap({ (captureDevice) -> AVCaptureDevice? in
            guard let captureDevice = captureDevice as? AVCaptureDevice else {
                return nil
            }
            return captureDevice.position == position ? captureDevice : nil
        })
    }
}

fileprivate extension AVCaptureSession {
    func installedCaptureDeviceInputs() -> [AVCaptureDeviceInput] {
        return self.inputs.compactMap({ (input) -> AVCaptureDeviceInput? in
            return input as? AVCaptureDeviceInput
        })
    }
}

// ビデオキャプチャ
extension VideoCaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let captureImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // カメラに応じた回転補正をかける(Portraitに合わせている)
        let transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))	// Back camera
        //transform = CGAffineTransformScale(transform, 1, -1)				// Front camera
        let transformedImage = captureImage.transformed(by: transform)
        
        // Core Imageでフィルタを適用
        let ciFilter = self.filter.ciFilter(
            center: CGPoint(x: transformedImage.extent.midX, y: transformedImage.extent.midY),
            intensity: CGFloat(self.slider.value)
        )
        ciFilter.setValue(transformedImage, forKey: kCIInputImageKey)

        // 元の画像サイズでcrop
        let croppedImage = ciFilter.outputImage?.cropped(to: transformedImage.extent)
        
        // UIImageを出力してUIImageViewに表示することもできるが、OpenGLを使うほうが軽量で高速
        self.coreImageView.image = croppedImage
    }
}

import GLKit
class CoreImageView: GLKView {
    var image: CIImage? {
        didSet {
            self.display()
        }
    }
    
    override var context: EAGLContext {
        didSet {
            self.ciContext = CIContext(eaglContext: self.context)
        }
    }
    fileprivate var ciContext: CIContext?
    
    override func draw(_ rect: CGRect) {
        guard
            let image = self.image,
            let ciContext = self.ciContext
            else {
                return
        }
        
        let scale = self.window?.screen.scale ?? 1.0
        let screenScaledBounds = self.bounds.applying(CGAffineTransform(scaleX: scale, y: scale))
        let aspectFitRect = AVMakeRect(aspectRatio: image.extent.size, insideRect: screenScaledBounds)
        ciContext.draw(image, in: aspectFitRect, from: image.extent)
    }
}
