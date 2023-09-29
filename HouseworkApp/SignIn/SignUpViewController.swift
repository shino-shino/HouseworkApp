//
//  SignUpViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/06.
//

import UIKit
import NCMB
import PKHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    var mailAddress: String!
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundColor()
        signUpButton.isHidden = true
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
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
    
    //MARK: signUp()
    @IBAction func signUp() {
        let user = NCMBUser()
        user.mailAddress = mailAddress
        user.userName = mailAddress
        
        if passwordTextField.text == confirmPasswordTextField.text {
            user.password = passwordTextField.text!
        } else {
            HUD.flash(.labeledError(title: "不一致", subtitle: "パスワードが一致していません"),delay: 1.5)
            print("パスワードの不一致")
            return
        }
        
        user.signUpInBackground { error in
            if error != nil {
                print("signUpError")
                HUD.flash(.labeledError(title: "エラー", subtitle: "すでに使用されているメールアドレスです"),delay: 1.5)
            } else {
                let storyboard = UIStoryboard(name: "SignInFamily", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootFamilyNavigationController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                // keep login
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
        }
    }
    
    @IBAction func agreementButton (sender: UISwitch) {
        if (sender.isOn) {
            signUpButton.isHidden = false
        } else {
            signUpButton.isHidden = true
        }
    }
}

