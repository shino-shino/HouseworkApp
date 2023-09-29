//
//  PostDataDetailViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/28.
//

import UIKit
import NCMB
import PKHUD

class PostDataDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedUser: NCMBUser!
    var postDatas = [PostData]()
    var houseworks = [Housework]()
    var userPostData = [PostData]()

    @IBOutlet var userPostDataTableView: UITableView!
    @IBOutlet var userNameLabel: UILabel!

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // trueで複数選択、falseで単一選択
        userPostDataTableView.allowsMultipleSelection = true
        
        if selectedUser.object(forKey: "nickname") != nil {
            userNameLabel.text = selectedUser.object(forKey: "nickname") as! String
        } else {
            userNameLabel.text = "退会済のユーザー"
        }
    }
    
    //MARK: viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        getUserPostData()
    }
    
    
    //MARK: numberOfRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostData.count
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PostDataDetailTableViewCell

        cell.houseworkNameLabel.text = userPostData[indexPath.row].houseworkName
        
        var houseworkPoint = getHouseworkPoint(houseworkName: userPostData[indexPath.row].houseworkName)
        cell.houseworkPointLabel.text = String(houseworkPoint)
        return cell
    }
    
    //MARK: presentTableView()
    ///TableViewを表示
    func presentTableView() {
        //tableViewの設定
        userPostDataTableView.delegate = self
        userPostDataTableView.dataSource = self
        
        let nib = UINib(nibName: "PostDataDetailTableViewCell", bundle: Bundle.main)
        userPostDataTableView.register(nib, forCellReuseIdentifier: "Cell")
        userPostDataTableView.tableFooterView = UIView()
    }
    
    func getUserPostData() {
        userPostData = []
        for i in 0...(self.postDatas.count - 1) {
            let data = self.postDatas[i] as! PostData

            if data.user.objectId == selectedUser.objectId {
                userPostData.append(data)
            }
        }
        presentTableView()
        userPostDataTableView.reloadData()
    }
    
    //MARK: getHouseworkPoint()
    ///家事名でポイントを取得する関数
    func getHouseworkPoint(houseworkName: String) -> Int {
        var point = 0
        for i in 0...(houseworks.count - 1){
            if houseworks[i].houseworkName == houseworkName {
                point = houseworks[i].houseworkPoint as! Int
            }
        }
        return point
    }
    
    var selectedIndexArray = [Int]()
    
    //MARK: didSelectRow()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "toHouseworkDetail", sender: true)
//        houseworkTableView.deselectRow(at: indexPath, animated: true)
        
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
    
    //MARK: delete()
    @IBAction func delete() {

        //配列をソートする
        let sortSelectedIndexArray = selectedIndexArray.sorted()
        print(sortSelectedIndexArray)
        
        //選択されていないとき
        guard !sortSelectedIndexArray.isEmpty else {
            HUD.flash(.labeledError(title: "エラー", subtitle: "選択されていません"),delay: 1.5)
            return
        }
        
        var deleteObjectIdArray = [String]()
        for i in 0...(sortSelectedIndexArray.count - 1) {
            var number = sortSelectedIndexArray[i]
            deleteObjectIdArray.append(userPostData[number].objectId)
        }

        let alertController = UIAlertController(title: "削除", message: "本当に削除しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
            for i in 0...(deleteObjectIdArray.count - 1) {
                let deleteDataQuery = NCMBQuery(className: "PostData")
                deleteDataQuery?.getObjectInBackground(withId: deleteObjectIdArray[i], block: { object, error in
                    if error != nil {
                        print("findError")
                    } else {
                        var deleteObject = object!
                        deleteObject.deleteInBackground { error in
                            if error != nil {
                                print("deleteError")
                            } else {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
