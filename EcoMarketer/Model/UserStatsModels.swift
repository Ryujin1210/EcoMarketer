//
//  UserStatsModels.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/13/24.
//

import Foundation

struct LevelInfoResponse: Codable {
    let data: LevelInfo
}

struct LevelInfo: Codable {
    let levelExperience: Int
    let myLevelExperience: Int
    let myLevel: Int
}

struct TradeCountResponse: Codable {
    let data: TradeCountData
}

struct TradeCountData: Codable {
    let count: Int
}

struct UserNameResponse: Codable {
    let data: UserNameData
}

struct UserNameData: Codable {
    let nickname: String
}
