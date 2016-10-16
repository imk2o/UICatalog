//
//  VideoCaptureViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/25.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCaptureViewController: UIViewController {

    fileprivate let captureSession = AVCaptureSession()
    @IBOutlet weak var coreImageView: CoreImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coreImageView.context = EAGLContext(api: .openGLES2)
        
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
}

fileprivate extension VideoCaptureViewController {
    func setCameraFace(_ position: AVCaptureDevicePosition) -> Bool {
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
        if self.captureSession.canSetSessionPreset(AVCaptureSessionPresetMedium) {
            self.captureSession.sessionPreset = AVCaptureSessionPresetMedium
        }
        
        // ビデオキャプチャ
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "", attributes: []))
        self.captureSession.addOutput(videoOutput)
    }
}

fileprivate extension AVCaptureDevice {
    static func captureDevices(for position: AVCaptureDevicePosition) -> [AVCaptureDevice] {
        return self.devices(withMediaType: AVMediaTypeVideo).flatMap({ (captureDevice) -> AVCaptureDevice? in
            guard let captureDevice = captureDevice as? AVCaptureDevice else {
                return nil
            }
            return captureDevice.position == position ? captureDevice : nil
        })
    }
}

fileprivate extension AVCaptureSession {
    func installedCaptureDeviceInputs() -> [AVCaptureDeviceInput] {
        return self.inputs.flatMap({ (input) -> AVCaptureDeviceInput? in
            return input as? AVCaptureDeviceInput
        })
    }
}

// ビデオキャプチャ
extension VideoCaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let captureImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // カメラに応じた回転補正をかける(Portraitに合わせている)
        let transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI_2))		// Back camera
        //transform = CGAffineTransformScale(transform, 1, -1)				// Front camera
        let transformedImage = captureImage.applying(transform)
        
        // Core Imageでフィルタを適用
        let sepiaFilter = CIFilter(name: "CISepiaTone")!
        sepiaFilter.setValue(transformedImage, forKey: kCIInputImageKey)
        
        // UIImageを出力してUIImageViewに表示することもできるが、OpenGLを使うほうが軽量で高速
        self.coreImageView.image = sepiaFilter.outputImage
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
