import UIKit

//change StatusbarColor class
class StatusCollor{
    
    func white(){
        //白くする
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    func black(){
        //黒くする
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    func white_nofade(){
        //白くする
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    func black_nofades(){
        //黒くする
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
    }
}

