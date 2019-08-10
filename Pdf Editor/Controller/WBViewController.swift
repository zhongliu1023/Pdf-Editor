//
//  WBViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/31/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit
import SwiftCharts
import MessageUI

class WBViewController: UIViewController {
    @IBOutlet weak var tblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var tblWBItem: UITableView!
    @IBOutlet weak var vwChartContainer: UIView!
    @IBOutlet weak var vwChartMilestone: UIView!
    @IBOutlet weak var lblReviseDate: UILabel!
    @IBOutlet weak var legendHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtFormName: UITextField!
    @IBOutlet weak var tblFormList: UITableView!
    
    @IBOutlet weak var imgFormIcon: UIImageView!
    @IBOutlet weak var formIconWidth: NSLayoutConstraint!
    @IBOutlet weak var vwFormNameContainer: SpringView!
    
    
    var chart: Chart!
    var chartView: ChartView!
    var item: WBItem!
    var selectedButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwChartMilestone.layer.borderColor = Constant.UI.TINT_COLOR.cgColor
        vwChartMilestone.layer.borderWidth = 3
        vwChartMilestone.isHidden = true
        vwChartMilestone.layer.cornerRadius = 3
        vwChartMilestone.layer.masksToBounds = true
    
        self.vwFormNameContainer.layer.borderWidth = 1
        self.vwFormNameContainer.layer.borderColor = Constant.UI.TEXTFIELD_BORDER_COLOR.cgColor

        self.tblFormList.layer.borderWidth = 1
        self.tblFormList.layer.borderColor = Constant.UI.TEXTFIELD_BORDER_COLOR.cgColor

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropDownList))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    // Do any additional setup after loading the view.
    }
    
    func hideDropDownList() {
        self.tblFormList.isHidden = true
        self.txtFormName.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.selectedButton == nil {
            self.onAirCraftButton(self.view.viewWithTag(7) as! SpringButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.layoutIfNeeded()
        self.updateChart()
    }
    
    @IBAction func onAirCraftButton(_ sender: SpringButton) {
        self.selectButton(sender)
        let item = WBManager.sharedInstance.item(for: AircraftType(rawValue: sender.tag)!)

        self.txtFormName.text = item.name
        self.imgFormIcon.image = item.aircraftType.image
        self.formIconWidth.constant = 0.0
        self.imgFormIcon.layoutIfNeeded()
        self.tblFormList.isHidden = true
        self.txtFormName.resignFirstResponder()

        self.reset(with: item)
    }
    
    func reset(with item: WBItem) {
        self.item = item
        self.item.update()
        self.lblReviseDate.text = self.item.revisedDate
        self.reloadTable()
    }
    
    func selectButton(_ sender: SpringButton) {
        if selectedButton != nil {
            selectedButton.backgroundColor = UIColor.clear
            selectedButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        self.selectedButton = sender
        UIView.animate(withDuration: 0.1, animations: {
            self.selectedButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { result in
            UIView.animate(withDuration: 0.1, animations: {
                self.selectedButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                self.selectedButton.backgroundColor = Constant.UI.BUTTON_HIGHLIGHT_COLOR
            }, completion: { result in
                UIView.animate(withDuration: 0.1, animations: {
                    self.selectedButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: nil)
            })
        })
    }
    
    func reloadTable() {
        tblHeightConstraints.constant = CGFloat((self.item.rows.count) * 29 + 32)
        NSLayoutConstraint.activate([tblHeightConstraints])
        self.tblWBItem.reloadData()
        self.vwChartContainer.layoutIfNeeded()
        self.updateChart()
    }
    
    @IBAction func onDropDown(_ sender: Any) {
        self.tblFormList.isHidden = !self.tblFormList.isHidden
    }
}

extension WBViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblWBItem {
            if indexPath.row == self.item.rows.count - 1 {
                return 30
            }
            return 29
        }
        else {
            return 50
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblWBItem {
            if self.item != nil {
                return self.item.rows.count
            }
            return 0
        }
        else {
            return WBManager.sharedInstance.customItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblWBItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WB_ROW_CELL") as! WBTableViewCell
            cell.resetWithWBRow(row: self.item.rows[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FORM_CELL") as! FormTableViewCell
            cell.reset(with: WBManager.sharedInstance.customItems[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblFormList {
            self.tblFormList.isHidden = true
            let item = WBManager.sharedInstance.customItems[indexPath.row]
            self.reset(with: item)
            if item.name != nil {
                self.txtFormName.text = item.name
                self.imgFormIcon.image = item.aircraftType.image
                self.formIconWidth.constant = 30.0
                self.imgFormIcon.layoutIfNeeded()
            }
        }
    }
}

extension WBViewController: WBTableViewCellDelegate {
    func valueChanged() {
        for i in 0..<self.item.rows.count {
            let cell = self.tblWBItem.cellForRow(at: IndexPath(row: i, section: 0)) as! WBTableViewCell
            cell.resetWithWBRow(row: item.rows[i])
        }
        updateChart()
    }
    
    func nextInput(_ currentTextField: UITextField, rowIndex: Int) {
        guard rowIndex + 1 < self.item.rows.count else {
            return
        }
        
        if let cell = self.tblWBItem.cellForRow(at: IndexPath(row: rowIndex+1, section: 0)) as? WBTableViewCell {
            if cell.txtWeight != nil && cell.txtWeight.isEnabled{
                cell.txtWeight.becomeFirstResponder()
            }
        }
    }
}

extension WBViewController { // Chart View
    func updateLegend() {
        vwChartMilestone.isHidden = false

        for subview in self.vwChartMilestone.subviews {
            subview.removeFromSuperview()
        }
        
        if let chartData = self.item.chartData {
            var height: CGFloat = 80.0
            let startY: CGFloat = 0.0
            let rtLegend = self.vwChartMilestone.bounds
            let lblEnvelope = UILabel(frame: CGRect(x: 0, y: startY+0, width: rtLegend.width, height: 20))
            lblEnvelope.backgroundColor = Constant.UI.LABEL_BACKCOLOR
            lblEnvelope.text = " - " + chartData.envelopTitle
            lblEnvelope.textColor = Constant.UI.ENVELOPE_COLOR
            lblEnvelope.font = UIFont.boldSystemFont(ofSize: 14)
            self.vwChartMilestone.addSubview(lblEnvelope)
            
            let lblCGTakeOff = UILabel(frame: CGRect(x: 0, y: startY+20, width: rtLegend.width, height: 20))
            lblCGTakeOff.backgroundColor = Constant.UI.LABEL_BACKCOLOR
            lblCGTakeOff.text = " • Takeoff CG"
            lblCGTakeOff.textColor = Constant.UI.TAKEOFF_CG_COLOR
            lblCGTakeOff.font = UIFont.boldSystemFont(ofSize: 14)
            self.vwChartMilestone.addSubview(lblCGTakeOff)
            
            let lblCGLanding = UILabel(frame: CGRect(x: 0, y: startY+40, width: rtLegend.width, height: 20))
            lblCGLanding.backgroundColor = Constant.UI.LABEL_BACKCOLOR
            lblCGLanding.text = " • Landing CG"
            lblCGLanding.textColor = Constant.UI.LANDING_CG_COLOR
            lblCGLanding.font = UIFont.boldSystemFont(ofSize: 14)
            self.vwChartMilestone.addSubview(lblCGLanding)
            
            let lblFuelBurn = UILabel(frame: CGRect(x: 0, y: startY+60, width: rtLegend.width, height: 20))
            lblFuelBurn.backgroundColor = Constant.UI.LABEL_BACKCOLOR
            lblFuelBurn.text = " - Fuel Burn"
            lblFuelBurn.textColor = Constant.UI.FUEL_BURN_COLOR
            lblFuelBurn.font = UIFont.boldSystemFont(ofSize: 14)
            self.vwChartMilestone.addSubview(lblFuelBurn)
            
            if chartData.limits != nil {
                let lblLimits = UILabel(frame: CGRect(x: 0, y: startY+80, width: rtLegend.width, height: 20))
                lblLimits.backgroundColor = Constant.UI.LABEL_BACKCOLOR
                lblLimits.text = " - " + chartData.limitTitle
                lblLimits.textColor = Constant.UI.LIMIT_COLOR
                lblLimits.font = UIFont.boldSystemFont(ofSize: 14)
                self.vwChartMilestone.addSubview(lblLimits)
                height = height + 20
            }
            legendHeightConstraints.constant = height
            self.vwChartMilestone.layoutIfNeeded()
        }
    }
    
    func updateChart() {
        guard self.item != nil else {
            return
        }
        
        if chartView != nil {
            chartView.removeFromSuperview()
        }
        self.chart = nil
        updateLegend()
        drawChart()
    }

    func settings() -> ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 20
        chartSettings.top = 20
        chartSettings.trailing = 20
        chartSettings.bottom = 20
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 5
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 10
        chartSettings.spacingBetweenAxesY = 20
        return chartSettings
    }
    
    func drawChart() {
        let labelSettings = ChartLabelSettings(font: UIFont(name: "Helvetica", size: 14)!)
        var envelopes = [CGPoint]()
        envelopes.append(contentsOf: self.item.chartData.envelopes)
        envelopes.append(self.item.chartData.envelopes[0])
        
        let chartPoints = envelopes.map{ChartPoint(x: ChartAxisValueDouble(Double($0.y), labelSettings: labelSettings), y: ChartAxisValueDouble(Double($0.x)))}
        
        let (min, max, count) = self.item.chartData.range()
        let axisPoints = [min, max].map{ChartPoint(x: ChartAxisValueDouble(Double($0.y)), y: ChartAxisValueDouble(Double($0.x)))}
       
        let xValues = ChartAxisValuesGenerator.generateXAxisValuesWithChartPoints(axisPoints, minSegmentCount: 0, maxSegmentCount: Double(count.y), multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(axisPoints, minSegmentCount: 0, maxSegmentCount: Double(count.x), multiple: 200, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "C.G - Inches Aft of Datum", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Weight (lbs)", settings: labelSettings.defaultVertical()))
        
        let chartFrame = self.vwChartContainer.bounds
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: self.settings(), chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)

//Main Border For Envelope
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: Constant.UI.ENVELOPE_COLOR, lineWidth: 2, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])

        let circleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let circleView = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 15)
            circleView.animDuration = 1
            circleView.fillColor = UIColor.white
            circleView.borderWidth = 5
            circleView.borderColor = Constant.UI.ENVELOPE_COLOR
            return circleView
        }
        let chartPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: circleViewGenerator, displayDelay: 0, delayBetweenItems: 0.01)

// Zero Fuel or Take Off limitation
        var limitPointsLineLayer: ChartPointsLineLayer? = nil
        if self.item.chartData.limits != nil {
                var limits = [CGPoint]()
                limits.append(contentsOf: self.item.chartData.limits)
                limits.append(self.item.chartData.limits[0])

                let limitPoints = limits.map{ChartPoint(x: ChartAxisValueDouble(Double($0.y), labelSettings: labelSettings), y: ChartAxisValueDouble(Double($0.x)))}
                
                let lineModel = ChartLineModel(chartPoints: limitPoints, lineColor: Constant.UI.LIMIT_COLOR, lineWidth: 2, animDuration: 1, animDelay: 0)
                limitPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        }

// Takeoff Condition and Landing Condition
        let results = [CGPoint(x: self.item.takeOffConditionRow.weight, y: self.item.takeOffConditionRow.arm),
                       CGPoint(x: self.item.landingConditionRow.weight, y: self.item.landingConditionRow.arm)]
        let resultPoints = results.map{ChartPoint(x: ChartAxisValueDouble(Double($0.y), labelSettings: labelSettings), y: ChartAxisValueDouble(Double($0.x)))}
        
        let resultlineModel = ChartLineModel(chartPoints: resultPoints, lineColor: Constant.UI.FUEL_BURN_COLOR, lineWidth: 5, animDuration: 1, animDelay: 0)
        let resultPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [resultlineModel])
        
        let takeOffCircleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let circleView = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 20)
            circleView.animDuration = 1.5
            circleView.fillColor = Constant.UI.TAKEOFF_CG_COLOR
            circleView.borderWidth = 1
            circleView.borderColor = UIColor.black
            return circleView
        }
        let takeOffPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: [resultPoints[0]], viewGenerator: takeOffCircleViewGenerator, displayDelay: 0, delayBetweenItems: 0.01)
        
        let landingCircleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
//            let centerPoint = chartPointModel.screenLoc
//            let radius: CGFloat = 10
//            let points = [CGPoint(x: centerPoint.x - radius, y: centerPoint.y - radius), CGPoint(x: centerPoint.x - radius, y: centerPoint.y + radius), CGPoint(x: centerPoint.x + radius, y: centerPoint.y + radius), CGPoint(x: centerPoint.x + radius, y: centerPoint.y - radius)]
//            let rectView = ChartAreasView(points: points, frame: CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: radius*2, height: radius*2), color: Constant.UI.LANDING_CG_COLOR, animDuration: 1.5, animDelay: 0)
//            return rectView
            let circleView = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 20)
            circleView.animDuration = 1.5
            circleView.fillColor = Constant.UI.LANDING_CG_COLOR
            circleView.borderWidth = 1
            circleView.borderColor = UIColor.black
            return circleView
        }
        let landingPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: [resultPoints[1]], viewGenerator: landingCircleViewGenerator, displayDelay: 0, delayBetweenItems: 0.01)
// Grid Line
        let xGridValues = ChartAxisValuesGenerator.generateXAxisValuesWithChartPoints(axisPoints, minSegmentCount: 0, maxSegmentCount: Double(count.y)*4, multiple: 0.5, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        let yGridValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(axisPoints, minSegmentCount: 0, maxSegmentCount: Double(count.x)*4, multiple: 100, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: true)
        
        let xGridModel = ChartAxisModel(axisValues: xGridValues, axisTitleLabel: ChartAxisLabel(text: "C.G - Inches Aft of Datum", settings: labelSettings))
        let yGridModel = ChartAxisModel(axisValues: yGridValues, axisTitleLabel: ChartAxisLabel(text: "Weight (lbs)", settings: labelSettings.defaultVertical()))
        
        let coordsGridSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: self.settings(), chartFrame: chartFrame, xModel: xGridModel, yModel: yGridModel)
        let (xGridAxis, yGridAxis) = (coordsGridSpace.xAxis, coordsGridSpace.yAxis)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: 1)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xGridAxis, yAxis: yGridAxis, innerFrame: innerFrame, settings: settings)

// Layer Drawing
        var layers = [xAxis, yAxis,  guidelinesLayer, chartPointsLineLayer, chartPointsCircleLayer, resultPointsLineLayer, takeOffPointsCircleLayer, landingPointsCircleLayer] as [Any]
        
        if limitPointsLineLayer != nil {
            layers.append(limitPointsLineLayer!)
        }
        
        let chart = Chart(
            frame: chartFrame,
            layers: layers as! [ChartLayer]
        )
        
        self.chartView = chart.view
        self.vwChartContainer.insertSubview(self.chartView, at: 0)
        self.chart = chart
    }
}

class InstructionViewController: UIViewController {
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEmail(_ sender: Any) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposeViewController.setToRecipients(["training@cirrusaircraft.com"])
        mailComposeViewController.setSubject("Hello")
        mailComposeViewController.setMessageBody("How are you?", isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Could not send email", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension InstructionViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension WBViewController {// form save, delete, clear
    
    @IBAction func onFormSave(_ sender: UIButton) {
        guard txtFormName.text!.characters.count > 0 else {
            self.showError(text: "Please input the Form name")
            return
        }
        
        WBManager.sharedInstance.saveItem(item: self.item, withName: self.txtFormName.text!)
        self.tblFormList.reloadData()
        self.tblFormList.isHidden = true
        self.showMessage(title: "Success", text: "Form saved successfully")
    }
    
    @IBAction func onFormDelete(_ sender: UIButton) {
        guard txtFormName.text!.characters.count > 0 else {
            self.showError(text: "No form selected to delete, Please type the name of the form to delete")
            return
        }
        
        WBManager.sharedInstance.deleteItem(with: txtFormName.text!)
        
        self.tblFormList.reloadData()
        self.txtFormName.text = ""
        self.imgFormIcon.image = nil
        self.formIconWidth.constant = 0.0
        self.imgFormIcon.layoutIfNeeded()
        self.tblFormList.isHidden = true
        self.txtFormName.resignFirstResponder()
        
        self.item.clear()
        self.reloadTable()
        self.showMessage(title: "Success", text: "Form has been deleted successfully")
    }
    
    @IBAction func onFormClear(_ sender: UIButton) {
        self.item.clear()
        self.reloadTable()
    }
}

extension WBViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.tblFormList.isHidden == true {
            return false
        }
        
        if touch.view!.isDescendant(of: self.tblFormList){
            return false
        }
        return true
    }
}

extension WBViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {// became first responder
        guard textField == self.txtFormName else {
            return
        }
        self.tblFormList.isHidden = false
        self.imgFormIcon.image = nil
        self.formIconWidth.constant = 0.0
        self.imgFormIcon.layoutIfNeeded()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {// called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        self.tblFormList.isHidden = true
        return true
    }
}
