//
//  TwicastLoginWebViewController.swift
//  TwicasHackathonTest
//
//  Created by HanedaKentarou on 2017/01/16.
//  Copyright © 2017年 com.adriablue. All rights reserved.
//
/* How to use.
 ＊ Twicast API
 http://apiv2-doc.twitcasting.tv/#introduction
 
 ---------------------
 vc.loginCompleteion = { (credential:TwicastCredential?, error:Error?) in
 if let credential = credential{
 print(credential)
 }
 }
 ---------------------
 
 */

import UIKit

struct TwicastCredential {
    let tokenType:String
    let expireDate:NSDate
    let accessToken:String
}

extension URL {
    var params: [String : String] {
        var results: [String : String] = [:]
        guard let urlComponents = NSURLComponents(string: self.absoluteString), let items = urlComponents.queryItems else {
            return results
        }
        
        for item in items {
            results[item.name] = item.value
        }
        
        return results
    }
}

var AccessToken: String = ""
var UserName: String = ""


class LoginWebViewController: UIViewController {
    
    var webView:UIWebView = UIWebView()
    var Get_Movie: String = ""
    
    // API Info
    let CLIENT_ID     = ""
    let CLIENT_SECRET = ""
    let CSRF_TOKEN    = ""
    let REDIRECT_URL  = ""
    var loginURL:URL?{
        get{
            return URL(string: "https://apiv2.twitcasting.tv/oauth2/authorize?client_id=\(CLIENT_ID)&response_type=code&state=\(CSRF_TOKEN)")
        }
    }
    
    var loginCompleteion = { (credential:TwicastCredential?, error:Error?) in
    }
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        self.view.addSubview(webView)
        
        if let requestURL = loginURL{
            webView.loadRequest(URLRequest(url: requestURL))
        }
        //self.Discrimination()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Discrimination() {
        let urlString: String = "https://apiv2.twitcasting.tv/verify_credentials"
        
        ServerProc().get(url: URL(string: urlString)!, completionHandler: { data, response, error in
            let datastr: String = NSString(data:data!, encoding:String.Encoding.utf8.rawValue) as! String
            //print(datastr)
            var parsedData :[String:AnyObject] = [:]
            do {
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
            var username = parsedData["user"]?["screen_id"]!
            UserName = username as! String
            print(parsedData["user"]?["screen_id"]!)
            
            self.Get_Movie = "https://apiv2.twitcasting.tv/users/\(username!)/current_live"
            
            print(self.Get_Movie)
            ServerProc().get(url: URL(string: self.Get_Movie)!, completionHandler: { data2, response2, error in
                let datastr2: String = NSString(data:data2!, encoding:String.Encoding.utf8.rawValue) as! String
                var parsedData2 :[String:AnyObject] = [:]
                do {
                    parsedData2 = try JSONSerialization.jsonObject(with: data2!, options: .allowFragments) as! [String:AnyObject]
                } catch let error as NSError {
                    print(error)
                }
                var movie = parsedData2["movie"]?["link"]
                
                //print("------------------")
                //print(parsedData2["movie"]?["link"])
                //print(response2)
                print(parsedData2)
                
                if parsedData2["movie"]?["link"] == nil {
                    let sc = ListPageController()
                    sc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                    self.present(sc, animated: true, completion: nil)
                } else {
                    //配信者
                    let sc = DetailsPageController()
                    sc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                    self.present(sc, animated: true, completion: nil)
                }
                
            })
            
        })
        
    }
}

extension LoginWebViewController:UIWebViewDelegate{
    
    // MARK: WebView Delegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url, url.absoluteString.contains(REDIRECT_URL){
            if let code = url.params["code"]{
                requestAccessToken(code: code)
            }
        }
        return true
    }
    
    func requestAccessToken(code:String){
        
        let urlString = "https://apiv2.twitcasting.tv/oauth2/access_token"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        // set the header(s)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // set the request-body(JSON)
        let params: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "redirect_uri":REDIRECT_URL,
            "code":code
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            do {
                guard let resp = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                    self.finish(credential: nil, error: error)
                    return
                }
                if let type = resp["token_type"] as? String,
                    let accessToken = resp["access_token"] as? String,
                    let expireIn = resp["expires_in"] as? Int{
                    let expireDate = NSDate(timeIntervalSinceNow: TimeInterval(expireIn))
                    let credential = TwicastCredential(tokenType: type, expireDate: expireDate, accessToken: AccessToken)
                    self.finish(credential: credential, error: nil)
                    AccessToken = accessToken
                    //
                    self.Discrimination()
                    
                }
                
                
            } catch  {
                self.finish(credential: nil, error: error)
                return
            }
        })
        task.resume()
    }
    
    func finish(credential:TwicastCredential?, error:Error?){
        self.loginCompleteion(credential, error)
        self.dismiss(animated: true, completion: nil)
    }
}
