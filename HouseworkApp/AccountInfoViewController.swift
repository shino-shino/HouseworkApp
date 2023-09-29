//
//  AccountInfoViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/10.
//

import UIKit
import NCMB

class AccountInfoViewController: UIViewController {

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        presentAccountInfo()
    }
    
    @IBOutlet var mailAddressTextField: UITextField!
    @IBOutlet var familyNameTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!

    //MARK: presentAccountInfo()
    /// アカウント情報を表示する
    func presentAccountInfo() {
        guard NCMBUser.current() != nil else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController

            // keep login
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.set(false, forKey: "isLoginFamily")
            ud.synchronize()
            
            return
        }
        let user = NCMBUser.current() as NCMBUser
        mailAddressTextField.text = user.mailAddress
        nicknameTextField.text = user.object(forKey: "nickname") as! String
        familyNameTextField.text = user.object(forKey: "familyName") as? String
    }

    //MARK: signOut()
    //仮のログアウト
    @IBAction func signOut() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    print("error")
                } else {
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController

                    // keep login
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.set(false, forKey: "isLoginFamily")
                    ud.synchronize()
                }
            }
        }

        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print("error")
                } else {
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController

                    // keep login
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.set(false, forKey: "isLoginFamily")
                    ud.synchronize()
                }
            })
        }

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        // iPadでは必須！
        alertController.popoverPresentationController?.sourceView = self.view
        let screenSize = UIScreen.main.bounds
        // ここで表示位置を調整
        // xは画面中央、yは画面下部になる様に指定
        alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)

        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: signOutFamily()
    @IBAction func signOutFamily() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "家族リンクの解除", style: .default) { (action) in
            let storyboard = UIStoryboard(name: "SignInFamily", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootFamilyNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController

            // keep login
            let ud = UserDefaults.standard
            //ud.set(true, forKey: "isLogin")
            ud.set(false, forKey: "isLoginFamily")
            ud.synchronize()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        
        // iPadでは必須！
        alertController.popoverPresentationController?.sourceView = self.view
        let screenSize = UIScreen.main.bounds
        // ここで表示位置を調整
        // xは画面中央、yは画面下部になる様に指定
        alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)

        self.present(alertController, animated: true, completion: nil)
    }

}
