//
//  APIRequest.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/13/23.
//

import Foundation
protocol APIRequest {
    var endPoint : String{get}
    var method : APIMetods{get}
    var parametr: [String:Any]{get}
}
