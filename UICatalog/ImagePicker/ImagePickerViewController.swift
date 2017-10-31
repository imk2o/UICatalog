//
//  ImagePickerViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/25.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ImagePickerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // 画面表示後、自動でアクションシートを表示
        DispatchQueue.main.async {
            self.proposeAction()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImageDidTap(_ sender: UIBarButtonItem) {
        self.proposeAction()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate extension ImagePickerViewController {
    func proposeAction() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "ライブラリから選択", style: .default) { (action) in
            self.requestPickImageFromPhotoLibrary()
            }
        )
        actionSheet.addAction(UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            self.requestPickImageFromCamera()
            }
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // カメラで撮影
    func requestPickImageFromCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { [weak self] (result) in
            if result {
                DispatchQueue.main.async {
                    self?.pickImage(from: .camera)
                }
            }
        }
    }
    
    // 写真ライブラリから選択
    func requestPickImageFromPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        // iOS10以降、フォトライブラリへのアクセスには
        // Info.plistにNSPhotoLibraryUsageDescriptionキーの設定が必須となった
        // (値は空欄でもOK)
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if status == .authorized {
                DispatchQueue.main.async {
                    self?.pickImage(from: .photoLibrary)
                }
            }
        }
    }
    
    func pickImage(from sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        //imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        //imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //if let image = info[UIImagePickerControllerEditedImage] as? UIImage {    // cropped image
            self.imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancelled
        picker.dismiss(animated: true, completion: nil)
    }
}
