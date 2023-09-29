//
//  ViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/06.
//

import UIKit

class ViewController: UIViewController {
    
    var logoImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //imageView作成
        self.logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        //画面centerに
        self.logoImageView.center = self.view.center
        //logo設定
        self.logoImageView.image = UIImage(named: "when_starting")
        //viewに追加
        self.view.addSubview(self.logoImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3, delay: 1.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () in
            self.logoImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                }, completion: { (Bool) in
            })
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.5, delay: 1.3, options: UIView.AnimationOptions.curveEaseOut, animations: { () in
            self.logoImageView.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                    self.logoImageView.alpha = 0
                }, completion: { (Bool) in
                    self.logoImageView.removeFromSuperview()
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
            })
    }
    
}

