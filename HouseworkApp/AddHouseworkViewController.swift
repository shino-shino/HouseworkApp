//
//  AddHouseworkViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/14.
//

import UIKit
import NCMB
import PKHUD

class AddHouseworkViewController: UIViewController {
    
    @IBOutlet var houseworkNameTextField: UITextField!
    @IBOutlet var houseworkPointTextField: UITextField!
    
    @IBOutlet var addButton: UIButton!
    
    var houseworks = [Housework]()
    var houseworkName = [String]()

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHousework()

        //数字入力のみに
        houseworkPointTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    //MARK: add()
    ///新たに家事を追加する
    @IBAction func add() {
        
        let newHouseworkName = houseworkNameTextField.text!
        let newHouseworkPoint = Int(houseworkPointTextField.text!)
        
        //未入力時
        //?? nil結合演算子〜nilならば代入，でなければそのまま,textfieldはもともと空文字ではあるが。。
        guard !(houseworkNameTextField.text ?? "").isEmpty && !(houseworkPointTextField.text ?? "").isEmpty else {
            HUD.flash(.labeledError(title: "エラー", subtitle: "未入力の項目があります"),delay: 1.5)
            return
        }
        
        //文字が半角英数字のみか判定
        let numberTestString = houseworkPointTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        guard (houseworkPointTextField.text == numberTestString) else {
            HUD.flash(.labeledError(title: "エラー", subtitle: "ポイントには整数を入力してください"),delay: 1.5)
            return
        }
        
        //家事名，重複時
        for i in 0...(self.houseworks.count - 1) {
            houseworkName.append(houseworks[i].houseworkName)
        }
        guard (houseworkName.firstIndex(of: houseworkNameTextField.text!) == nil) else {
            HUD.flash(.labeledError(title: "エラー", subtitle: "すでに存在している家事名です"),delay: 1.5)
            return
        }
        
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        
        //HouseWork classの登録
        let housework = NCMBObject(className: "Housework")
        housework?.setObject(familyName, forKey: "familyName")
        housework?.setObject(newHouseworkName, forKey: "houseworkName")
        housework?.setObject(newHouseworkPoint, forKey: "houseworkPoint")
        housework?.saveInBackground({ (error) in
            if error != nil {
                print("error")
            } else {
                self.navigationController?.popViewController(animated: true)
           }
        })
    }
    
    //MARK: getHousework()
    ///houseworkの情報を取得
    func getHousework() {
        //var houseworks = [Housework]()
        
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        
        let houseworkQuery = NCMBQuery(className: "Housework")
        houseworkQuery?.whereKey("familyName", equalTo: familyName)
        houseworkQuery?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("findError")
            } else {
                self.houseworks = []
                for houseworkObject in result as! [NCMBObject] {
                    
                    let housework = Housework.init(obj: houseworkObject)

                    self.houseworks.append(housework)
                }
            }
        })
    }
}
