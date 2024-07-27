//
//  AIWritingModels.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/16/24.
//

import Foundation

struct IntroduceResponse: Codable {
    let data: IntroduceData
}

struct IntroduceData: Codable {
    let introduceText: String
    let price: String 
}
