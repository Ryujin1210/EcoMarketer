//
//  LoginViewModel.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import Alamofire

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User?
    @Published var userData: UserData?
    
    private let session: Session
    
    init() {
        let interceptor = AuthInterceptor()
        self.session = Session(interceptor: interceptor)
        loadUserData()
    }
    
    private func loadUserData() {
        if let userData = TokenManager.shared.loadToken() {
            self.userData = userData
            self.isLoggedIn = true
        }
    }
    
    // MARK: - 카카오 로그인 관련 로직
    
    func loginWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk()
        } else {
            loginWithKakaoAccount()
        }
    }
    
    private func loginWithKakaoTalk() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print("카카오톡으로 로그인 실패: \(error)")
            } else {
                self.loginToOurServer(with: oauthToken?.accessToken)
            }
        }
    }
    
    private func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print("카카오계정으로 로그인 실패: \(error)")
            } else {
                self.loginToOurServer(with: oauthToken?.accessToken)
            }
        }
    }
    
    func fetchUserInfo() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print("사용자 정보 요청 실패: \(error)")
            } else if let user = user {
                self.user = user
                self.isLoggedIn = true
            }
        }
    }
    
    func logout() {
        UserApi.shared.logout { (error) in
            if let error = error {
                print("로그아웃 실패: \(error)")
            } else {
                self.logoutFromOurServer()
            }
        }
    }
    
    // MARK: - 우리 서버로 로그인 연동
    private func loginToOurServer(with accessToken: String?) {
        guard let accessToken = accessToken else { return }
        
        let headers: HTTPHeaders = ["Authorization": "\(accessToken)"]
        let url = "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? "")/auth/login/kakao"
                        
        AF.request(url, method: .post, headers: headers)
            .responseDecodable(of: UserData.self) { response in
                switch response.result {
                case .success(let userData):
                    self.userData = userData
                    TokenManager.shared.saveToken(userData)
                    print("자채 서버 토큰 : \n \(userData)")
                    self.fetchUserInfo()
                    self.isLoggedIn = true
                    print("자체 서버 로그인 성공")
                case .failure(let error):
                    print("자체 서버 로그인 실패: \(error)")
                }
            }
    }
        
    func logoutFromOurServer() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            print("로그아웃 실패: 기본 URL이 없습니다.")
            return
        }
        
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("로그아웃 실패: Access Token이 없습니다.")
            return
        }
        print("Using Access Token for logout: \(accessToken)")


        let url = baseURL + "/auth/logout"
                
        session.request(url, method: .delete)
            .response { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, 200...299 ~= statusCode {
                        print("서버 로그아웃 성공")
                        self.clearUserData()
                    } else {
                        self.clearUserData()
                        print("서버 로그아웃 실패: 잘못된 상태 코드: \(String(describing: response.response?.statusCode))")
                        if let data = response.data, let str = String(data: data, encoding: .utf8) {
                            print("Received data: \(str)")
                        }
                    }
                case .failure(let error):
                    print("서버 로그아웃 실패: \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Received data: \(str)")
                    }
                }
            }
    }


    private func clearUserData() {
        TokenManager.shared.clearToken()
        self.isLoggedIn = false
        self.user = nil
        self.userData = nil
        print("로컬 사용자 데이터와 토큰이 삭제되었습니다.")
    }
}
