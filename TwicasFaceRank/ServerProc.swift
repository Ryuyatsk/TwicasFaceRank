import UIKit

class ServerProc{
    let condition = NSCondition()
    let session: URLSession = URLSession.shared
    
    //非同期処理
    func async(url:String,post:String,funcs: @escaping ([String:Any]) -> Void){
        print(post)
        var r = URLRequest(url:URL(string: url)!)
        r.httpMethod = "POST"
        r.httpBody = post.data(using: String.Encoding.utf8)
        
        var parsedData :[String:Any] = [:]
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            print(data)
            if error != nil {
                print(error)
            } else {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            //関数実行
            funcs(parsedData)
        }
        task.resume()
    }
    
    //同期処理
    func sync(url:String,post:String) -> [String:Any]{
        
        var r = URLRequest(url:URL(string: url)!)
        r.httpMethod = "POST"
        r.httpBody = post.data(using: String.Encoding.utf8)
        
        var parsedData :[String:Any] = [:]
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error != nil {
                print(error)
            } else {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            self.condition.signal()
            self.condition.unlock()
        }
        self.condition.lock()
        task.resume()
        self.condition.wait()
        self.condition.unlock()
        return parsedData
    }
    
    //非同期画像処理
    func async_img(url:String,funcs: @escaping (UIImage) -> Void){
        
        var u:URL?
        if( url.range(of: "Error") == nil){
            u = URL(string:url)
        }
        let r = URLRequest(url:u!)
        NSURLConnection.sendAsynchronousRequest(r, queue:OperationQueue.main){(res, data, err) in
            let httpResponse = res as? HTTPURLResponse
            var im = UIImage()
            if data != nil && httpResponse!.statusCode != 404{
                im = UIImage(data:data!)!
            }
            //関数実行
            funcs(im)
        }
    }
    func twicas_user(url2:String,accessToken:String,funcs: @escaping ([String:Any]) -> Void){
        //更新
        let url = URL(string: url2)
        var urlRequest_img = URLRequest(url:url!)
        if let u = url{
            urlRequest_img.url = u
            urlRequest_img.httpMethod = "POST"
            urlRequest_img.timeoutInterval = 60.0
        }
        
        let uniqueId = ProcessInfo.processInfo.globallyUniqueString
        let body: NSMutableData = NSMutableData()
        var postData :String = String()
        let boundary:String = "---------------------------\(uniqueId)"
        
        urlRequest_img.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        postData += "--\(boundary)\r\n"
        
        //USER_ID
        postData += "Accept: application/json\n"
        postData += "X-Api-Version: 2.0\n"
        postData += "Authorization: Bearer \(accessToken)\n"
        
        postData = String()
        postData += "\r\n"
        postData += "\r\n--\(boundary)--\r\n"
        
        body.append(postData.data(using: String.Encoding.utf8)!)
        
        urlRequest_img.httpBody = NSData(data:body as Data) as Data
        
        let task = URLSession.shared.dataTask(with: urlRequest_img) { (data, response, error) in
            var parsedData: [String:Any] = [:]
            do {
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                
            } catch _ as NSError {
                
            }
            self.condition.signal()
            self.condition.unlock()
            
        }
        self.condition.lock()
        task.resume()
        self.condition.wait()
        self.condition.unlock()
    }
    
    // GET METHOD
    func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("2.0", forHTTPHeaderField: "X-Api-Version")
        request.addValue("Bearer \(AccessToken)", forHTTPHeaderField: "Authorization")
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
