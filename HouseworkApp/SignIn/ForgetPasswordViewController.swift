//
//  ForgetPasswordViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/29.
//

import UIKit
import NCMB

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet var mailAdressTextField: UITextField!

    //MARK: viewDidLoad()
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
    
    //MARK: sendMail()
    @IBAction func sendMail() {
        NCMBUser.requestPasswordResetForEmail(inBackground: mailAdressTextField.text) { error in
            if error != nil {
                // 会員登録用のメール要求に失敗した場合の処理
                print("会員登録用メールの要求に失敗しました: \(error)")
            } else {
                let alertController = UIAlertController(title: "送信完了", message: "メール送信が完了しました。", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                
                // 会員登録用メールの要求に成功した場合の処理
                print("会員登録用メールの要求に成功しました")
            }
        }
//        メール認証
//        var error : NSError? = nil
//        NCMBUser.requestAuthenticationMail(mailAdressTextField.text, error: &error)
//        if (error != nil) {
//          print(error ?? "")
//        }
    }

}
