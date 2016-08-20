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
    
    private var originalBottomLayoutConstraintValue: CGFloat!

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
    

    @IBAction func applyButtonDidTap(sender: AnyObject) {
        self.decorateOutputText()
        self.resignFirstResponder()
    }
}

extension TextViewScrollOrNotViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let alert = UIAlertController(title: "URLを開く", message: URL.absoluteString, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { (action) in
            UIApplication.sharedApplication().openURL(URL)
            }
        )
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        return false	// trueの場合、Safariで開く(AppDelegateは呼ばれない)
    }
}

private extension TextViewScrollOrNotViewController {
    func decorateOutputText() {
        let text = self.inputTextView.text
        let attributedString = NSMutableAttributedString(string: text)
        
        guard let regex = try? NSRegularExpression(pattern: "#\\w+", options: NSRegularExpressionOptions()) else {
            return
        }
        
        let matches = regex.matchesInString(text, options: NSMatchingOptions(), range: NSRange(location: 0, length: text.characters.count))
        for match in matches {
            print(match.range)
            let keywordRange = NSRange(
                location: match.range.location + 1,
                length: match.range.length - 1
            )
            let keyword = (text as NSString).substringWithRange(keywordRange) as String
            let URLString = "https://www.google.com/search?q=\(keyword)".stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let URL = NSURL(string: URLString!)!
            attributedString.addAttribute(NSLinkAttributeName, value: URL, range: match.range)
        }
        
        self.outputTextView.attributedText = attributedString
    }

    // キーボードの出入りを監視
    func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // キーボードの監視を解除
    func unregisterKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let animationDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else {
                return
        }
        
        // キーボードのサイズ分、bottomConstraintを拡張しテキストビューを縮める
        let keyboardSize = keyboardFrameValue.CGRectValue().size
        self.bottomLayoutConstraint.constant = self.originalBottomLayoutConstraintValue + keyboardSize.height
        let animationDuration = NSTimeInterval(animationDurationNumber.doubleValue)
        UIView.animateWithDuration(animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let animationDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        // 拡張したbottomConstraintを元に戻す
        self.bottomLayoutConstraint.constant = self.originalBottomLayoutConstraintValue
        let animationDuration = NSTimeInterval(animationDurationNumber.doubleValue)
        UIView.animateWithDuration(animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
