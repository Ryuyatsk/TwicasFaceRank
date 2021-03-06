import UIKit

class DetailsPageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var PageSizeWidth:CGFloat = 0.0
    var PageSizeHeight:CGFloat = 0.0
    
    var myCollectionView : UICollectionView!
    var UserImageLeft: UIImageView!
    var UserImageRight: UIImageView!
    var selectNowIndex = 0
    var questionLabel: UILabel!
    var datas : [[String:AnyObject]] = [[:]]
    var perLabel: UILabel!
    var perLabel2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面サイズ代入
        PageSizeWidth = self.view.bounds.size.width
        PageSizeHeight = self.view.bounds.size.height
        
        self.view.backgroundColor = UIColor.black
        let url_str: String = ""
        let post_str: String = ""
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
        back_btn.addTarget(self, action: #selector(DetailsPageController.onClick_back_btn(_:)), for: .touchUpInside)
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
        
        
        UserImageLeft = UIImageView(frame : CGRect(x: 0, y: 0, width: contentsAreaLeft.frame.size.width, height: contentsAreaLeft.frame.size.height))
        contentsAreaLeft.addSubview(UserImageLeft)
        
        UserImageRight = UIImageView(frame : CGRect(x: 0, y: 0, width: contentsAreaLeft.frame.size.width, height: contentsAreaLeft.frame.size.height))
        contentsAreaRight.addSubview(UserImageRight)
        
        perLabel = UILabel(frame: CGRect(x: 0, y: 0, width: PageSizeWidth/2, height: contentsAreaLeft.frame.size.height))
        perLabel.text = "38%"
        perLabel.textAlignment = NSTextAlignment.center
        perLabel.font = UIFont.boldSystemFont(ofSize: 70)
        perLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        perLabel.layer.shadowOpacity = 0.8
        perLabel.layer.shadowRadius = 1
        perLabel.isHidden = true
        perLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1)
        UserImageLeft.addSubview(perLabel)
        
        
        perLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: PageSizeWidth/2, height: contentsAreaLeft.frame.size.height))
        perLabel2.text = "62%"
        perLabel2.textAlignment = NSTextAlignment.center
        perLabel2.font = UIFont.boldSystemFont(ofSize: 70)
        perLabel2.layer.shadowOffset = CGSize(width: 0, height: 1)
        perLabel2.layer.shadowOpacity = 0.8
        perLabel2.isHidden = true
        perLabel2.layer.shadowRadius = 1
        
        perLabel2.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1)
        UserImageRight.addSubview(perLabel2)
        
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        let CellUserImageSize: CGFloat = PageSizeWidth/4
        layout.itemSize = CGSize(width:CellUserImageSize, height:CellUserImageSize)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 200, 0)
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: PageSizeWidth/4,height:0)
        
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: CGRect( x: 0 , y: contentsArea.frame.size.height + contentsArea.frame.origin.y , width: PageSizeWidth, height: PageSizeHeight - contentsArea.frame.size.height + contentsArea.frame.origin.y), collectionViewLayout: layout)
        
        // Cellに使われるクラスを登録.
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.view.addSubview(myCollectionView)
        
        //戻るボタン
        let questionLabelSize: CGFloat = 240
        questionLabel = UILabel(frame: CGRect(x: PageSizeWidth/2 - questionLabelSize/2, y: PageSizeHeight - 50 - 3, width: questionLabelSize, height: 50))
        questionLabel.text = "アンケートを開始する"
        questionLabel.textAlignment = NSTextAlignment.center
        questionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        questionLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha:1)
        questionLabel.backgroundColor = UIColor(red:  57/255, green: 57/255, blue: 57/255, alpha:1)
        
        let questionLabelButton = UIButton(frame: CGRect(x: PageSizeWidth/2 - questionLabelSize/2, y: PageSizeHeight - 50 - 5, width: questionLabelSize, height: 50))
        questionLabelButton.addTarget(self, action: #selector(DetailsPageController.onClick_add_image_btn(_:)), for: .touchUpInside)
        self.view.addSubview(questionLabel)
        self.view.addSubview(questionLabelButton)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
        if selectNowIndex == 0 {
            let url_str2: String = "https://[]/img/\(datas[indexPath.row]["url"] as! String)"
            ServerProc().async_img(url: url_str2, funcs: {(img: UIImage) in
                self.UserImageLeft.image = img
                
            })
            selectNowIndex = 1
        }else{
            let url_str2: String = "https://[]/img/\(datas[indexPath.row]["url"] as! String)"
            ServerProc().async_img(url: url_str2, funcs: {(img: UIImage) in
                self.UserImageRight.image = img
                
            })
            UserImageRight.image = UIImage(named: "userBack")
            questionLabel.textColor = UIColor.white
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let CellUserImageSize: CGFloat = PageSizeWidth/4 - 8
        
        return CGSize(width: CellUserImageSize, height: CellUserImageSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell",
                                                                             for: indexPath as IndexPath)
        //画像読み込み
        let CellUserImageSize: CGFloat = PageSizeWidth/4
        
        let profileImg_area: UIView = UIView(frame : CGRect(x: 0, y: 0, width: CellUserImageSize, height: CellUserImageSize))
        let profileImg = UIImageView(frame : CGRect(x: 0, y: 0, width: CellUserImageSize, height: CellUserImageSize))
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
        
        if selectNowIndex == 1 {
            NSLog("ok")
            alertANQ()
        }else{
            NSLog("no")
        }
    }
    
    func alertANQ(){
        let alert: UIAlertController = UIAlertController(title: "アンケートをリスナーに送りますか？", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
        //送信ボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("------------------------------------")
            self.alertANQ1()
            self.perLabel.isHidden = false
            self.perLabel2.isHidden = false
        })
        
        //キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func alertANQ1(){
        let alert: UIAlertController = UIAlertController(title: "アンケートをリスナーに送ました！", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
        //送信ボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("------------------------------------")
            
        })
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
