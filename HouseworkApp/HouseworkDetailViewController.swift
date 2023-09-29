//
//  HouseworkDetailViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/12.
//

import UIKit
import NCMB
import PKHUD

class HouseworkDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var houseworkNameLabel: UILabel!
    @IBOutlet var houseworkPointTextField: UITextField!
    @IBOutlet var updateButton: UIButton!
    
    var selectedHousework: Housework!

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //数字入力のみに
        houseworkPointTextField.keyboardType = UIKeyboardType.numberPad

        presentHousework()
    }
    
    //MARK: viewWillLoad()
    override func viewWillAppear(_ animated: Bool) {
        presentHousework()
    }
    
    //MARK: presentHousework()
    ///textFieldに表示する
    func presentHousework() {
        houseworkNameLabel.text = selectedHousework.houseworkName
        houseworkPointTextField.text = String(selectedHousework.houseworkPoint)
    }
    
    //MARK: update()
    ///内容を変更する
    @IBAction func update() {
        
        let newHouseworkName = houseworkNameLabel.text!
        let newouseworkPoint = Int(houseworkPointTextField.text!)
        
        //未入力時
        //?? nil結合演算子〜nilならば代入，でなければそのまま,textfieldはもともと空文字ではあるが。。
        guard !(houseworkNameLabel.text ?? "").isEmpty && !(houseworkPointTextField.text ?? "").isEmpty else {
            HUD.flash(.labeledError(title: "エラー", subtitle: "未入力の項目があります"),delay: 1.5)
            return
        }
        
        //文字が半角英数字のみか判定
        let numberTestString = houseworkPointTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        guard (houseworkPointTextField.text == numberTestString) else {
            HUD.flash(.labeledError(title: "エラー", subtitle: "ポイントには整数を入力してください"),delay: 1.5)
            return
        }
        
        
        let houseworkQuery = NCMBQuery(className: "Housework")
        houseworkQuery?.getObjectInBackground(withId: selectedHousework.objectId, block: { object, error in
            if error != nil {
                print("findError")
            } else {
                let houseworkObject: NCMBObject
                houseworkObject = object as! NCMBObject
                houseworkObject.setObject(newHouseworkName, forKey: "houseworkName")
                houseworkObject.setObject(newouseworkPoint, forKey: "houseworkPoint")
                houseworkObject.saveInBackground({ (error) in
                    if error != nil {
                        print("saveError")
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        })
    }
    
    //MARK: delete()
    ///内容を削除する
    @IBAction func delete() {
        
        let alertController = UIAlertController(title: "削除", message: "本当に削除しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let houseworkQuery = NCMBQuery(className: "Housework")
            houseworkQuery?.getObjectInBackground(withId: self.selectedHousework.objectId, block: { object, error in
                if error != nil {
                    print("findError")
                } else {
                    let houseworkObject: NCMBObject
                    houseworkObject = object as! NCMBObject
                    houseworkObject.deleteInBackground { error in
                        if error != nil {
                            print("deleteError")
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
