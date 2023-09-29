//
//  RegisterHouseworkViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/15.
//

import UIKit
import NCMB
import PKHUD

class RegisterHouseworkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var houseworkTableView: UITableView!
    
    var houseworks = [Housework]()
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // trueで複数選択、falseで単一選択
        houseworkTableView.allowsMultipleSelection = true
    }
    
    //MARK: viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        presentTableView()
        HUD.show(.progress)
        getHousework()
    }

    //MARK: numberOfRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseworks.count
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HouseworkTableViewCell

        cell.houseworkNameLabel.text = houseworks[indexPath.row].houseworkName
        cell.houseworkPointLabel.text = String(houseworks[indexPath.row].houseworkPoint)
        return cell
    }
    
    //MARK: getHousework()
    ///houseworkの情報を取得
    func getHousework() {
        var houseworks = [Housework]()
        
        guard NCMBUser.current() != nil else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController

            // keep login
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.set(false, forKey: "isLoginFamily")
            ud.synchronize()
            
            HUD.hide()
            
            return
        }
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        
        let houseworkQuery = NCMBQuery(className: "Housework")
        houseworkQuery?.whereKey("familyName", equalTo: familyName)
        houseworkQuery?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("findError")
                HUD.hide()
                return
            } else {
                self.houseworks = []
                for houseworkObject in result as! [NCMBObject] {
                    
                    let housework = Housework.init(obj: houseworkObject)
                    
                    housework.objectId = houseworkObject.objectId
                    housework.familyName = houseworkObject.object(forKey: "familyName") as! String
                    housework.houseworkName = houseworkObject.object(forKey: "houseworkName") as! String
                    housework.houseworkPoint = houseworkObject.object(forKey: "houseworkPoint") as! Int

                    self.houseworks.append(housework)
                }
                self.houseworkTableView.reloadData()
                HUD.hide()
            }
        })
    }
    
    //MARK: presentTableView()
    ///TableViewを表示
    func presentTableView() {
        //tableViewの設定
        houseworkTableView.delegate = self
        houseworkTableView.dataSource = self
        
        let nib = UINib(nibName: "HouseworkTableViewCell", bundle: Bundle.main)
        houseworkTableView.register(nib, forCellReuseIdentifier: "Cell")
        houseworkTableView.tableFooterView = UIView()
    }
    
    var selectedIndexArray = [Int]()
    
    //MARK: didSelectRow()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択されたセル番号を追加
        selectedIndexArray.append(indexPath.row)
        
        //チェックマークをつける
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    //MARK: didDeselectRow()
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        //選択されたセル番号を削除
        let index = selectedIndexArray.firstIndex(of: indexPath.row)
        selectedIndexArray.remove(at: index!)
        
        // チェックマークを外す
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
    
    //MARK: save()
    @IBAction func save() {
        //配列をソートする
        let sortSelectedIndexArray = selectedIndexArray.sorted()
        print(sortSelectedIndexArray)
        
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        
        
        //選択されていないとき
        guard !sortSelectedIndexArray.isEmpty else {
            HUD.flash(.labeledError(title: "エラー", subtitle: "選択されていません"),delay: 1.5)
            return
        }
        //NCMBに登録
        for i in 0...(sortSelectedIndexArray.count - 1) {
            var number = sortSelectedIndexArray[i]
            let postData = NCMBObject(className: "PostData")
            postData?.setObject(familyName, forKey: "familyName")
            postData?.setObject(houseworks[number].houseworkName, forKey: "houseworkName")
            postData?.setObject(user, forKey: "user")
            //postData?.setObject(user.objectId, forKey: "userId")
            postData?.saveInBackground({ (error) in
                if error != nil {
                    print("error")
                } else {
                    self.navigationController?.popViewController(animated: true)
               }
            })
        }
    }
}
