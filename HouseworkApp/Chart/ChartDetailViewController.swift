//
//  ChartDetailViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/10/10.
//

import UIKit
import NCMB
import Charts

class ChartDetailViewController: UIViewController {
    
    @IBOutlet var barChartView: BarChartView!
    
    var userArrayAll = [NCMBUser]()
    var pointArrayAll = [Int]()
    var userArrayMonth = [NCMBUser]()
    var pointArrayMonth = [Int]()
    var userArrayWeek = [NCMBUser]()
    var pointArrayWeek = [Int]()
    
    var correctUserArrayAll = [String]()
    var correctUserArrayMonth = [String]()
    var correctUserArrayWeek = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGraph(SegmentNum: 0)
    }
    

    func setupGraph(SegmentNum: Int) {
        var entries = [BarChartDataEntry]()
        
        switch SegmentNum {
        case 0:
            entries = []
            entries = pointArrayWeek.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element))}
            
        case 1:
            entries = []
            entries = pointArrayMonth.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element))}
            
            
        case 2:
            entries = []
            entries = pointArrayAll.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element))}
            
        default:
            print("chartError")
        }
        
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = true
        dataSet.colors = ChartColorTemplates.pastel()
        
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        // X軸のラベルの位置を下に設定
        barChartView.xAxis.labelPosition = .bottom
        // X軸のラベルの色を設定
        //barChartView.xAxis.labelTextColor = UIColor.systemBrown
        // X軸の線、グリッドを非表示にする
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        //ｘラベルの編集
        switch SegmentNum {
        case 0:
            correctUserArrayWeek = []
            for i in 0..<userArrayWeek.count {
                if userArrayWeek[i].object(forKey: "nickname") != nil {
                    correctUserArrayWeek.append(userArrayWeek[i].object(forKey: "nickname") as! String)
                } else {
                    correctUserArrayWeek.append("退会済みのユーザー")
                }
            }
            barChartView.xAxis.labelCount = correctUserArrayWeek.count
            barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: correctUserArrayWeek.map({$0}))
            
        case 1:
            correctUserArrayMonth = []
            for i in 0..<userArrayMonth.count {
                if userArrayMonth[i].object(forKey: "nickname") != nil {
                    correctUserArrayMonth.append(userArrayMonth[i].object(forKey: "nickname") as! String)
                } else {
                    correctUserArrayMonth.append("退会済みのユーザー")
                }
            }
            barChartView.xAxis.labelCount = correctUserArrayMonth.count
            barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: correctUserArrayMonth.map({$0}))
            
        case 2:
            correctUserArrayAll = []
            for i in 0..<userArrayAll.count {
                if userArrayAll[i].object(forKey: "nickname") != nil {
                    correctUserArrayAll.append(userArrayAll[i].object(forKey: "nickname") as! String)
                } else {
                    correctUserArrayAll.append("退会済みのユーザー")
                }
            }
            barChartView.xAxis.labelCount = correctUserArrayAll.count
            barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: correctUserArrayAll.map({$0}))
            
        default:
            print("chartTitleError")
        }
        
        //ｘ軸
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelFont = .systemFont(ofSize: 20)
        
        // 右側のY座標軸は非表示にする
        barChartView.rightAxis.enabled = false
        
        // Y座標の値が0始まりになるように設定
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.drawZeroLineEnabled = true
        barChartView.leftAxis.zeroLineColor = .systemGray
        barChartView.leftAxis.labelFont = .systemFont(ofSize: 15)
        // ラベルの数を設定
        barChartView.leftAxis.labelCount = 5
        // ラベルの色を設定
        barChartView.leftAxis.labelTextColor = .systemGray
        // グリッドの色を設定
        barChartView.leftAxis.gridColor = .systemGray
        // 軸線は非表示にする
        barChartView.leftAxis.drawAxisLineEnabled = false
        
        //フォントサイズ
        barChartView.barData?.setValueFont(.systemFont(ofSize: 20))
        
        // 凡例
        barChartView.legend.enabled = false
        
        //アニメーション
        barChartView.animate(yAxisDuration: 1)
        
        barChartView.highlightPerTapEnabled = false
        
        
        
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

}
