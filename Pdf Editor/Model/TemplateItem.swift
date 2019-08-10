//
//  TemplateItem.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

public enum TemplateType: Int {
    case transition22 = 1
    case transition22T = 2
    case transition22TN = 3
    case transition20 = 4
    
    case transitionCP = 5
    case transitionAVIDYNE = 6
    case recurrentIFR = 7
    case recurrentVFR = 8
    case recurrentLST = 9
    case recurrentCAPS = 10
    case recurrent90Day = 11
    
    case fom_cirrus = 12
    case fom_avidyne = 13
    
    case poh_1 = 14
    case poh_2 = 15
    case poh_3 = 16
    case poh_4 = 17
    
    case sillaby = 18
    
    var isRef: Bool {
        switch self {
        case .transition22, .transition22T,.transition22TN ,.transition20,.transitionCP, .transitionAVIDYNE,.recurrentIFR,.recurrentVFR, .recurrentLST, .recurrentCAPS, .recurrent90Day:
            return false;
        case .fom_cirrus, .fom_avidyne, .poh_1, .poh_2, .poh_3, .poh_4, .sillaby:
            return true;
        }
    }
    
    var image: UIImage? {
        switch self {
        case .transition22:
            return UIImage(named: "type1")
        case .transition22T:
            return UIImage(named: "type2")
        case .transition22TN:
            return UIImage(named: "type3")
        case .transition20:
            return UIImage(named: "type4")
        case .transitionCP:
            return UIImage(named: "type5")
        case .transitionAVIDYNE:
            return UIImage(named: "type6")
        case .recurrentIFR:
            return UIImage(named: "recurrent1")
        case .recurrentVFR:
            return UIImage(named: "recurrent2")
        case .recurrentLST:
            return UIImage(named: "recurrent3")
        case .recurrentCAPS:
            return UIImage(named: "recurrent4")
        case .recurrent90Day:
            return UIImage(named: "recurrent5")
            
        case .fom_cirrus:
            return UIImage(named: "type5")
        case .fom_avidyne:
            return UIImage(named: "type6")
            
        case .poh_1:
            return UIImage(named: "type4")
        case .poh_2:
            return UIImage(named: "type1")
        case .poh_3:
            return UIImage(named: "type2")
        case .poh_4:
            return UIImage(named: "type3")
        case .sillaby:
            return UIImage(named: "sillaby")
        }
    }
    
    var aircraftModel: String? {
        switch self {
        case .transition22:
            return "SR22"
        case .transition22T:
            return "SR22T"
        case .transition22TN:
            return "SR22TN"
        case .transition20:
            return "SR20"
        default:
            return nil
        }
    }
}

class TemplateItem{
    var name: String!
    var file: String!
    var type: TemplateType!
    
    init(name: String, type: TemplateType, file: String!) {
        self.name = name
        self.type = type
        self.file = file
    }
}
