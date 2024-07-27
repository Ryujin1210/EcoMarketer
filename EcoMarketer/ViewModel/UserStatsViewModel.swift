//
//  UserStatsViewModel.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/13/24.
//

import Foundation
import Alamofire

class UserStatsViewModel: ObservableObject {
    @Published var levelInfo: LevelInfo?
    @Published var tradeCount: Int = 0
    @Published var userName: String = "username"
    
    private let session: Session
    
    init() {
        let interceptor = AuthInterceptor()
        self.session = Session(interceptor: interceptor)
    }
    
    func fetchUserName() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            print("기본 URL이 없습니다.")
            return
        }
        
        let url = baseURL + "/user/nickname"
        
        session.request(url, method: .get)
            .validate()
            .responseDecodable(of: UserNameResponse.self) { [weak self] response in
                switch response.result {
                case .success(let userNameResponse):
                    DispatchQueue.main.async {
                        self?.userName = userNameResponse.data.nickname
                    }
                    print("사용자 이름 가져오기 성공: \(userNameResponse.data.nickname)")
                case .failure(let error):
                    print("사용자 이름 가져오기 실패: \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Received data: \(str)")
                    }
                }
            }
    }
    
    func fetchLevelInformation() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            print("기본 URL이 없습니다.")
            return
        }
        
        let url = baseURL + "/level/information"
        
        session.request(url, method: .get)
            .validate()
            .responseDecodable(of: LevelInfoResponse.self) { [weak self] response in
                switch response.result {
                case .success(let levelInfoResponse):
                    DispatchQueue.main.async {
                        self?.levelInfo = levelInfoResponse.data
                    }
                    print("레벨 정보 가져오기 성공: \(levelInfoResponse.data)")
                case .failure(let error):
                    print("레벨 정보 가져오기 실패: \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Received data: \(str)")
                    }
                }
            }
    }
    
    func fetchTradeCount() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            print("기본 URL이 없습니다.")
            return
        }
        
        let url = baseURL + "/level/secondhand-trade/count"
        
        session.request(url, method: .get)
            .validate()
            .responseDecodable(of: TradeCountResponse.self) { [weak self] response in
                switch response.result {
                case .success(let tradeCountResponse):
                    DispatchQueue.main.async {
                        self?.tradeCount = tradeCountResponse.data.count
                    }
                    print("거래 횟수 가져오기 성공: \(tradeCountResponse.data.count)")
                case .failure(let error):
                    print("거래 횟수 가져오기 실패: \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Received data: \(str)")
                    }
                }
            }
    }
    
    func fetchAllData() {
        fetchLevelInformation()
        fetchTradeCount()
        fetchUserName()
    }
    
    func calculateProgress() -> Float {
        guard let info = levelInfo else { return 0 }
        return Float(info.myLevelExperience) / Float(info.levelExperience)
    }
}
