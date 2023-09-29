//
//  SignUpMailAddressViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/12/11.
//

import UIKit
import PKHUD

class SignUpMailAddressViewController: UIViewController, UITextFieldDelegate {
    
    //@IBOutlet var nextButton: UIButton!
    @IBOutlet var mailAddressTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        mailAddressTextField.delegate = self
        
        backgroundColor()
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
    

    //MARK: mailAddressConfirm()
    @IBAction func mailAddressConfirm() {
        let emailIsEmpty = mailAddressTextField.text?.isEmpty ?? true
        if (!emailIsEmpty && validateEmail(candidate: mailAddressTextField.text!)) {
            self.performSegue(withIdentifier: "toSignUp", sender: nil)
        } else {
            HUD.flash(.labeledError(title: "不一致", subtitle: "”有効なメールアドレスを入力してください"),delay: 1.5)
            return
        }
    }
    
    //MARK: validateEmail
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        }
    
    //MARK: prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp"{
            let signUpViewController = segue.destination as! SignUpViewController

            signUpViewController.mailAddress = mailAddressTextField.text
        }
    }
}

