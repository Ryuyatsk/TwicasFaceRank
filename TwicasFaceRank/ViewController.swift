import UIKit

struct TwicastCredential {
    let tokenType:String
    let expireDate:NSDate
    let accessToken:String
}

class ViewController: UIViewController,UIWebViewDelegate{
    private var myTableView: UITableView!
    var group_id: String = ""
    var invites: [String:Any] = [:]
    var users: [[String:AnyObject]] = [[:]]
    var font_size: CGFloat = 0.0
    var UserGoButton: UIButton?
    // API Info
    let CLIENT_ID     = "709129217804341248.7f1d6781faad2e207a1f3b8c76babf9d5d254f23ca7c9cdcc257284fda314e82"
    let CLIENT_SECRET = "76b2a58fe1380c61c68a916a2cd903386034d4212a73281a0ba87e787a4f0b02"
    let CSRF_TOKEN    = "yama"
    let REDIRECT_URL  = "https://twicas.syo.tokyo/"
    var loginCompleteion = { (credential:TwicastCredential?, error:Error?) in
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景白くする
        self.view.backgroundColor = UIColor.white
        
        //ヘッダーエリア
        let header_area = UIView(frame : CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 65))
        header_area.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(header_area)
        
        //灰色の線
        let bar3 = UIView(frame : CGRect(x: 0, y: header_area.frame.size.height - 1, width: self.view.frame.size.width , height: 1))
        bar3.backgroundColor = UIColor(red: 0.9, green: 0.9, blue:0.9 , alpha: 1)
        header_area.addSubview(bar3)
        
   
        //戻るボタンuibutton
        let img_up_button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: header_area.frame.size.height))
        img_up_button.addTarget(self, action: #selector(ViewController.back_button_func(_:)), for: .touchUpInside)
        header_area.addSubview(img_up_button)
        
        //webview初期化
        var webview = UIWebView(frame: CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: self.view.frame.size.height - 65))
        webview.delegate = self
        self.view.addSubview(webview)
        
        var clientId = "709129217804341248.7f1d6781faad2e207a1f3b8c76babf9d5d254f23ca7c9cdcc257284fda314e82"
        let url: String  = "https://apiv2.twitcasting.tv/oauth2/authorize?client_id=\(clientId)&response_type=code&state=yama"
        //web表示
        let targetURL: String = url
        let requestURL = NSURL(string: targetURL)
        print(requestURL)
        let req = NSURLRequest(url: requestURL as! URL)
        webview.loadRequest(req as URLRequest)
        
    }
    
    //Pageが全て読み終わったら呼ばれる.
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
        print(webView.stringByEvaluatingJavaScript(from: "document.URL") as Any)
        var str = "\(webView.stringByEvaluatingJavaScript(from: "document.URL") as Any)"
        
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
            "redirect_uri": REDIRECT_URL,
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
                    let credential = TwicastCredential(tokenType: type, expireDate: expireDate, accessToken: accessToken)
                    self.finish(credential: credential, error: nil)
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
    
    //戻るボタン
    func back_button_func(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
