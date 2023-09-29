//
//  HouseworkInfoViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/11.
//

import UIKit
import NCMB
import PKHUD

class HouseworkInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var houseworkTableView: UITableView!
    
    var houseworks = [Housework]()
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
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
                print(result?.count)
                for houseworkObject in result as! [NCMBObject] {
                    
                    let housework = Housework.init(obj: houseworkObject)

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
    
    //MARK: didSelectRow()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toHouseworkDetail", sender: true)
        houseworkTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: prepareForSegue()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHouseworkDetail"{
            let houseworkDetailViewController = segue.destination as! HouseworkDetailViewController

            let selectedIndex = houseworkTableView.indexPathForSelectedRow

            houseworkDetailViewController.selectedHousework = houseworks[selectedIndex!.row]
            //houseworkDetailViewController.houseworks = houseworks
            //houseworkDetailViewController.selectedIndexRow = selectedIndex!.row
        }
    }
}
