//
//  StatisticsVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/7/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Charts

class StatisticsVC: UIViewController {
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenceLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var eraceBtn: CustomButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tempStatistics = statistics.sorted(by: {$0.month.monthToDate > $1.month.monthToDate})

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalChange(notification:)), name: .didUpdateStatistics, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appFlags[AppFlags.statistics.rawValue]! {
//            showStatistics()
//            showGraph()
        } else {
            print("Error when loading statistics!")
//            eraceBtn.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tempStatistics = statistics.sorted(by: {$0.month.monthToDate > $1.month.monthToDate})
        showGraph()
        tableView.reloadData()
    }
    
    @IBAction func eraceStatisticsTapped(sender: UIButton) {
        // Consider for future addition of the feature, temporary disabled
//        StorageManager.shared.deleteObject(location: FDChild.statistics.rawValue, id: currentMonth.0!.id)
//        statistics.remove(at: currentMonth.1!)
//        currentMonth.0 = nil
    }
    
    func showGraph(){
        var lineChartEntry  = [ChartDataEntry]()
        
        for (key, value) in statistics.sorted(by: {$0.month.monthToDate > $1.month.monthToDate}).reversed().enumerated() {
            let item = ChartDataEntry(x: Double(key), y: value.balance)
            lineChartEntry.append(item)
        }

        let line = LineChartDataSet(entries: lineChartEntry, label: "Balance")
        line.colors = [UIColor.appPurple]
        line.circleRadius = 4.0
        line.circleHoleRadius = 0
        line.lineWidth = 3.0
        line.circleColors = [UIColor.appPurple]
        line.mode = .cubicBezier
        
        let gradientColors = [UIColor.white.cgColor,
                              UIColor.appPurple.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        line.fillAlpha = 1
        line.fill = Fill(linearGradient: gradient, angle: 90)
        line.drawFilledEnabled = true

        let data = LineChartData()
        data.addDataSet(line)
        

        chartView.data = data
        chartView.animate(yAxisDuration: 2)
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.legend.enabled = false
    }
    
    @objc func handleLocalChange(notification: Notification) {
        print("Statistics changed!")
    }
    
    func showStatistics() {
        idLbl.text = currentMonth.0?.id
        incomeLbl.text = currentMonth.0?.incomes.currencyFormat
        expenceLbl.text = currentMonth.0?.expenses.currencyFormat
        balanceLbl.text = currentMonth.0?.balance.currencyFormat
    }

}

extension StatisticsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempStatistics.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsCell", for: indexPath) as? StatisticsCell {
            
            let month = tempStatistics[indexPath.row]
            cell.configureCell(month: month)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
