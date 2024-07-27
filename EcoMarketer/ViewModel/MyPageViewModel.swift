//
//  MyPageViewModel.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/15/24.
//

import Foundation
import Alamofire

class MyPageViewModel: ObservableObject {
    @Published var sellingProducts: [Product] = []
    @Published var soldOutProducts: [Product] = []
    @Published var failedProducts: [Product] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let session: Session
    
    init() {
        let interceptor = AuthInterceptor()
        self.session = Session(interceptor: interceptor)
    }
    
    // 목록 불러오기
    func fetchProducts(for status: ProductStatus?) {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            print("기본 URL이 없습니다.")
            return
        }
        
        var urlString = baseURL + "/product"
        if let status = status {
            urlString += "?status=\(status.rawValue)"
        }
        
        guard let url = URL(string: urlString) else {
            print("잘못된 URL입니다.")
            return
        }
        
        isLoading = true
        
        
        session.request(url, method: .get)
            .validate()
            .responseDecodable(of: ProductResponse.self) { [weak self] response in
                self?.isLoading = false
                switch response.result {
                case .success(let productResponse):
                    DispatchQueue.main.async {
                        switch status {
                        case .selling:
                            self?.sellingProducts = productResponse.data
                        case .soldOut:
                            self?.soldOutProducts = productResponse.data
                        case .failed:
                            self?.failedProducts = productResponse.data
                        case .none:
                            self?.sellingProducts = productResponse.data
                        }
                    }
                    print("제품 목록 가져오기 성공: \(productResponse.data.count) 개의 제품")
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.error = error
                    }
                    print("제품 목록 가져오기 실패: \(error)")
                }
            }
    }
    
    // 상태 변화
    func patchStatus(productId: Int, status: ProductStatus) {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            print("기본 URL이 없습니다.")
            return
        }
        
        let url = baseURL + "/product/status"
        let parameters: [String: Any] = [
            "productId": productId,
            "status": status.boolValue as Any
        ]
        
        session.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success:
                    print("제품 상태 업데이트 성공")
                    // 필요한 경우 상태 업데이트 후 목록을 다시 불러옵니다.
                    self?.fetchAllProducts()
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.error = error
                    }
                    print("제품 상태 업데이트 실패: \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Received data: \(str)")
                    }
                }
            }
    }
    
    
    func fetchAllProducts() {
        fetchProducts(for: .selling)
        fetchProducts(for: .soldOut)
        fetchProducts(for: .failed)
    }
}
