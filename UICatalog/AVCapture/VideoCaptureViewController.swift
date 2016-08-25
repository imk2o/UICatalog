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

    private let captureSession = AVCaptureSession()
    @IBOutlet weak var coreImageView: CoreImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coreImageView.context = EAGLContext(API: .OpenGLES2)
        
        // カメラのセットアップ
        self.setCameraFace(.Back)
        self.setupCamera()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.captureSession.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private extension VideoCaptureViewController {
    func setCameraFace(position: AVCaptureDevicePosition) -> Bool {
        // position に対するカメラを探す
        guard
            let videoDevice = AVCaptureDevice.captureDevices(for: position).first,
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
            else {
                return false
        }
        
        // キャプチャセッションの入力を入れ替え
        if self.captureSession.running {
            self.captureSession.beginConfiguration()
        }
        defer {
            if self.captureSession.running {
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
        videoOutput.setSampleBufferDelegate(self, queue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
        self.captureSession.addOutput(videoOutput)
    }
}

private extension AVCaptureDevice {
    static func captureDevices(for position: AVCaptureDevicePosition) -> [AVCaptureDevice] {
        return self.devicesWithMediaType(AVMediaTypeVideo).flatMap({ (captureDevice) -> AVCaptureDevice? in
            guard let captureDevice = captureDevice as? AVCaptureDevice else {
                return nil
            }
            return captureDevice.position == position ? captureDevice : nil
        })
    }
}

private extension AVCaptureSession {
    func installedCaptureDeviceInputs() -> [AVCaptureDeviceInput] {
        return self.inputs.flatMap({ (input) -> AVCaptureDeviceInput? in
            return input as? AVCaptureDeviceInput
        })
    }
}

// ビデオキャプチャ
extension VideoCaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let captureImage = CIImage(CVPixelBuffer: pixelBuffer)
        
        // カメラに応じた回転補正をかける(Portraitに合わせている)
        var transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))		// Back camera
        //transform = CGAffineTransformScale(transform, 1, -1)				// Front camera
        let transformedImage = captureImage.imageByApplyingTransform(transform)
        
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
            self.ciContext = CIContext(EAGLContext: self.context)
        }
    }
    private var ciContext: CIContext?
    
    override func drawRect(rect: CGRect) {
        guard
            let image = self.image,
            let ciContext = self.ciContext
            else {
                return
        }
        
        let scale = self.window?.screen.scale ?? 1.0
        let screenScaledBounds = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(scale, scale))
        let aspectFitRect = AVMakeRectWithAspectRatioInsideRect(image.extent.size, screenScaledBounds)
        ciContext.drawImage(image, inRect: aspectFitRect, fromRect: image.extent)
    }
}
