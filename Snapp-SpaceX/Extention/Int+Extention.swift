//
//  Int+Extention.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/15/23.
//

import Foundation
extension Int {
    func unixToDate() -> Date{
        let unixTime = self
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        return date
    }
}
