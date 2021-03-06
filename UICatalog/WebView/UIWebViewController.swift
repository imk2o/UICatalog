//
//  UIWebViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class UIWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialURL = URL(string: "https://www.apple.com/jp")!
        let request = URLRequest(url: initialURL)
//        // NOTE: ローカルキャッシュを使用しないリクエスト
//        let request = NSURLRequest(
//            URL: initialURL,
//            cachePolicy: .ReloadIgnoringLocalCacheData,
//            timeoutInterval: 60.0
//        )
        
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension UIWebViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
//        // レスポンスをキャッシュしないリクエストに補正するハック
//        // 本来ならサーバからCache-Control: no-cacheでレスポンスすべきだが...
//        if
//            let mutableURLRequest = request as? NSMutableURLRequest
//            where request.cachePolicy != .ReloadIgnoringLocalCacheData
//        {
//            mutableURLRequest.cachePolicy = .ReloadIgnoringLocalCacheData
//        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // <title>タグの内容を取得し、ナビバータイトルに表示
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title") {
            self.navigationItem.title = title
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
            // 通信がキャンセルされた
        } else {
            print(error)
        }
    }

//    // 非公開デリゲートメソッド(iOS7〜9動作確認済)
//    // Webページ内全てのHTTPリクエストの前に呼び出される
//    // カスタムのヘッダを付与する場合などに便利
//    func uiWebView(
//        webView: UIWebView,
//        resource identifier: AnyObject,
//                 willSendRequest request: NSURLRequest,
//                                 redirectResponse: NSURLResponse,
//                                 fromDataSource dataSource: AnyObject
//        ) -> NSURLRequest {
//        
//        if let mutableURLRequest = request as? NSMutableURLRequest {
//            mutableURLRequest.setValue("VALUE", forHTTPHeaderField: "MY-CUSTOM-HEADER")
//        }
//        
//        return request
//    }
}
