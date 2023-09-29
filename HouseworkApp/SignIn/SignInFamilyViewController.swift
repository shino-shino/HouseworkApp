//
//  SignInFamilyViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/06.
//

import UIKit
import NCMB
import PKHUD

class SignInFamilyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var familyNameTextField: UITextField!
    @IBOutlet var aikotobaTextField: UITextField!

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundColor()
        familyNameTextField.delegate = self
        aikotobaTextField.delegate = self
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
    
    //MARK: signINFamily()
    @IBAction func signInFamily() {
        
        let familyQuery = NCMBQuery(className: "Family")
        familyQuery?.whereKey("familyName", equalTo: familyNameTextField.text)
        familyQuery?.whereKey("aikotoba", equalTo: aikotobaTextField.text)
        familyQuery?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("findError")
            }else{
                let familyLink: [NCMBObject]
                familyLink = result! as! [NCMBObject]
                if familyLink.isEmpty != true {
                    print("exist")
                    
                    //familyNameの登録
                    let user = NCMBUser.current()
                    user?.setObject(self.familyNameTextField.text, forKey: "familyName")
                    user?.saveInBackground({ (error) in
                        if error != nil {
                            print("registerError")
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    
                    // keep login
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLoginFamily")
                    ud.synchronize()
                    
                    //画面遷移
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    
                } else {
                    print("no match")
                    HUD.flash(.labeledError(title: "不一致", subtitle: "”家族の名前”または”合言葉”が違います"),delay: 1.5)
                }
            }
        })
        
        //フィールドの取り出し失敗
//        let classQuery = NCMBQuery(className: "Family")
//        classQuery?.whereKey("familyName", equalTo: familyNameTextField.text)
//        classQuery?.whereKey("aikotoba", equalTo: aikotobaTextField.text)
//        classQuery?.findObjectsInBackground({ (result, error) in
//            if error != nil {
//                print("error")
//            }else{
//                let family: [NCMBObject]
//                print(result)
//                family = result! as! [NCMBObject]
//                let name1: String? = result["familyName"]
//
//                print(family)
//                let name2: String = family["familyName"]
//            }
//        })
    }
    
    //MARK: forgetAikotoba()
    @IBAction func whatIsAikotoba() {
        let alertController = UIAlertController(title: "家族リンクとは？", message: "家族リンクとは，リンクすることで，リンクしたアカウントのデータが自動で反映されるようになります。ランキングの作成等で活用されます。\n\n\n家族リンクは再設定可能です。しかし，再設定前に入力したデータは反映されません。\n\n家族ID，合言葉は変更不可です。大切に保存してください。\n忘れた場合は，新たに家族リンクを設定してください。これまでのデータは反映されません。", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}
