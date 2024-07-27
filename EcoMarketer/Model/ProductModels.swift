//
//  ProductModels.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/15/24.
//

import Foundation

struct ProductResponse: Codable {
    let data: [Product]
}

struct Product: Codable, Identifiable {
    let productId: Int
    let product: String
    let productCategory: String
    let imageUrl: String
    let createdAt: String
    let company: [String]
    let price: Int
    var status: ProductStatus?
    
    var id: Int { productId }
}

enum ProductStatus: String, Codable {
    case selling = ""
    case soldOut = "true"
    case failed = "false"
    
    var boolValue: Bool? {
        switch self {
        case .selling: return nil
        case .soldOut: return true
        case .failed: return false
        }
    }
}

struct ProductRegistrationResponse: Codable {
    let code: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}
