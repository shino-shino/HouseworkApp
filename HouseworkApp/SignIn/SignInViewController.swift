//
//  SignInViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/06.
//

import UIKit
import NCMB
import PKHUD

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var mailAdressTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.view.backgroundColor = UIColor.white
        backgroundColor()

        mailAdressTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    //MARK: signIn()
    @IBAction func signIn() {
        if mailAdressTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
//            NCMBUser.logInWithMailAddress(inBackground: mailAdressTextField.text, password: passwordTextField.text) { (user, error) in
//                if error != nil {
//                    print("SignInError")
//                    HUD.flash(.labeledError(title: "不一致", subtitle: "”メールアドレス”または”パスワード”が違います"),delay: 1.5)
//                } else {
//                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
//                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
//
//                    // keep login
//                    let ud = UserDefaults.standard
//                    ud.set(true, forKey: "isLogin")
//                    ud.set(true, forKey: "isLoginFamily")
//                    ud.synchronize()
//                }
//            }
            NCMBUser.logInWithUsername(inBackground: mailAdressTextField.text, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    print("SignInError")
                    HUD.flash(.labeledError(title: "不一致", subtitle: "”メールアドレス”または”パスワード”が違います"),delay: 1.5)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController

                    // keep login
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.set(true, forKey: "isLoginFamily")
                    ud.synchronize()
                }
            }
        }
    }
}
