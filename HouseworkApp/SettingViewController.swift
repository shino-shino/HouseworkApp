//
//  SettingViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/10.
//

import UIKit
import NCMB

class SettingViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet var familyGoalTextView: UITextView!
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        presentFamilyGoal()
    }
    
    //MARK: layout()
    func layout() {
        // 枠のカラー
        familyGoalTextView.layer.borderColor = UIColor.systemBrown.cgColor
        // 枠の幅
        familyGoalTextView.layer.borderWidth = 2.0
        // 枠を角丸にする
        familyGoalTextView.layer.cornerRadius = 20.0
        familyGoalTextView.layer.masksToBounds = true
    }

    //MARK: presentFamilyGoal()
    ///家族の目標を表示する
    func presentFamilyGoal() {
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        //familyClassの情報を取得
        let familyQuery = NCMBQuery(className: "Family")
        familyQuery?.whereKey("familyName", equalTo: familyName)
        familyQuery?.findObjectsInBackground{ (result, error) in
            if error != nil {
                print("findError")
            }else {
                let family: NCMBObject
                family = result![0] as! NCMBObject
                self.familyGoalTextView.text = family.object(forKey: "familyGoal") as? String
            }
        }
        familyGoalTextView.becomeFirstResponder()
    }
    
    //MARK: update()
    @IBAction func update() {
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        //familyClassの情報を取得
        let familyQuery = NCMBQuery(className: "Family")
        familyQuery?.whereKey("familyName", equalTo: familyName)
        familyQuery?.findObjectsInBackground{ (result, error) in
            if error != nil {
                print("findError")
            }else {
                let family: NCMBObject
                family = result![0] as! NCMBObject
                //家族の目標を設定
                family.setObject(self.familyGoalTextView.text, forKey: "familyGoal")
                family.saveInBackground { (error) in
                    if error != nil {
                        print("saveError")
                    } else {
                        let alertController = UIAlertController(title: "保存完了", message: "保存が完了しました。ホームに戻ります。", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
