//
//  AuthInterceptor.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import Alamofire
import Foundation

class AuthInterceptor: RequestInterceptor {
    private let retryLimit = 1
    private var retryCount = 0
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = TokenManager.shared.getAccessToken() {
            urlRequest.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")
            print("Interceptor adding header: \(accessToken)")

        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        guard retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        
        refreshToken { success in
            if success {
                self.retryCount += 1
                completion(.retry)
            } else {
                completion(.doNotRetry)
            }
        }
    }
    
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            completion(false)
            return
        }
        
        let url = "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? "")/auth/refresh"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(refreshToken)"]
        
        AF.request(url, method: .post, headers: headers)
            .responseDecodable(of: UserData.self) { response in
                switch response.result {
                case .success(let newUserData):
                    TokenManager.shared.saveToken(newUserData)
                    print("Token refreshed successfully")
                    completion(true)
                case .failure(let error):
                    print("Token refresh failed: \(error)")
                    completion(false)
                }
            }
    }
}
