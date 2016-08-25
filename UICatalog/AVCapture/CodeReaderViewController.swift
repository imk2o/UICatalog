//
//  CodeReaderViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/25.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation

class CodeReaderViewController: UIViewController {

    private let captureSession = AVCaptureSession()
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

private extension CodeReaderViewController {
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
        
        // ビデオキャプチャでフィルタをかけないのであれば、プレビューレイヤを使うほうが簡単
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        previewLayer.connection.videoOrientation = .Portrait
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        let layerRect = self.view.layer.bounds
        previewLayer.bounds = layerRect
        self.view.layer.insertSublayer(previewLayer, below: self.textView.layer)
        previewLayer.position = CGPoint(x: CGRectGetMidX(layerRect), y: CGRectGetMidY(layerRect))
        
        // バーコードリーダ
        let metadataOutput = AVCaptureMetadataOutput()
        self.captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
        metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
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

// バーコードリーダ
extension CodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {

        let codeObjects = metadataObjects.flatMap { (metadataObject) -> AVMetadataMachineReadableCodeObject? in
            return metadataObject as? AVMetadataMachineReadableCodeObject
        }
        for codeObject in codeObjects {
            let value = codeObject.stringValue
            switch codeObject.type {
            case AVMetadataObjectTypeQRCode:
                self.showCodeValue("QRCode: \(value)")
            case AVMetadataObjectTypeEAN13Code:
                self.showCodeValue("JANCode: \(value)")
            default:
                self.showCodeValue("Other: \(value)")
            }
        }
    }
    
    private func showCodeValue(codeValue: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.textView.text = codeValue
            print(codeValue)
        }
    }
}
