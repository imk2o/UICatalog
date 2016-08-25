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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImageDidTap(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "ライブラリから選択", style: .Default) { (action) in
            self.requestPickImageFromPhotoLibrary()
            }
        )
        actionSheet.addAction(UIAlertAction(title: "カメラで撮影", style: .Default) { (action) in
            self.requestPickImageFromCamera()
            }
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
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

private extension ImagePickerViewController {
    // カメラで撮影
    func requestPickImageFromCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.Camera) else {
            return
        }
        
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { [weak self] (result) in
            if result {
                dispatch_async(dispatch_get_main_queue()) {
                    self?.pickImage(from: .Camera)
                }
            }
        }
    }
    
    // 写真ライブラリから選択
    func requestPickImageFromPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) else {
            return
        }
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if status == .Authorized {
                dispatch_async(dispatch_get_main_queue()) {
                    self?.pickImage(from: .PhotoLibrary)
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
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //if let image = info[UIImagePickerControllerEditedImage] as? UIImage {    // cropped image
            self.imageView.image = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // cancelled
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}