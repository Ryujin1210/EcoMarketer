////
////  LoginViewModel.swift
////  EcoMarketer
////
////  Created by YU WONGEUN on 7/10/24.
////
//
//import Foundation
//import KakaoSDKAuth
//import KakaoSDKUser
//import Alamofire
//
//class KakaoLoginViewModel: ObservableObject {
//    @Published var isLoggedIn: Bool = false
//    @Published var user: User?
//    @Published var userData: UserData?
//    
//    private let userDefaults = UserDefaults.standard
//    private let userDefaultsKey = "userData"
//    
//    init() {
//        loadUserDataFromUserDefaults()
//    }
//    
//    
//    // MARK: - 카카오 로그인 관련 로직
//    
//    // 카카오 로그인
//    func loginWithKakao() {
//        // 앱 사용 가능 시 앱 로그인
//        if UserApi.isKakaoTalkLoginAvailable() {
//            loginWithKakaoTalk()
//        } else {
//            // 앱 사용 불가 시 계정 로그인
//            loginWithKakaoAccount()
//        }
//    }
//    
//    private func loginWithKakaoTalk() {
//        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//            if let error = error {
//                print("카카오톡으로 로그인 실패: \(error)")
//            } else {
//                self.loginToOurServer(with: oauthToken?.accessToken)
//            }
//        }
//    }
//    
//    private func loginWithKakaoAccount() {
//        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
//            if let error = error {
//                print("카카오계정으로 로그인 실패: \(error)")
//            } else {
//                self.loginToOurServer(with: oauthToken?.accessToken)
//            }
//        }
//    }
//    
//    func fetchUserInfo() {
//        UserApi.shared.me {(user, error) in
//            if let error = error {
//                print("사용자 정보 요청 실패: \(error)")
//            } else if let user = user {
//                self.user = user
//                self.isLoggedIn = true
//            }
//        }
//    }
//    
//    func logout() {
//        UserApi.shared.logout { (error) in
//            if let error = error {
//                print("로그아웃 실패: \(error)")
//            } else {
//                self.isLoggedIn = false
//                self.user = nil
//                self.clearUserDataFromUserDefaults()
//            }
//        }
//    }
//    
//    // MARK: - 우리 서버로 로그인 연동
//    private func loginToOurServer(with accessToken: String?) {
//        guard let accessToken = accessToken else {
//            return
//        }
//        
//        let headers: HTTPHeaders = ["Authorization" : "\(accessToken)"]
//        let url = "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? "")/auth/login/kakao"
//        
//        AF.request(url, method: .post, headers: headers)
//            .responseDecodable(of: UserData.self) { response in
//                switch response.result {
//                case .success(let userData):
//                    self.userData = userData
//                    self.saveUserDataToUserDefaults()
//                    self.fetchUserInfo()
//                    print("자체 서버 로그인 성공 : \(response.result)")
//                case .failure(let error):
//                    print("DEBUG - 자체 서버 로그인 실패 : \(error)")
//                    print(url)
//                }
//            }
//    }
//    
//    // MARK: - userDefaults 관리 로직
//    private func loadUserDataFromUserDefaults() {
//        if let data = userDefaults.data(forKey: userDefaultsKey),
//           let userData = try? JSONDecoder().decode(UserData.self, from: data) {
//            self.userData = userData
//            self.isLoggedIn = (userData.data.accessToken.isEmpty == false)
//        }
//    }
//    
//    private func saveUserDataToUserDefaults() {
//        if let userData = self.userData,
//           let data = try? JSONEncoder().encode(userData) {
//            userDefaults.set(data, forKey: userDefaultsKey)
//            
//            // 저장된 데이터 확인
//            if let savedData = userDefaults.data(forKey: userDefaultsKey) {
//                do {
//                    let savedUserData = try JSONDecoder().decode(UserData.self, from: savedData)
//                    print("Saved user data: \(savedUserData)")
//                } catch {
//                    print("Error decoding saved user data: \(error)")
//                }
//            } else {
//                print("No saved user data found in UserDefaults")
//            }
//        }
//    }
//    
//    private func clearUserDataFromUserDefaults() {
//        userDefaults.removeObject(forKey: userDefaultsKey)
//    }
//    
//}
//
