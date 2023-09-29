//
//  ChartViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/10/06.
//

import UIKit
import NCMB
import PKHUD
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet var chartView: PieChartView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var houseworks = [Housework]()
    
    var userArrayAll = [NCMBUser]()
    var pointArrayAll = [Int]()
    var userArrayMonth = [NCMBUser]()
    var pointArrayMonth = [Int]()
    var userArrayWeek = [NCMBUser]()
    var pointArrayWeek = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl.selectedSegmentIndex = 0
        HUD.show(.progress)
        getHouseworkList()
    }
    

    //MARK: setupGraph()
    func setupGraph(SegmentNum: Int) {
        var entries = [PieChartDataEntry]()
        chartView.usePercentValuesEnabled = true
        
        switch SegmentNum {
        case 0:
            entries = []
            for i in 0..<pointArrayWeek.count {
                if userArrayWeek[i].object(forKey: "nickname") != nil {
                    entries.append(PieChartDataEntry(value: Double(pointArrayWeek[i]), label: userArrayWeek[i].object(forKey: "nickname") as? String))
                } else {
                    entries.append(PieChartDataEntry(value: Double(pointArrayWeek[i]), label: "退会済みのユーザー"))
                }
            }
            
        case 1:
            entries = []
            for i in 0..<pointArrayMonth.count {
                if userArrayMonth[i].object(forKey: "nickname") != nil {
                    entries.append(PieChartDataEntry(value: Double(pointArrayMonth[i]), label: userArrayMonth[i].object(forKey: "nickname") as? String))
                } else {
                    entries.append(PieChartDataEntry(value: Double(pointArrayMonth[i]), label: "退会済みのユーザー"))
                }
            }
            
        case 2:
            entries = []
            for i in 0..<pointArrayAll.count {
                if userArrayAll[i].object(forKey: "nickname") != nil {
                    entries.append(PieChartDataEntry(value: Double(pointArrayAll[i]), label: userArrayAll[i].object(forKey: "nickname") as? String))
                } else {
                    entries.append(PieChartDataEntry(value: Double(pointArrayAll[i]), label: "退会済みのユーザー"))
                }
            }
            
        default:
            print("chartError")
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        // グラフの色
        dataSet.colors = ChartColorTemplates.pastel()
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        //ポジション
        dataSet.yValuePosition = .outsideSlice
        
        
        let chartData = PieChartData(dataSet: dataSet)
        chartView.data = chartData
        
        // 円グラフの中心に表示するタイトル
//        let myAttrString = NSAttributedString(string: "My String", attributes: nil)
//        chartView.centerAttributedText = myAttrString
        switch SegmentNum {
            
        case 0:
            chartView.centerText = "過去7日間"
            
        case 1:
            chartView.centerText = "過去30日間"
            
        case 2:
            chartView.centerText = "累計"
            
        default:
            print("chartTitleError")
        }

        //中まで描写するか
        chartView.drawHoleEnabled = true
        //タッチの拡大禁止
        chartView.highlightPerTapEnabled = false
        //穴のサイズを調整:0.5がデフォルト
        chartView.holeRadiusPercent = 0.4
        //名前の表示
        chartView.drawEntryLabelsEnabled = false
        
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        //小数点以下
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chartView.usePercentValuesEnabled = true
        
        //アニメーション
        chartView.animate(yAxisDuration: 1.0)
        //はみ出防止
        chartView.extraRightOffset = 20
        chartView.extraLeftOffset = 20
        //凡例
        chartView.legend.font = UIFont.systemFont(ofSize: 20.0)
        chartView.legend.formSize = 15
        
        view.addSubview(chartView)
    }
    
    
    //MARK: getWeekData()
    func getWeekData() {
        
        var postDatas = [PostData]()
        userArrayWeek = []
        pointArrayWeek = []
        
        //日付の絞り込み
        let calendar = Calendar(identifier: .gregorian)
        var date = Date()
        var now = Date()
        //0時00分取得，UTC+0
        let today = Calendar.current.startOfDay(for: date)
    
        //日付変更線の設定
        var dateLine = calendar.date(byAdding: .hour, value: 2, to: today)!
        if now < dateLine {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            date = calendar.date(byAdding: .hour, value: 2, to: yesterday)!
        } else {
            date = calendar.date(byAdding: .hour, value: 2, to: today)!
        }
        //期間を指定
        date = calendar.date(byAdding: .day, value: -6, to: date)!

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

                    postDatas.append(postdata)
                }
                //データがないとき
                guard postDatas.count != 0 else {
                    HUD.hide()
                    return
                }
                //それぞれのオブジェクトの内容ごとで処理
                for i in 0...(postDatas.count - 1) {
                    let data = postDatas[i] as! PostData
                    //家事のポイントを取得
                    let point = getHouseworkPoint(houseworkName: data.houseworkName)
                    //初回
                    if i == 0 {
                        userArrayWeek.append(data.user)
                        pointArrayWeek.append(point)
                    } else {
                        //ユーザーIDごとに和を計算
                        for j in 0..<userArrayWeek.count {
                            if userArrayWeek[j].objectId == data.user.objectId {
                                pointArrayWeek[j] = pointArrayWeek[j] + point
                                break
                            } else if j ==  userArrayWeek.count - 1 {
                                userArrayWeek.append(data.user)
                                pointArrayWeek.append(point)
                            }
                        }
                    }
                }
                //降順に並び替え
                let index = pointArrayWeek.indices.sorted{pointArrayWeek[$0] > pointArrayWeek[$1]}
                pointArrayWeek = index.map{pointArrayWeek[$0]}
                userArrayWeek = index.map{userArrayWeek[$0]}
            }
            setupGraph(SegmentNum:0)
            HUD.hide()
        })
    }
    
    //MARK: getMonthData()
    func getMonthData() {
        
        var postDatas = [PostData]()
        userArrayMonth = []
        pointArrayMonth = []
        
        //日付の絞り込み
        let calendar = Calendar(identifier: .gregorian)
        var date = Date()
        var now = Date()
        //0時00分取得，UTC+0
        let today = Calendar.current.startOfDay(for: date)
    
        //日付変更線の設定
        var dateLine = calendar.date(byAdding: .hour, value: 2, to: today)!
        if now < dateLine {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            date = calendar.date(byAdding: .hour, value: 2, to: yesterday)!
        } else {
            date = calendar.date(byAdding: .hour, value: 2, to: today)!
        }
        //期間を指定
        date = calendar.date(byAdding: .day, value: -29, to: date)!

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

                    postDatas.append(postdata)
                }
                //データがないとき
                guard postDatas.count != 0 else {
                    HUD.hide()
                    return
                }
                //それぞれのオブジェクトの内容ごとで処理
                for i in 0...(postDatas.count - 1) {
                    let data = postDatas[i] as! PostData
                    //家事のポイントを取得
                    let point = getHouseworkPoint(houseworkName: data.houseworkName)
                    //初回
                    if i == 0 {
                        userArrayMonth.append(data.user)
                        pointArrayMonth.append(point)
                    } else {
                        //ユーザーIDごとに和を計算
                        for j in 0..<userArrayMonth.count {
                            if userArrayMonth[j].objectId == data.user.objectId {
                                pointArrayMonth[j] = pointArrayMonth[j] + point
                                break
                            } else if j ==  userArrayMonth.count - 1 {
                                userArrayMonth.append(data.user)
                                pointArrayMonth.append(point)
                            }
                        }
                    }
                }
                //降順に並び替え
                let index = pointArrayMonth.indices.sorted{pointArrayMonth[$0] > pointArrayMonth[$1]}
                pointArrayMonth = index.map{pointArrayMonth[$0]}
                userArrayMonth = index.map{userArrayMonth[$0]}
            }
        })
    }
    
    //MARK: getAllData()
    func getAllData() {
        
        var postDatas = [PostData]()
        userArrayAll = []
        pointArrayAll = []
        
        //userの取得
        let user = NCMBUser.current() as NCMBUser
        let familyName = user.object(forKey: "familyName") as! String
        
        let postDataQuery = NCMBQuery(className: "PostData")
        postDataQuery?.includeKey("user")
        postDataQuery?.whereKey("familyName", equalTo: familyName)
        postDataQuery?.findObjectsInBackground({ [self](result, error) in
            if error != nil {
                print("findError")
            } else {
                for postDataObject in result as! [NCMBObject] {
                    let postdata = PostData.init(obj: postDataObject)

                    postDatas.append(postdata)
                }
                //データがないとき
                guard postDatas.count != 0 else {
                    HUD.hide()
                    return
                }
                //それぞれのオブジェクトの内容ごとで処理
                for i in 0...(postDatas.count - 1) {
                    let data = postDatas[i] as! PostData
                    //家事のポイントを取得
                    let point = getHouseworkPoint(houseworkName: data.houseworkName)
                    //初回
                    if i == 0 {
                        userArrayAll.append(data.user)
                        pointArrayAll.append(point)
                    } else {
                        //ユーザーIDごとに和を計算
                        for j in 0..<userArrayAll.count {
                            if userArrayAll[j].objectId == data.user.objectId {
                                pointArrayAll[j] = pointArrayAll[j] + point
                                break
                            } else if j ==  userArrayAll.count - 1 {
                                userArrayAll.append(data.user)
                                pointArrayAll.append(point)
                            }
                        }
                    }
                }
                //降順に並び替え
                let index = pointArrayAll.indices.sorted{pointArrayAll[$0] > pointArrayAll[$1]}
                pointArrayAll = index.map{pointArrayAll[$0]}
                userArrayAll = index.map{userArrayAll[$0]}
            }
        })
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
        houseworkQuery?.findObjectsInBackground({(result, error) in
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
                self.getAllData()
                self.getMonthData()
                self.getWeekData()
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

    //MARK: switchButton()
    @IBAction func switchButton(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            setupGraph(SegmentNum: 0)
            
        case 1:
            setupGraph(SegmentNum: 1)
            
        case 2:
            setupGraph(SegmentNum: 2)
            
        default:
            print("segmentError")
        }
    }
    
    //MARK: prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChartDetail"{
            let chartDetailViewController = segue.destination as! ChartDetailViewController

            chartDetailViewController.pointArrayAll = pointArrayAll
            chartDetailViewController.userArrayAll = userArrayAll
            chartDetailViewController.pointArrayMonth = pointArrayMonth
            chartDetailViewController.userArrayMonth = userArrayMonth
            chartDetailViewController.pointArrayWeek = pointArrayWeek
            chartDetailViewController.userArrayWeek = userArrayWeek
        }
    }

}
