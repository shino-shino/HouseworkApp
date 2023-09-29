//
//  EditAcountInfoViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/10/02.
//

import UIKit
import NCMB

class EditAcountInfoViewController: UIViewController {

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        presentAccountInfo()
    }
    
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var newNicknameTextField: UITextField!
    
    //MARK: presentAccountInfo()
    func presentAccountInfo() {
        let user = NCMBUser.current() as NCMBUser
        nicknameTextField.text = user.object(forKey: "nickname") as! String
        newNicknameTextField.text = ""
    }
    
    //MARK: saveNewNickname()
    @IBAction func saveNewNickname() {
        let user = NCMBUser.current()
        user?.setObject(newNicknameTextField.text, forKey: "nickname")
        user?.saveInBackground({ error in
            if error != nil {
                print("saveError")
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
