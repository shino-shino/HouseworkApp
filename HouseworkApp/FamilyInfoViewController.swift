//
//  FamilyInfoViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/26.
//

import UIKit
import NCMB
import PKHUD
class FamilyInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //作りかけ，ユーザーのaclをどうするか
//    @IBOutlet var familyMemberTableView: UITableView!
//
    var houseworks = [Housework]()
//
//    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//
//    //MARK: viewWillAppear()
//    override func viewWillAppear(_ animated: Bool) {
//        getFamilyMember()
//        HUD.show(.progress)
//        presentTableView()
//    }
//
//
//
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
//
//    //MARK: getFamilyMember()
//    ///houseworkの情報を取得
//    func getFamilyMember() {
//        //userの取得
//        let user = NCMBUser.current() as NCMBUser
//        let familyName = user.object(forKey: "familyName") as! String
//
//        let houseworkQuery = NCMBQuery(className: "Housework")
//        houseworkQuery?.whereKey("familyName", equalTo: familyName)
//        houseworkQuery?.findObjectsInBackground({ (result, error) in
//            if error != nil {
//                print("findError")
//            } else {
//                self.houseworks = []
//                for houseworkObject in result as! [NCMBObject] {
//
//                    let housework = Housework.init(obj: houseworkObject)
//
//                    self.houseworks.append(housework)
//                }
//                self.familyMemberTableView.reloadData()
//                HUD.hide()
//            }
//        })
//    }
//
//    //MARK: presentTableView()
//    ///TableViewを表示
//    func presentTableView() {
//        //tableViewの設定
//        familyMemberTableView.delegate = self
//        familyMemberTableView.dataSource = self
//
//        let nib = UINib(nibName: "FamilyTableViewCell", bundle: Bundle.main)
//        familyMemberTableView.register(nib, forCellReuseIdentifier: "Cell")
//        familyMemberTableView.tableFooterView = UIView()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "toHouseworkDetail", sender: true)
//        familyMemberTableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toHouseworkDetail"{
//            let houseworkDetailViewController = segue.destination as! HouseworkDetailViewController
//
//            let selectedIndex = familyMemberTableView.indexPathForSelectedRow
//
//            houseworkDetailViewController.selectedHousework = houseworks[selectedIndex!.row]
//            //houseworkDetailViewController.houseworks = houseworks
//            //houseworkDetailViewController.selectedIndexRow = selectedIndex!.row
//        }
//
//    }
}
