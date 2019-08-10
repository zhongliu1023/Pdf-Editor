//
//  WBManager.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/2/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit


public enum WBCellType: Int {
    case position = 0
    case qty = 1
    case weight = 2
    case arm = 3
    case moment = 4
}

public enum OxygenQty: Double {
    case psi1800 = 6.4
    case psi1600 = 5.7
    case psi1200 = 4.3
    case psi800 = 2.8
    case psi400 = 1.4
    case psi0 = 0
    
    var value: Double {
        switch self {
            case .psi1800: return 6
            case .psi1600: return 6
            case .psi1200: return 4
            case .psi800: return 3
            case .psi400: return 1
            case .psi0: return 0
        }
    }
    
    var name: String{
        switch self {
            case .psi1800: return "1800 psi"
            case .psi1600: return "1600 psi"
            case .psi1200: return "1200 psi"
            case .psi800: return "800 psi"
            case .psi400: return "400 psi"
            case .psi0: return "0 psi"
        }
    }
}

class WBChartData {
    var envelopes: [CGPoint]!
    var limits: [CGPoint]!
    var envelopTitle: String! = "Envelope"
    var limitTitle: String!
    
    init(envelopTitle: String?, limitTitle: String?, envelops: [CGPoint]?, limits: [CGPoint]?) {
        if let value = envelopTitle {
            self.envelopTitle = value
        }
        
        if let value = limitTitle {
            self.limitTitle = value
        }
        
        if let value = envelops {
            self.envelopes = value
        }
        
        if let value = limits {
            self.limits = value
        }
    }
    
    func range() -> (CGPoint, CGPoint, CGPoint) {
        var min: CGPoint = CGPoint(x: 1000000.0, y: 10000000.0)
        var max: CGPoint = CGPoint(x: 0, y: 0)
        for pos in self.envelopes {
            if min.x > pos.x {
                min.x = pos.x
            }
            if min.y > pos.y {
                min.y = pos.y
            }
            if max.x < pos.x {
                max.x = pos.x
            }
            if max.y < pos.y {
                max.y = pos.y
            }
        }
        
        min.x = min.x - CGFloat(Int(min.x)%100)
        min.y = CGFloat(Int(min.y-2))
        max.x = (max.x+100) - CGFloat(Int(max.x)%100)
        max.y = CGFloat(Int(max.y+2))
        return (min, max, CGPoint(x: Int((max.x-min.x)/100+1), y: Int((max.y-min.y)/2+1)))
    }
}

class WBRow {
    var title: String!
    var qty: Any! = Double(1)
    var weight: Double!
    var arm: Double!
    var moment: Double!
    var qtyEditable: Bool = false
    var weightEditable: Bool = false
    var momentEditable: Bool = false
    
    weak var wbItem: WBItem!
    
    func dictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["title"] = self.title
        if self.qty is OxygenQty {
            dict["qty"] = "oxygen: \((self.qty as! OxygenQty).rawValue)"
        }
        else {
            dict["qty"] = "\(self.qty!)"
        }
        
        dict["weight"] = "\(self.weight!)"
        dict["arm"] = "\(self.arm!)"
        dict["moment"] = "\(self.moment!)"
        dict["qtyEditable"] = "\(self.qtyEditable)"
        dict["weightEditable"] = "\(self.weightEditable)"
        dict["momentEditable"] = "\(self.momentEditable)"
        return dict
    }
    
    class func row(from dict: [String: Any]) -> WBRow {
        let row = WBRow()
        row.title = dict["title"] as! String!
        row.qty = 1
        if let qtyValue = dict["qty"] as? String{
            if qtyValue.contains("oxygen:") {
                let val = qtyValue.replacingOccurrences(of: "oxygen: ", with: "")
                row.qty = OxygenQty(rawValue: Double(val)!)
            }
            else {
                row.qty = Double(qtyValue)
            }
        }
        
        row.weight = Double(dict["weight"] as! String)
        row.moment = Double(dict["moment"] as! String)
        row.arm = Double(dict["arm"] as! String)
        row.qtyEditable = Bool(dict["qtyEditable"] as! String)!
        row.weightEditable = Bool(dict["weightEditable"] as! String)!
        row.momentEditable = Bool(dict["momentEditable"] as! String)!
        return row
    }
   
    init () {
       self.title = ""
        self.qty = 0
        self.weight = 0
        self.arm = 0
        self.moment = 0
        self.qtyEditable = false
        self.weightEditable = false
        self.momentEditable = false
    }
    
    init(qty: Any, weight: Double, arm: Double, moment: Double, qtyEditable: Bool, weightEditable: Bool, momentEditable: Bool, title: String) {
        self.title = title
        self.weight = weight
        self.arm = arm
        self.moment = moment
        self.qty = qty
        self.qtyEditable = qtyEditable
        self.weightEditable = weightEditable
        self.momentEditable = momentEditable
       
        if self.title.contains("Basic Empty Weight") {
            if self.weight != 0 {
                self.arm = self.moment*1000/self.weight
            }
        }
        else if self.title.contains("Fuel for Start") {
            self.moment = self.arm*self.weight/1000
        }
        else if self.title.contains("Oxygen") {
            self.weight = (qty as! OxygenQty).value
            self.moment = self.weight*self.arm/1000
        }
        else if self.title.contains("Anti-Ice") {
            self.weight = (self.qty as! Double) * 9.2
            self.moment = self.weight*self.arm/1000
        }
        else if self.title.contains("Fuel Load") {
            self.weight = (self.qty as! Double) * 6
            self.moment = self.weight*self.arm/1000
        }
        else if self.title.contains("Fuel for Flight") {
            self.weight = (self.qty as! Double) * (-6)
            self.moment = self.weight*self.arm/1000
        }
    }
    
    func setQty(qtyValue: Any?) {
        self.qty = qtyValue
        if self.title.contains("Oxygen") {
            self.weight = (qty as! OxygenQty).value
            self.setMoment(value: self.weight*self.arm/1000)
        }
        else if self.title.contains("Anti-Ice") {
            self.weight = (self.qty as! Double) * 9.2
            self.setMoment(value: self.weight*self.arm/1000)
        }
        else if self.title.contains("Fuel Load") {
            self.weight = (self.qty as! Double) * 6
            self.setMoment(value: self.weight*self.arm/1000)
        }
        else if self.title.contains("Fuel for Flight") {
            self.weight = (self.qty as! Double) * (-6)
            self.setMoment(value: self.weight*self.arm/1000)
        }
    }
    
    func setWeight(value: Double) {
        self.weight = value
        if wbItem != nil {
            wbItem.update()
        }
    }
    
    func setMoment(value: Double) {
        self.moment = value
        if wbItem != nil {
            wbItem.update()
        }
    }
    
    func setArm(value: Double) {
        self.arm = value
        if wbItem != nil {
            wbItem.update()
        }
    }
}

class WBItem {
    var name: String!
    var revisedDate: String!
    
    var aircraftType: AircraftType!
    var type: TemplateType!
    var rows = [WBRow]()
    
    var zeroFuelRow: WBRow!
    var rampConditionRow: WBRow!
    var fuelForStartRow: WBRow!
    var takeOffConditionRow: WBRow!
    var fuelForFlightRow: WBRow!
    var landingConditionRow: WBRow!
    
    var chartData: WBChartData!
    
    func data() -> [String: Any] {
        var dict = [String: Any]()
        var data = [Any]()
        for row in self.rows {
            data.append(row.dictionary())
        }
        
        if self.name != nil {
            dict["name"] = self.name
        }
        
        dict["rows"] = data
        dict["aircraftType"] = "\(self.aircraftType.rawValue)"
        if self.type != nil {
            dict["templateType"] = "\(self.type.rawValue)"
        }
        dict["revisedDate"] = self.revisedDate
        return dict
    }
    
    class func item(from dict: [String: Any]) -> WBItem {
        let item = WBItem()
        item.aircraftType =  AircraftType(rawValue: Int(dict["aircraftType"] as! String)!)
        if dict["templateType"] != nil {
            item.type =  TemplateType(rawValue: Int(dict["templateType"] as! String)!)
        }
        item.revisedDate =  dict["revisedDate"] as! String
        if dict["name"] != nil {
            item.name = dict["name"] as! String
        }
        
        let dictArray = dict["rows"] as! [[String: Any]]
        item.rows = [WBRow]()
        for dict in dictArray {
            item.add(row: WBRow.row(from: dict))
        }
        return item
    }
    
    func row(for title: String) -> WBRow?{
        for row in self.rows {
            if row.title == title {
                return row
            }
        }
        return nil
    }
    
    func clear() {
        let zeroFuelIndex = self.zeroFuelIndex()
        if zeroFuelIndex != -1 {
            self.zeroFuelRow = self.rows[zeroFuelIndex]
            for i in 1..<zeroFuelIndex {
                let row = rows[i]
                if row.title == "Anti-Ice Fluid" || row.title == "Oxygen" {
                    continue
                }
                row.weight = 0
            }
        }
        self.update()
    }
    
    func add(row: WBRow) {
        row.wbItem = self
        if row.title.contains("Zero Fuel Condition") {
            self.zeroFuelRow = row
        }
        else if row.title.contains("Ramp Condition") {
            self.rampConditionRow = row
        }
        else if row.title.contains("Fuel for Start") {
            self.fuelForStartRow = row
        }
        else if row.title.contains("Takeoff Condition") {
            self.takeOffConditionRow = row
        }
        else if row.title.contains("Fuel for Flight") {
            self.fuelForFlightRow = row
        }
        else if row.title.contains("Landing Condition") {
            self.landingConditionRow = row
        }
        self.rows.append(row)
    }
    
    func zeroFuelIndex() -> Int {
        for i in 0..<rows.count {
            if rows[i].title.contains("Zero Fuel") {
                return i
            }
        }
        return -1
    }
    
    func rampConditionIndex() -> Int {
        for i in 0..<rows.count {
            if rows[i].title.contains("Ramp Condition") {
                return i
            }
        }
        return -1
    }
    
    func update() {
        if self.rows[0].weight != 0 {
            self.rows[0].arm = self.rows[0].moment / self.rows[0].weight * 1000
        }
// Zero Fuel
        let zeroFuelIndex = self.zeroFuelIndex()
        zeroFuelRow.weight = 0
        zeroFuelRow.moment = 0
        if zeroFuelIndex != -1 {
            self.zeroFuelRow = self.rows[zeroFuelIndex]
            for i in 0..<zeroFuelIndex {
                let row = rows[i]
                row.moment = row.weight*row.arm/1000
                zeroFuelRow.weight = zeroFuelRow.weight + row.weight
                zeroFuelRow.moment = zeroFuelRow.moment + row.moment
            }
            if zeroFuelRow.weight != 0 {
                zeroFuelRow.arm = zeroFuelRow.moment*1000/zeroFuelRow.weight
            }
            else {
                zeroFuelRow.arm = 0
            }
        }
// Ramp Condition
        rampConditionRow.weight = 0.0
        rampConditionRow.moment = 0.0
        let rampConditionIndex = self.rampConditionIndex()
        if rampConditionIndex != -1 {
            self.rampConditionRow = self.rows[rampConditionIndex]
            for i in zeroFuelIndex..<rampConditionIndex {
                let row = rows[i]
                rampConditionRow.weight = rampConditionRow.weight + row.weight
                rampConditionRow.moment = rampConditionRow.moment + row.moment
            }
            if rampConditionRow.weight != 0 {
                rampConditionRow.arm = rampConditionRow.moment*1000/rampConditionRow.weight
            }
            else {
                rampConditionRow.arm = 0
            }
        }
//Takeoff Condition
        if self.takeOffConditionRow != nil, self.rampConditionRow != nil, self.fuelForStartRow != nil{
            self.takeOffConditionRow.weight = self.rampConditionRow.weight + self.fuelForStartRow.weight
            self.takeOffConditionRow.moment = self.rampConditionRow.moment + self.fuelForStartRow.moment
            self.takeOffConditionRow.arm = takeOffConditionRow.moment*1000/takeOffConditionRow.weight
        }
        else {
            self.takeOffConditionRow.weight = 0
        }
//Landing Condition
        if self.landingConditionRow != nil, self.fuelForFlightRow != nil, self.takeOffConditionRow != nil{
            self.landingConditionRow.weight = self.fuelForFlightRow.weight + self.takeOffConditionRow.weight
            self.landingConditionRow.moment = self.fuelForFlightRow.moment + self.takeOffConditionRow.moment
            self.landingConditionRow.arm = landingConditionRow.moment*1000/landingConditionRow.weight
        }
        else {
            self.landingConditionRow.weight = 0
        }
    }
}

class WBManager {
    static let sharedInstance = WBManager()
    var customItems = [WBItem]()
    var currentItem: WBItem!

    init() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.loadCustomItems()
        }
    }
    
    func saveItem(item: WBItem, withName name: String){
        self.deleteItem(with: name)
        
        let data = item.data()
        let newItem = WBItem.item(from: data)
        newItem.name = name
        newItem.chartData = self.chartData(for: newItem.aircraftType)
        
        self.customItems.append(newItem)

        let dict: NSDictionary = newItem.data() as NSDictionary
        let str = dict.xmlString()
        let path = Manager.WBDirectory().appendingPathComponent(path: newItem.name)
        do {
            try str?.write(toFile: path, atomically: true, encoding: .utf8)
        }catch {
            print ("Error to save WB Item:" + error.localizedDescription)
        }
    }
    
    func deleteItem(with name: String) {
        for i in 0..<self.customItems.count {
            let item = self.customItems[i]
            if item.name == name {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                    let path = Manager.WBDirectory().appendingPathComponent(path: item.name)
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    }
                    catch {
                        print ("Error to delete WB Item:" + error.localizedDescription)
                    }
                }
                self.customItems.remove(at: i)
                break
            }
        }
    }
    
    func loadCustomItems() {
        self.customItems.removeAll()
        
        let fileManager = FileManager.default
        do {
            let directoryPath = Manager.WBDirectory()
            let paths = try fileManager.contentsOfDirectory(atPath: directoryPath)
            for path in paths {
                let filePath = directoryPath.appendingPathComponent(path: path)
                
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                if let dict = XMLDictionaryParser.sharedInstance().dictionary(with: content) {
                    let item = WBItem.item(from: dict as! [String: Any])
                    item.chartData = self.chartData(for: item.aircraftType)
                    self.customItems.append(item)
                }
            }
        }
        catch {
            print ("Load WB Item: " + error.localizedDescription)
        }
    }
    
    func customItem(with name: String) -> WBItem? {
        var currentItem: WBItem? = nil
        for item in self.customItems {
            if item.name == name {
                currentItem = item
                break
            }
        }
        
        if let item = currentItem {
            item.chartData = chartData(for: item.aircraftType)
        }
        return currentItem
    }
    
    func chartData(for aircraftType: AircraftType) -> WBChartData?{
        if aircraftType == .SR20_G1_G2 {
            return WBChartData(envelopTitle: "Envelope", limitTitle: "TakeOff", envelops: [CGPoint(x:2110, y:144.6), CGPoint(x:2110, y:138.7), CGPoint(x:2694, y:141), CGPoint(x:3000, y:144.1), CGPoint(x:3000, y:148), CGPoint(x:2900, y:148.1), CGPoint(x:2570, y:147.4), CGPoint(x:2110, y:144.6)],
                        limits: [CGPoint(x:2900, y:148.1), CGPoint(x:2900, y:143.1), CGPoint(x:3000, y:144.1), CGPoint(x:3000, y:148), CGPoint(x:2900, y:148.1)])
        }
        else if aircraftType == .SR20_G3 {
            return WBChartData(envelopTitle: "Envelope", limitTitle: nil, envelops: [CGPoint(x:2100, y:137.8), CGPoint(x:2700, y:139.1), CGPoint(x:3050, y:141.4), CGPoint(x:3050, y:148.1), CGPoint(x:2100, y:148.1), CGPoint(x:2100, y:137.8)], limits: nil)
        }
        else if aircraftType == . SR22_G1_G2 {
            return WBChartData(envelopTitle: "Envelope", limitTitle: "TakeOff", envelops: [CGPoint(x:2100, y:137.8), CGPoint(x:2700, y:139.1), CGPoint(x:3400, y:142.3), CGPoint(x:3400, y:148.1), CGPoint(x:2100, y:148.1), CGPoint(x:2100, y:137.8)],
                               limits: [CGPoint(x:3210, y:141.4), CGPoint(x:3400, y:142.6), CGPoint(x:3400, y:142.3), CGPoint(x:3210, y:141.4)])
        }
        else if aircraftType == .SR22_G3 {
            return WBChartData(envelopTitle: "Envelope", limitTitle: nil, envelops: [CGPoint(x:2100, y:137.8), CGPoint(x:2700, y:139.1), CGPoint(x:3400, y:142.3), CGPoint(x:3400, y:148.1), CGPoint(x:2100, y:148.1), CGPoint(x:2100, y:137.8)], limits: nil)
        }
        else if aircraftType == .SR22_G5 {
            return WBChartData(envelopTitle: "Envelope", limitTitle: "Zero Fuel", envelops: [CGPoint(x:2100, y:137.8), CGPoint(x:2700, y:139.1), CGPoint(x:3600, y:143.2), CGPoint(x:3600, y:148.2), CGPoint(x:2100, y:148.2), CGPoint(x:2100, y:137.8)], limits: [CGPoint(x:3400, y:142.5), CGPoint(x:3400, y:148.1)])
        }
        else if aircraftType == .SR22T_G3 {
            return WBChartData(envelopTitle: "Envelope", limitTitle: nil, envelops: [CGPoint(x:2100, y:137.8), CGPoint(x:2700, y:139.1), CGPoint(x:3400, y:142.3), CGPoint(x:3400, y:148.1), CGPoint(x:2100, y:148.1), CGPoint(x:2100, y:137.8)], limits: nil)
        }
        else if aircraftType == .SR22T_G5 {
            return WBChartData(envelopTitle: "Envelope", limitTitle: "Zero Fuel", envelops: [CGPoint(x:2100, y:137.8), CGPoint(x:2700, y:139.1), CGPoint(x:3600, y:143.2), CGPoint(x:3600, y:148.2), CGPoint(x:2100, y:148.2), CGPoint(x:2100, y:137.8)], limits: [CGPoint(x:3400, y:142.5), CGPoint(x:3400, y:148.1)])
        }
        return nil
    }
    
    func item(for aircraftType: AircraftType) -> WBItem {
        let item = WBItem()
        item.aircraftType = aircraftType
        item.chartData = chartData(for: aircraftType)
        if aircraftType == .SR20_G1_G2 {
            item.add(row: WBRow(qty: 1.0 , weight: 2154, arm: 141.2, moment: 304.235, qtyEditable: false, weightEditable: true , momentEditable: true , title: "Basic Empty Weight (from Aircraft POH)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Pilot"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Front Passenger"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 1"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 2"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 208.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Baggage Compartment"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Zero Fuel Condition"));
            item.add(row: WBRow(qty: 56.0, weight: 0.00, arm: 153.8, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel Load"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Ramp Condition"));
            item.add(row: WBRow(qty: 1.0 , weight: -6.0, arm: 153.8, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Fuel for Start, Taxi, & Run-up"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Takeoff Condition"));
            item.add(row: WBRow(qty: 56.0, weight: 0.00, arm: 153.8, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel for Flight"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Landing Condition"));
            item.revisedDate = "Revised: 6/16/2009"
        }
        else if aircraftType == .SR20_G3 {
            item.add(row: WBRow(qty: 1.0 , weight: 2111, arm: 139.9, moment: 295.421, qtyEditable: false, weightEditable: true , momentEditable: true , title: "Basic Empty Weight (from Aircraft POH)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Pilot"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Front Passenger"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 1"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00 , arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 2"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00 , arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 3 (if equipped)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 208.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Baggage Compartment"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Zero Fuel Condition"));
            item.add(row: WBRow(qty: 56.0, weight: 0.00, arm: 153.8, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel Load"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Ramp Condition"));
            item.add(row: WBRow(qty: 1.0 , weight: -6.0, arm: 153.8, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Fuel for Start, Taxi, & Run-up"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Takeoff Condition"));
            item.add(row: WBRow(qty: 56.0, weight: 0.00, arm: 153.8, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel for Flight"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Landing Condition"));
            
            item.revisedDate = "Revised: 6/16/2009"
        }
        else if aircraftType == .SR22_G1_G2 {
            item.add(row: WBRow(qty: 1.0 , weight: 2358, arm: 0.000, moment: 327.162, qtyEditable: false, weightEditable: true , momentEditable: true , title: "Basic Empty Weight (from Aircraft POH)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Pilot"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Front Passenger"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 1"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00 , arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 2"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 208.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Baggage Compartment"));
            item.add(row: WBRow(qty: OxygenQty.psi0, weight: 0.00, arm: 273.5, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Oxygen"));
            item.add(row: WBRow(qty: 2.9, weight: 27 , arm: 181.0, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Anti-Ice Fluid"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Zero Fuel Condition"));
            item.add(row: WBRow(qty: 81.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel Load"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Ramp Condition"));
            item.add(row: WBRow(qty: 1.0 , weight: -9.0, arm: 154.9, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Fuel for Start, Taxi, & Run-up"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Takeoff Condition"));
            item.add(row: WBRow(qty: 81.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel for Flight"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Landing Condition"));
            
            item.revisedDate = "Revised: 6/16/2009"
        }
        else if aircraftType == .SR22_G3 {
            item.add(row: WBRow(qty: 1.0 , weight: 2456, arm: 0.000, moment: 343.307, qtyEditable: false, weightEditable: true , momentEditable: true , title: "Basic Empty Weight (from Aircraft POH)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Pilot"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Front Passenger"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 1"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 2"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 3 (if equipped)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 208.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Baggage Compartment"));
            item.add(row: WBRow(qty: OxygenQty.psi1800, weight: 0.00, arm: 273.5, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Oxygen"));
            item.add(row: WBRow(qty: 8.0, weight: 74 , arm: 148.4, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Anti-Ice Fluid"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Zero Fuel Condition"));
            item.add(row: WBRow(qty: 92.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel Load"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Ramp Condition"));
            item.add(row: WBRow(qty: 1.0 , weight: -9.0, arm: 154.9, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Fuel for Start, Taxi, & Run-up"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Takeoff Condition"));
            item.add(row: WBRow(qty: 92.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel for Flight"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Landing Condition"));
            
            item.revisedDate = "Revised: 6/16/2009"
        }
        else if aircraftType == .SR22_G5 {
            item.add(row: WBRow(qty: 1.0 , weight: 2456, arm: 0.000, moment: 343.307, qtyEditable: false, weightEditable: true , momentEditable: true , title: "Basic Empty Weight (from Aircraft POH)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00,  arm: 143.5, moment: 33.149 , qtyEditable: false, weightEditable: true , momentEditable: false, title: "Pilot"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Front Passenger"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 1"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 2"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 3"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 208.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Baggage Compartment"));
            item.add(row: WBRow(qty: OxygenQty.psi1800, weight: 0.00, arm: 273.5, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Oxygen"));
            item.add(row: WBRow(qty: 8.0, weight: 74 , arm: 148.4, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Anti-Ice Fluid"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Zero Fuel Condition"));
            item.add(row: WBRow(qty: 92.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel Load"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Ramp Condition"));
            item.add(row: WBRow(qty: 1.0 , weight: -9.0, arm: 154.9, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Fuel for Start, Taxi, & Run-up"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Takeoff Condition"));
            item.add(row: WBRow(qty: 80.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel for Flight"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Landing Condition"));
            
            item.revisedDate = "Revised: 2/10/2011"
        }
        else if aircraftType == .SR22T_G3 {
            item.add(row: WBRow(qty: 1.0 , weight: 2456, arm: 0.000, moment: 343.307, qtyEditable: false, weightEditable: true , momentEditable: true , title: "Basic Empty Weight (from Aircraft POH)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00,  arm: 143.5, moment: 0.0000 , qtyEditable: false, weightEditable: true , momentEditable: false, title: "Pilot"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Front Passenger"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 1"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 2"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 3 (if equipped)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 208.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Baggage Compartment"));
            item.add(row: WBRow(qty: OxygenQty.psi1800, weight: 0.00, arm: 273.5, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Oxygen"));
            item.add(row: WBRow(qty: 8.0, weight: 74 , arm: 148.4, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Anti-Ice Fluid"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Zero Fuel Condition"));
            item.add(row: WBRow(qty: 92.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel Load"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Ramp Condition"));
            item.add(row: WBRow(qty: 1.0 , weight: -9.0, arm: 154.9, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Fuel for Start, Taxi, & Run-up"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Takeoff Condition"));
            item.add(row: WBRow(qty: 92.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel for Flight"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Landing Condition"));
            
            item.revisedDate = "Revised: 2/10/2011"
        }
        else if aircraftType == .SR22T_G5 {
            item.add(row: WBRow(qty: 1.0 , weight: 2456, arm: 0.000, moment: 343.307, qtyEditable: false, weightEditable: true , momentEditable: true , title: "Basic Empty Weight (from Aircraft POH)"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.0000 , qtyEditable: false, weightEditable: true , momentEditable: false, title: "Pilot"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 143.5, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Front Passenger"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 1"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 2"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 180.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Rear Passenger 3"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 208.0, moment: 0.00000, qtyEditable: false, weightEditable: true , momentEditable: false, title: "Baggage Compartment"));
            item.add(row: WBRow(qty: OxygenQty.psi1800, weight: 0.00, arm: 273.5, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Oxygen"));
            item.add(row: WBRow(qty: 8.0, weight: 74 , arm: 148.4, moment: 0.00000, qtyEditable: true , weightEditable: false , momentEditable: false, title: "Anti-Ice Fluid"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Zero Fuel Condition"));
            item.add(row: WBRow(qty: 92.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel Load"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Ramp Condition"));
            item.add(row: WBRow(qty: 1.0 , weight: -9.0, arm: 154.9, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Fuel for Start, Taxi, & Run-up"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Takeoff Condition"));
            item.add(row: WBRow(qty: 80.0, weight: 0.00, arm: 154.9, moment: 0.00000, qtyEditable: true , weightEditable: false, momentEditable: false, title: "Fuel for Flight"));
            item.add(row: WBRow(qty: 1.0 , weight: 0.00, arm: 0.000, moment: 0.00000, qtyEditable: false, weightEditable: false, momentEditable: false, title: "Landing Condition"));
            
            item.revisedDate = "Revised: 2/10/2011"
        }
        return item
    }
}
