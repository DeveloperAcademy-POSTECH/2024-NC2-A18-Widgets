//
//  Extension+Date.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/20/24.
//

import Foundation

extension Date{
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
