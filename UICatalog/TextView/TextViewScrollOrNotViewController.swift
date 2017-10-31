//
//  TextViewScrollOrNotViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/20.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

// NOTE:
// * outputTextViewは以下の属性変更を行っている
//     * Scrolling Enabledをオフ (intrinstic sizeが与えられ全文表示される)
//     * Editableをオフ (リンクタップに反応するようになる)
class TextViewScrollOrNotViewController: UIViewController {

    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    fileprivate var originalBottomLayoutConstraintValue: CGFloat!

    deinit {
        self.unregisterKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.originalBottomLayoutConstraintValue = self.bottomLayoutConstraint.constant
        
        self.registerKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func applyButtonDidTap(_ sender: AnyObject) {
        self.decorateOutputText()
        self.resignFirstResponder()
    }
}

extension TextViewScrollOrNotViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let alert = UIAlertController(title: "URLを開く", message: URL.absoluteString, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
            UIApplication.shared.openURL(URL)
            }
        )
        
        self.present(alert, animated: true, completion: nil)
        
        return false	// trueの場合、Safariで開く(AppDelegateは呼ばれない)
    }
}

fileprivate extension TextViewScrollOrNotViewController {
    func decorateOutputText() {
        guard let text = self.inputTextView.text else {
            fatalError()
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        guard let regex = try? NSRegularExpression(pattern: "#\\w+", options: NSRegularExpression.Options()) else {
            return
        }
        
        let matches = regex.matches(in: text, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: text.characters.count))
        for match in matches {
            print(match.range)
            let keywordRange = NSRange(
                location: match.range.location + 1,
                length: match.range.length - 1
            )
            
            let keyword = (text as NSString).substring(with: keywordRange)
            let URLString = "https://www.google.com/search?q=\(keyword)".removingPercentEncoding

            let URL = Foundation.URL(string: URLString!)!
            attributedString.addAttribute(.link, value: URL, range: match.range)
        }
        
        self.outputTextView.attributedText = attributedString
    }

    // キーボードの出入りを監視
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // キーボードの監視を解除
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrameValue = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let animationDurationNumber = (notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else {
                return
        }
        
        // キーボードのサイズ分、bottomConstraintを拡張しテキストビューを縮める
        let keyboardSize = keyboardFrameValue.cgRectValue.size
        self.bottomLayoutConstraint.constant = self.originalBottomLayoutConstraintValue + keyboardSize.height
        let animationDuration = TimeInterval(animationDurationNumber.doubleValue)
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let animationDurationNumber = (notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        // 拡張したbottomConstraintを元に戻す
        self.bottomLayoutConstraint.constant = self.originalBottomLayoutConstraintValue
        let animationDuration = TimeInterval(animationDurationNumber.doubleValue)
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
}
