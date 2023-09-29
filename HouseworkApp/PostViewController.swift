//
//  PostViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/10.
//

import UIKit
import NCMB
import PKHUD

class PostViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var familyGoalTextView: UITextView!
    @IBOutlet var postDataTableView: UITableView!
    @IBOutlet var nothingLabel: UILabel!
    var logoImageView: UIImageView!
    
    var postDatas = [PostData]()
    var houseworks = [Housework]()
    
    var userArray = [NCMBUser]()
    var pointArray = [Int]()

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        //tabbarの色を変更
        UITabBar.appearance().tintColor = UIColor.red
        //UITabBar.barTintColor = UIColor.white

        //tabbar背景の透過
        //UITabBar.appearance().backgroundImage = UIIma
        
    }
    
    //MARK: viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        HUD.show(.progress)
        presentFamilyGoal()
        getHouseworkList()
        presentTableView()
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
    
    //MARK: numberOfRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PostDataTableViewCell

        cell.rankLabel.text = String(indexPath.row + 1)
        if userArray[indexPath.row].object(forKey: "nickname") != nil {
            cell.userNameLabel.text = userArray[indexPath.row].object(forKey: "nickname") as! String
        } else {
            cell.userNameLabel.text = "退会済のユーザー"
        }
        cell.PointLabel.text = String(pointArray[indexPath.row])
        return cell
    }
    
//    //MARK: willDisplayCell
//    // セルのアニメーション
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//
//        let slideInTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 15, 0)
//
//        cell.layer.transform = slideInTransform
//
//        UIView.animate(withDuration: 0.3) { () -> Void in
//        cell.layer.transform = CATransform3DIdentity
//
//        }
//    }
    
    
    //MARK: presentTableView()
    ///TableViewを表示
    func presentTableView() {
        //tableViewの設定
        postDataTableView.delegate = self
        postDataTableView.dataSource = self
        
        let nib = UINib(nibName: "PostDataTableViewCell", bundle: Bundle.main)
        postDataTableView.register(nib, forCellReuseIdentifier: "Cell")
        postDataTableView.tableFooterView = UIView()
    }
    
    
    //MARK: presentFamilyGoal()
    func presentFamilyGoal() {
        //userの取得
        guard NCMBUser.current() != nil else{
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
        let user = NCMBUser.current() as NCMBUser
        guard (user.object(forKey: "familyName") != nil) else{
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
        let familyName = user.object(forKey: "familyName") as! String
        //familyClassの情報を取得
        let familyQuery = NCMBQuery(className: "Family")
        familyQuery?.whereKey("familyName", equalTo: familyName)
        familyQuery?.findObjectsInBackground{ (result, error) in
            if error != nil {
                print("findError")
                //ログイン画面へ(1回めはcurrentUserがnilじゃない？？
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
            }else {
                guard !result!.isEmpty else {
                    return
                }
                let family: NCMBObject
                family = result![0] as! NCMBObject
                self.familyGoalTextView.text = family.object(forKey: "familyGoal") as? String
            }
        }
    }
    
    //MARK: pointCaluculate()
    func pointCaluculate() {
        
        self.postDatas = []
        userArray = []
        pointArray = []
        
        //日付の絞り込み
        let calendar = Calendar(identifier: .gregorian)
        var date = Date()
        var now = Date()
        //0時00分取得，UTC+0
        let today = Calendar.current.startOfDay(for: date)
        //期間を指定
        date = calendar.date(byAdding: .day, value: 0, to: today)!
        
        //日付変更線の設定
        var dateLine = calendar.date(byAdding: .hour, value: 2, to: today)!
        print(dateLine)
        print(now)
        if now < dateLine {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            date = calendar.date(byAdding: .hour, value: 2, to: yesterday)!
        } else {
            date = calendar.date(byAdding: .hour, value: 2, to: today)!
        }
        print(date)
        
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        
        let postDataQuery = NCMBQuery(className: "PostData")
        postDataQuery?.includeKey("user")
        postDataQuery?.whereKey("familyName", equalTo: familyName)
        if date != nil {
            postDataQuery?.whereKey("createDate", greaterThan: date)
            }
        postDataQuery?.findObjectsInBackground({ [self](result, error) in
            if error != nil {
                print("findError")
            } else {
                for postDataObject in result as! [NCMBObject] {
                    let postdata = PostData.init(obj: postDataObject)

                    self.postDatas.append(postdata)
                }
                //データがないとき
                guard postDatas.count != 0 else {
                    postDataTableView.reloadData()
                    whenNothing()
                    HUD.hide()
                    return
                }
                //それぞれのオブジェクトの内容ごとで処理
                for i in 0...(self.postDatas.count - 1) {
                    let data = self.postDatas[i] as! PostData
                    //家事のポイントを取得
                    let point = getHouseworkPoint(houseworkName: data.houseworkName)
                    print(postDatas[i].user)
                    //初回
                    if i == 0 {
                        userArray.append(data.user)
                        pointArray.append(point)
                    } else {
                        //ユーザーIDごとに和を計算
                        for j in 0..<userArray.count {
                            if userArray[j].objectId == data.user.objectId {
                                pointArray[j] = pointArray[j] + point
                                break
                            } else if j ==  userArray.count - 1 {
                                userArray.append(data.user)
                                pointArray.append(point)
                            }
                        }
                    }
                }
                //降順に並び替え
                let index = pointArray.indices.sorted{pointArray[$0] > pointArray[$1]}
                pointArray = index.map{pointArray[$0]}
                userArray = index.map{userArray[$0]}
            }
            postDataTableView.reloadData()
            whenNothing()
        })
    }
    
    //MARK: whenNothing()
    ///tableViewがないときのラベル
    func whenNothing() {
        if userArray.count == 0 {
            nothingLabel.isHidden = false
        } else {
            nothingLabel.isHidden = true
        }
        HUD.hide()
    }
    
    //MARK: getHouseworkList()
    ///houseworkのデータをすべて取得
    func getHouseworkList() {
        houseworks = []
        //userの取得
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
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        let houseworkQuery = NCMBQuery(className: "Housework")
        houseworkQuery?.whereKey("familyName", equalTo: familyName)
        houseworkQuery?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("findError")
                //ログイン画面へ
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
                self.pointCaluculate()
            }
        })
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
    
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //データがないとき
        guard postDatas.count != 0 else {
            postDataTableView.reloadData()
            return
        }
        self.performSegue(withIdentifier: "toPostDataDetail", sender: true)
        postDataTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDataDetail"{
            let postDataDetailViewController = segue.destination as! PostDataDetailViewController

            let selectedIndex = postDataTableView.indexPathForSelectedRow

            postDataDetailViewController.selectedUser = userArray[selectedIndex!.row]
            postDataDetailViewController.postDatas = postDatas
            postDataDetailViewController.houseworks = houseworks
        }
    }
}
