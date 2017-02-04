//
//  ViewController.swift
//  TwicasFaceRank
//
//  Created by 福本 on 2017/01/28.
//  Copyright © 2017年 Fukumoto. All rights reserved.
//

import UIKit


class ListPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //画面サイズ変数
    var PageSizeWidth:CGFloat = 0.0
    var PageSizeHeight:CGFloat = 0.0
    var myImageView: UIImageView!
    var supportingData: [[String:AnyObject]] = [[:]]
    
    fileprivate var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //動画の情報一覧取得
        getVideoInfo()
        
        //画面サイズ代入
        PageSizeWidth = self.view.bounds.size.width
        PageSizeHeight = self.view.bounds.size.height
        
        //ヘッダーエリア
        let header_area = UIView(frame : CGRect(x: 0, y: 0, width: PageSizeWidth, height: 55))
        header_area.backgroundColor = UIColor(red:  1, green: 1 ,blue: 1, alpha:1)
        self.view.addSubview(header_area)
        
        //線表示
        let bar2 = UIView(frame : CGRect(x: 0, y: 55 - 1 , width: PageSizeWidth , height: 1))
        bar2.backgroundColor = UIColor(red: 234/255, green: 234/255, blue:234/255, alpha: 1)
        header_area.addSubview(bar2)
        
        //タイトル
        let header_title = UILabel(frame : CGRect( x: 50 , y: 15 , width: PageSizeWidth - 100, height: 40))
        header_title.text = "配信主一覧"
        header_title.textAlignment = NSTextAlignment.center
        header_title.textColor = UIColor(red:  0.1, green: 0.1, blue:  0.1, alpha: 1)
        header_title.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        header_area.addSubview(header_title)
        
        
        //テーブルの描画
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        myTableView = UITableView(frame: CGRect(x: 0, y:header_area.frame.size.height , width: displayWidth, height: displayHeight - header_area.frame.size.height ))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorColor = UIColor.clear
        self.view.addSubview(myTableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //選択されたら
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: ok")
        
        if indexPath.row == 0 {
            let sc = DetailsPageController()
            sc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(sc, animated: true, completion: nil)
        }else{
            let sc = DeliverPageController()
            sc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            sc.video_id = "\(self.supportingData[indexPath.row]["id"])"
            self.present(sc, animated: true, completion: nil)
        }
        
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.supportingData.count
    }
    
    //セルのサイズ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71.0
    }
    
    //セルのview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyCell")
        
        //選択しても変えない
        cell.selectionStyle = .none
        
        //画像読み込み
        var url2:URL?
        let tmp_user_str_img : String = "\(self.supportingData[indexPath.row]["image"] as! String)"
        if( tmp_user_str_img.range(of: "Error") == nil){
            url2 = URL(string: tmp_user_str_img)
        }else{
            //url2 = URL(string:"\(DefineViriable.serverurl)user_img/miss_img.png")
        }
        let req2 = URLRequest(url:url2!)
        
        NSURLConnection.sendAsynchronousRequest(req2, queue:OperationQueue.main){(res, data, err) in
            let httpResponse = res as? HTTPURLResponse
            var image2 = UIImage(named: "Theme_img")
            if data != nil && httpResponse!.statusCode != 404{
                image2 = UIImage(data:data!)
            }
            
            let myImageView_area = UIImageView(frame: CGRect(x: 0,y: 0,width: 71,height: 71))
            myImageView_area.layer.masksToBounds = true
            
            cell.contentView.addSubview(myImageView_area)
            
            self.myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 71,height: 71))
            
            let img_ratio = image2!.size.height/image2!.size.width
            self.myImageView!.frame = CGRect(x: 0,y: 0 ,width: 71/img_ratio,height: 71)
            
            self.myImageView.image = image2
            
            // UIImageViewをViewに追加する.
            myImageView_area.addSubview(self.myImageView)
        }
        
        
        // 企画名の表示
        let proposal_title = UILabel(frame: CGRect(x: 71 + 10,y: 8 ,width: self.view.frame.size.width - 71 ,height: 22))
        proposal_title.text = "\(self.supportingData[indexPath.row]["name"] as! String)"
        proposal_title.textColor = UIColor(red: 34/255, green: 45/255, blue: 51/255, alpha: 1)
        proposal_title.font = UIFont.boldSystemFont(ofSize: 16)
        proposal_title.numberOfLines = 2
        cell.addSubview(proposal_title)
        
        
        // 最新のメッセージの表示
        let latest_message = UILabel(frame: CGRect(x: 71 + 10, y:proposal_title.frame.origin.y + proposal_title.frame.size.height + 0 , width: self.view.frame.size.width - 75 , height:20))
        latest_message.text = "\(self.supportingData[indexPath.row]["profile"] as! String)"
        //                print(self.SupportList[i]["image"])
        //                print(self.SupportList[i]["name"])
        //                print(self.SupportList[i]["last_movie_id"])
        latest_message.font = UIFont.systemFont(ofSize: 14)
        latest_message.numberOfLines = 2
        latest_message.textColor = UIColor(red: 34/255, green: 45/255, blue: 51/255, alpha:0.5)
        latest_message.sizeToFit()
        cell.addSubview(latest_message)
        
        
        let bar1 = UIView(frame : CGRect(x: 0,y: 70, width: self.view.frame.size.width, height: 1))
        bar1.backgroundColor = UIColor(red: 242/255, green: 242/255, blue:242/255, alpha: 1)
        cell.addSubview(bar1)
        
        return cell
    }
    
    
    func getVideoInfo(){
        
        let urlString: String = "https://apiv2.twitcasting.tv/users/\(UserName)/supporting?offset=0&limit=20"
        
        ServerProc().get(url: URL(string: urlString)!, completionHandler: { data, response, error in
            let datastr: String = NSString(data:data!, encoding:String.Encoding.utf8.rawValue) as! String
            var parsedData :[String:AnyObject] = [:]
            do {
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
            
            //print("------------------")
            self.supportingData = parsedData["supporting"] as! [[String : AnyObject]]
            
//            for i in 0 ..< 20 {
//                self.SupportList[i]["image"]
//                self.SupportList[i]["name"]
//                self.SupportList[i]["last_movie_id"]
//                print(self.SupportList[i]["image"])
//                print(self.SupportList[i]["name"])
//                print(self.SupportList[i]["last_movie_id"])
//            }
            //print(response2)
            //print(movie)
            
        })
        
    }
    
}

