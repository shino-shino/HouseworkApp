//
//  SignUpFamilyViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/06.
//

import UIKit
import NCMB
import PKHUD

class SignUpFamilyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var familyNameTextField: UITextField!
    @IBOutlet var aikotobaTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()

        familyNameTextField.delegate = self
        aikotobaTextField.delegate = self
        confirmTextField.delegate = self
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
    
    //MARK: singUpFamily()
    @IBAction func signUpFammily() {
        
        if familyNameTextField.text!.count < 4 {
            print("文字数が足りません")
            HUD.flash(.labeledError(title: "文字数不足", subtitle: "家族の名前の文字数が不足しています"),delay: 1.5)
            return
        }
        
        if aikotobaTextField.text == confirmTextField.text {
            let familyQuery = NCMBQuery(className: "Family")
            familyQuery?.whereKey("familyName", equalTo: familyNameTextField.text)
            familyQuery?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print("findError")
                }else{
                    let familyLink: [NCMBObject]
                    familyLink = result! as! [NCMBObject]
                    
                    if !familyLink.isEmpty {
                        print("alreadyExist")
                        HUD.flash(.labeledError(title: "重複", subtitle: "すでに使用されている家族の名前です"),delay: 1.5)
                        
                    } else {
                        print("no match")
                        
                        //User classの登録
                        let user = NCMBUser.current()
                        user?.setObject(self.familyNameTextField.text, forKey: "familyName")
                        user?.saveInBackground({ (error) in
                            if error != nil {
                                print("error")
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                        
                        //Family classの登録
                        let family = NCMBObject(className: "Family")
                        family?.setObject(self.familyNameTextField.text, forKey: "familyName")
                        family?.setObject(self.aikotobaTextField.text, forKey: "aikotoba")
                        family?.setObject("設定画面から家族の目標を設定しよう。\n例)\n①Aさんの占める割合を50%にする\n②○ポイント貯まったら，お小遣い○円", forKey: "familyGoal")
                        family?.saveInBackground({ (error) in
                            if error != nil {
                                print("error")
                            } else {
                                self.dismiss(animated: true, completion: nil)
                           }
                        })
                        
                        //HouseWork classの登録
                        let housework = NCMBObject(className: "Housework")
                        let houseworkSampleName = ["洗濯", "掃除", "料理", "ゴミ捨て", "風呂洗い", "買い物"]
                        let houseworkSamplePoint = [500, 800, 1200, 350, 300, 700]
                        
                        for i in 0...(houseworkSampleName.count - 1) {
                            housework?.setObject(self.familyNameTextField.text, forKey: "familyName")
                            housework?.setObject(houseworkSampleName[i], forKey: "houseworkName")
                            housework?.setObject(houseworkSamplePoint[i], forKey: "houseworkPoint")
                            housework?.saveInBackground({ (error) in
                                if error != nil {
                                    print("error")
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                               }
                            })
                        }
                        
                        // keep login
                        let ud = UserDefaults.standard
                        ud.set(true, forKey: "isLoginFamily")
                        ud.synchronize()
                    
                        //画面遷移
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    }
                }
            })
        } else {
            HUD.flash(.labeledError(title: "不一致", subtitle: "パスワードが一致していません"),delay: 1.5)
            print("パスワードの不一致")
        }
    }
}
