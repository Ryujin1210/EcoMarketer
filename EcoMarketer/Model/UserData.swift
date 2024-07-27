//
//  UserData.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import Foundation

struct UserData: Codable {
    let data: DataContainer
}

struct DataContainer: Codable {
    let accessToken: String
    let refreshToken: String
    let role: String
}
