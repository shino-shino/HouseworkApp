//
//  userSettingViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/12/11.
//

import UIKit
import NCMB

class userSettingViewController: UIViewController {
    
    @IBOutlet var nicknameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()
        // Do any additional setup after loading the view.
    }
    
    //MARK: backgroundColor()
        func backgroundColor() {
            //グラデーションの開始色
            let bottomColor = appColor.primary
            //let topColor = UIColor(red:0.07, green:0.13, blue:0.26, alpha:1)
            //グラデーションの開始色
            let topColor = UIColor(red:1, green:1, blue:1, alpha:1)
            //グラデーションの色を配列で管理
            let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
            //グラデーションレイヤーを作成
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            //グラデーションの色をレイヤーに割り当てる
            gradientLayer.colors = gradientColors
            //グラデーションレイヤーをスクリーンサイズにする
            gradientLayer.frame = self.view.bounds
            //グラデーションレイヤーをビューの一番下に配置
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
    

    //MARK: setNickname()
    func setNickname() {
        let user = NCMBUser.current()
        user!.setObject(nicknameTextField.text, forKey: "nickname")
    }
    
    //MARK: okButton()
    @IBAction func okButton() {
        setNickname()
    }

}
