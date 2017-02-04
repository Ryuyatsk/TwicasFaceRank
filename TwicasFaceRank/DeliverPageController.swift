import UIKit

class DeliverPageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var PageSizeWidth:CGFloat = 0.0
    var PageSizeHeight:CGFloat = 0.0
    
    var myCollectionView : UICollectionView!
    let condition = NSCondition()
    
    var UserImageLeft: UIImageView!
    var UserImageRight: UIImageView!
    
    var imageData: Data!
    var video_id: String = ""
    
    var datas : [[String:AnyObject]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面サイズ代入
        PageSizeWidth = self.view.bounds.size.width
        PageSizeHeight = self.view.bounds.size.height
        
        self.view.backgroundColor = UIColor.black
        let url_str: String = "https://twicas.syo.tokyo/res.php"
        let post_str: String = "name=1"
        let anydata: [String:Any] = ServerProc().sync(url: url_str, post: post_str)
        print(anydata)
        datas = anydata["res"] as! [[String:AnyObject]]
        
        
        //ヘッダーエリア
        let header_area = UIView(frame : CGRect(x: 0, y: 0, width: PageSizeWidth, height: 55))
        header_area.backgroundColor = UIColor(red:  0.1, green: 0.1 ,blue: 0.1, alpha:1)
        self.view.addSubview(header_area)
        
        //タイトル
        let header_title = UILabel(frame : CGRect( x: 50 , y: 15 , width: PageSizeWidth - 100, height: 40))
        header_title.text = "FaceRank"
        header_title.textAlignment = NSTextAlignment.center
        header_title.textColor = UIColor(red:  1, green: 1, blue:  1, alpha: 1)
        header_title.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        header_area.addSubview(header_title)
        
        //戻るボタン
        let myImage2 = UIImage(named: "back")
        let ratio: CGFloat = (myImage2?.size.width)!/(myImage2?.size.height)!
        let back_btn_img = UIImageView(frame : CGRect(x: 10, y: 25 , width: 20*ratio, height: 20))
        let back_btn = UIButton(frame : CGRect(x: 0 , y: 15 , width: 55, height: 55))
        back_btn_img.image = myImage2
        back_btn.addTarget(self, action: #selector(DeliverPageController.onClick_back_btn(_:)), for: .touchUpInside)
        header_area.addSubview(back_btn_img)
        header_area.addSubview(back_btn)
        
        
        //contents
        let ImageheightSIize: CGFloat = 300
        let contentsArea = UIView(frame : CGRect(x: 0, y: header_area.frame.size.height, width: PageSizeWidth, height: ImageheightSIize))
        contentsArea.backgroundColor = UIColor(red:  57/255, green: 57/255, blue: 57/255, alpha:1)
        self.view.addSubview(contentsArea)
        
        
        let myImage = UIImage(named: "userBack")
        let userBackSize: CGFloat = 80
        let ratiomyImage: CGFloat = (myImage?.size.width)!/(myImage?.size.height)!
        
        
        let contentsAreaLeft = UIView(frame : CGRect(x: 0, y: 0, width: PageSizeWidth/2, height: ImageheightSIize))
        contentsArea.addSubview(contentsAreaLeft)
        
        
        let contentsAreaBar = UIView(frame : CGRect(x: PageSizeWidth/2, y: header_area.frame.size.height, width: 1, height: ImageheightSIize))
        contentsAreaBar.backgroundColor = UIColor(red:  0.1, green: 0.1 ,blue: 0.1, alpha:1)
        self.view.addSubview(contentsAreaBar)
        
        let UserBackImg = UIImageView(frame : CGRect(x: contentsAreaLeft.frame.size.width/2 - userBackSize/2, y: contentsAreaLeft.frame.size.height/2 - userBackSize/2 , width: userBackSize*ratiomyImage, height: userBackSize))
        UserBackImg.image = myImage
        contentsAreaLeft.addSubview(UserBackImg)
        
        let contentsAreaRight = UIView(frame : CGRect(x: PageSizeWidth/2, y: 0, width: PageSizeWidth/2, height: ImageheightSIize))
        contentsArea.addSubview(contentsAreaRight)
        
        let UserBackImg2 = UIImageView(frame : CGRect(x: contentsAreaRight.frame.size.width/2 - userBackSize/2, y: contentsAreaRight.frame.size.height/2 - userBackSize/2 , width: userBackSize*ratiomyImage, height: userBackSize))
        UserBackImg2.image = myImage
        contentsAreaRight.addSubview(UserBackImg2)
        
        
        
        //顔の画像
        UserImageLeft = UIImageView(frame : CGRect(x: 0, y: 0, width: contentsAreaLeft.frame.size.width, height: contentsAreaLeft.frame.size.height))
        UserImageLeft.isHidden = true
        contentsAreaLeft.addSubview(UserImageLeft)
        
        UserImageRight = UIImageView(frame : CGRect(x: 0, y: 0, width: contentsAreaLeft.frame.size.width, height: contentsAreaLeft.frame.size.height))
        UserImageRight.isHidden = true
        contentsAreaRight.addSubview(UserImageRight)
        
        var perLabel = UILabel(frame: CGRect(x: 0, y: 0, width: PageSizeWidth/2, height: contentsAreaLeft.frame.size.height))
        perLabel.text = "38%"
        perLabel.textAlignment = NSTextAlignment.center
        perLabel.font = UIFont.boldSystemFont(ofSize: 70)
        perLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        perLabel.layer.shadowOpacity = 0.8
        perLabel.layer.shadowRadius = 1
        perLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1)
        UserImageLeft.addSubview(perLabel)
        
        
        var perLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: PageSizeWidth/2, height: contentsAreaLeft.frame.size.height))
        perLabel2.text = "62%"
        perLabel2.textAlignment = NSTextAlignment.center
        perLabel2.font = UIFont.boldSystemFont(ofSize: 70)
        perLabel2.layer.shadowOffset = CGSize(width: 0, height: 1)
        perLabel2.layer.shadowOpacity = 0.8
        perLabel2.layer.shadowRadius = 1
        
        perLabel2.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1)
        UserImageRight.addSubview(perLabel2)
        
        
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        let CellUserImageSize: CGFloat = PageSizeWidth/2
        layout.itemSize = CGSize(width:CellUserImageSize, height:CellUserImageSize)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 120, 0)
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: PageSizeWidth/2,height:0)
        
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: CGRect( x: 0 , y: contentsArea.frame.size.height + contentsArea.frame.origin.y , width: PageSizeWidth, height: PageSizeHeight - contentsArea.frame.size.height + contentsArea.frame.origin.y), collectionViewLayout: layout)
        
        // Cellに使われるクラスを登録.
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.view.addSubview(myCollectionView)
        
        
        //戻るボタン
        let ImageAddSize: CGFloat = 60
        let myImageAdd = UIImage(named: "addImage")
        let AddImageView = UIImageView(frame : CGRect(x: PageSizeWidth - ImageAddSize - 5, y: PageSizeHeight - ImageAddSize - 5, width: ImageAddSize, height: ImageAddSize))
        let AddImageViewButton = UIButton(frame : CGRect(x: PageSizeWidth - ImageAddSize - 5, y: PageSizeHeight - ImageAddSize - 5, width: ImageAddSize, height: ImageAddSize))
        AddImageView.image = myImageAdd
        AddImageViewButton.addTarget(self, action: #selector(DeliverPageController.onClick_add_image_btn(_:)), for: .touchUpInside)
        self.view.addSubview(AddImageView)
        self.view.addSubview(AddImageViewButton)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let CellUserImageSize: CGFloat = PageSizeWidth/2 - 5
        
        return CGSize(width: CellUserImageSize, height: CellUserImageSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell",
                                                                             for: indexPath as IndexPath)
        //画像読み込み
        let CellUserImageSize: CGFloat = PageSizeWidth/2
        let profileImg_area: UIView = UIView(frame : CGRect(x: 0, y: 0, width: CellUserImageSize, height: CellUserImageSize))
        let profileImg = UIImageView(frame : CGRect(x: 0, y: 0, width: CellUserImageSize, height: CellUserImageSize))
        profileImg.layer.shadowOpacity = 0.8
        cell.contentView.addSubview(profileImg_area)
        profileImg_area.addSubview(profileImg)
        
        let url_str2: String = "https://[]/img/\(datas[indexPath.row]["url"] as! String)"
        ServerProc().async_img(url: url_str2, funcs: {(img: UIImage) in
            profileImg.image = img
            
            profileImg.center.x = profileImg_area.frame.size.width/2
            profileImg.center.y = profileImg_area.frame.size.height/2
            profileImg_area.layer.masksToBounds = true
            
            //画像比率調整
            if(img.size.width < img.size.height){
                
                profileImg.frame = CGRect(x: 0,y: 0,width: profileImg.frame.size.width ,  height: (profileImg.frame.size.width)*CGFloat((img.size.height)/(img.size.width)) )
            }else{
                profileImg.frame = CGRect(x: 0,y: 0,width: profileImg.frame.size.width*CGFloat((img.size.width)/(img.size.height)) ,  height: (profileImg.frame.size.height) )
            }
        })
        
        
        var perLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CellUserImageSize, height: CellUserImageSize))
        if indexPath.row%2 == 0 {
            perLabel.text = "30%"
        }else{
            perLabel.text = "70%"
        }
        perLabel.textAlignment = NSTextAlignment.center
        perLabel.font = UIFont.boldSystemFont(ofSize: 60)
        perLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        perLabel.layer.shadowOpacity = 0.8
        perLabel.layer.shadowRadius = 1
        
        perLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1)
        profileImg_area.addSubview(perLabel)
        
        return cell
    }
    
    
    
    //戻るボタン
    internal func onClick_back_btn(_ sender: UIButton){
        self.dismiss(animated: true, completion: {
            
            StatusCollor().black_nofades()
            
        })
    }
    
    //追加ボタン
    internal func onClick_add_image_btn(_ sender: UIButton){
        NSLog("ok")
        img_select_page()
    }
    
    //画像選択
    func img_select_page(){
        
        NSLog("onclick2")
        // フォトライブラリを使用できるか確認
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //選択されたら
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String: Any]) {
        
        if didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] != nil {
            print(didFinishPickingMediaWithInfo)
            
            imageData = NSData(data:UIImageJPEGRepresentation(didFinishPickingMediaWithInfo[UIImagePickerControllerEditedImage] as! UIImage, 1.0)!) as Data
        }
        
        //写真選択後にカメラロール表示ViewControllerを引っ込める動作
        picker.dismiss(animated: true, completion: {
            
            let n  = Foundation.Notification(name: NSNotification.Name(rawValue: "escape_group_noti"), object: self, userInfo: ["value": 100])
            //通知を送る
            NotificationCenter.default.post(n)
            
            self.alertYESNO()
        })
    }
    
    func alertYESNO(){
        let alert: UIAlertController = UIAlertController(title: "この画像で送信してもよろしいですか？", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
        //送信ボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "送信する", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            
            print("------------------------------------")
            
            
            //更新
            let url = URL(string: "https://[]/add_image.php")
            var urlRequest_img = URLRequest(url:url!)
            if let u = url{
                urlRequest_img.url = u
                urlRequest_img.httpMethod = "POST"
                urlRequest_img.timeoutInterval = 30.0
            }
            
            let uniqueId = ProcessInfo.processInfo.globallyUniqueString
            let body: NSMutableData = NSMutableData()
            var postData :String = String()
            let boundary:String = "---------------------------\(uniqueId)"
            
            urlRequest_img.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            postData += "--\(boundary)\r\n"
            
            //ユーザID
            postData += "Content-Disposition: form-data; name=\"user_id\"\r\n"
            postData += "\r\nID\r\n"
            postData += "--\(boundary)\r\n"
            
            //画像アップロード
            postData += "Content-Disposition: form-data; name=\"image\"; filename=\"imgname\"\r\n"
            postData += "Content-Type: image/jpeg\r\n\r\n"
            body.append(postData.data(using: String.Encoding.utf8)!)
            body.append(self.imageData)
            
            postData = String()
            postData += "\r\n"
            postData += "\r\n--\(boundary)--\r\n"
            
            body.append(postData.data(using: String.Encoding.utf8)!)
            
            urlRequest_img.httpBody = NSData(data:body as Data) as Data
            
            let task = URLSession.shared.dataTask(with: urlRequest_img) { (data, response, error) in
                var parsedData: [String:Any] = [:]
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                    print("------------------")
                    print(data)
                    if(parsedData != nil){
                        print(parsedData)
                    }else{
                        
                    }
                    
                } catch _ as NSError {
                    
                }
                
                self.condition.signal()
                self.condition.unlock()
                
            }
            self.condition.lock()
            task.resume()
            self.condition.wait()
            self.condition.unlock()
            
            
            
            let url_str2: String = "https://[]/img/\(self.datas[3]["url"] as! String)"
            ServerProc().async_img(url: url_str2, funcs: {(img: UIImage) in
                self.UserImageLeft.isHidden = false
                self.UserImageLeft.image = img
                
            })
            let url_str1: String = "https://[]/img/\(self.datas[2]["url"] as! String)"
            ServerProc().async_img(url: url_str1, funcs: {(img: UIImage) in
                self.UserImageRight.isHidden = false
                self.UserImageRight.image = img
                
            })
            
        })
        
        //キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
