//
//  WriteViewModel.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/16/24.
//

import Foundation
import Alamofire
import UIKit

enum WriteViewModelError: Error {
    case invalidURL
    case compressionFailed
    case networkError(Error)
}

class WriteViewModel: ObservableObject {
    @Published var introduceText: String = ""
    @Published var serverPrice: String = ""
    @Published var isLoading = false
    @Published var error: WriteViewModelError?
    
    private let session: Session
    private let baseURL: String
    
    init(session: Session = Session(interceptor: AuthInterceptor()), baseURL: String? = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String) {
        self.session = session
        self.baseURL = baseURL ?? ""
    }
    
    func compressImage(_ image: UIImage, targetSizeInMB: Int = 20) async throws -> UIImage {
        let maxSizeInBytes = targetSizeInMB * 1024 * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            throw WriteViewModelError.compressionFailed
        }
        
        while imageData.count > maxSizeInBytes && compression > step {
            compression -= step
            if let data = image.jpegData(compressionQuality: compression) {
                imageData = data
            }
        }
        
        if imageData.count > maxSizeInBytes {
            // 이미지 크기 조정
            let scale = sqrt(Double(maxSizeInBytes) / Double(imageData.count))
            let newSize = CGSize(width: image.size.width * CGFloat(scale), height: image.size.height * CGFloat(scale))
            UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let resizedImage = resizedImage, let resizedData = resizedImage.jpegData(compressionQuality: compression), resizedData.count <= maxSizeInBytes {
                return resizedImage
            }
        }
        
        if let compressedImage = UIImage(data: imageData), imageData.count <= maxSizeInBytes {
            return compressedImage
        }
        
        throw WriteViewModelError.compressionFailed
    }
    @MainActor
    func generateIntroduceText(image: UIImage, introduceCategory: String, price: String, product: String, productCategory: String) async throws {
        guard let url = URL(string: baseURL + "/introduce/text") else {
            throw WriteViewModelError.invalidURL
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let compressedImage = try await compressImage(image)
            let response: IntroduceResponse = try await withCheckedThrowingContinuation { continuation in
                session.upload(multipartFormData: { multipartFormData in
                    if let imageData = compressedImage.jpegData(compressionQuality: 0.5) {
                        print("Final image size being sent: \(imageData.count) bytes")
                        multipartFormData.append(imageData, withName: "files", fileName: "image.jpg", mimeType: "image/jpeg")
                    } else {
                        print("Failed to get JPEG data from compressed image")
                    }
                    multipartFormData.append(Data(introduceCategory.utf8), withName: "introduceCategory")
                    multipartFormData.append(Data(price.utf8), withName: "price")
                    multipartFormData.append(Data(product.utf8), withName: "product")
                    multipartFormData.append(Data(productCategory.utf8), withName: "productCategory")
                }, to: url, method: .post)
                .validate()
                .responseDecodable(of: IntroduceResponse.self) { response in
                    switch response.result {
                    case .success(let introduceResponse):
                        print("Successfully generated introduce text")
                        continuation.resume(returning: introduceResponse)
                    case .failure(let error):
                        print("Failed to generate introduce text: \(error.localizedDescription)")
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print("Server response: \(responseString)")
                        }
                        continuation.resume(throwing: WriteViewModelError.networkError(error))
                    }
                }
            }
            
            introduceText = response.data.introduceText
            serverPrice = response.data.price
            print("Received introduce text: \(introduceText)")
            print("Received server price: \(serverPrice)")
        } catch {
            print("Error in generateIntroduceText: \(error)")
            self.error = error as? WriteViewModelError ?? .networkError(error)
            throw error
        }
    }
    
    @MainActor
    func registerProduct(image: UIImage, introduceCategory: String, productCategory: String, price: String, product: String, introduceText: String, companys: [String]) async throws {
        guard let url = URL(string: baseURL + "/product") else {
            throw WriteViewModelError.invalidURL
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let compressedImage = try await compressImage(image)
            let response: ProductRegistrationResponse = try await withCheckedThrowingContinuation { continuation in
                session.upload(multipartFormData: { multipartFormData in
                    if let imageData = compressedImage.jpegData(compressionQuality: 0.5) {
                        print("Final image size being sent for product registration: \(imageData.count) bytes")
                        multipartFormData.append(imageData, withName: "files", fileName: "image.jpg", mimeType: "image/jpeg")
                    } else {
                        print("Failed to get JPEG data from compressed image for product registration")
                    }
                    multipartFormData.append(Data(introduceCategory.utf8), withName: "introduceCategory")
                    multipartFormData.append(Data(productCategory.utf8), withName: "productCategory")
                    multipartFormData.append(Data(price.utf8), withName: "price")
                    multipartFormData.append(Data(product.utf8), withName: "product")
                    multipartFormData.append(Data(introduceText.utf8), withName: "introduceText")
                    
                    for company in companys {
                        multipartFormData.append(Data(company.utf8), withName: "companys[]")
                    }
                }, to: url, method: .post)
                .validate()
                .responseDecodable(of: ProductRegistrationResponse.self) { response in
                    switch response.result {
                    case .success(let productResponse):
                        print("Successfully registered product")
                        continuation.resume(returning: productResponse)
                    case .failure(let error):
                        print("Failed to register product: \(error.localizedDescription)")
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print("Server response: \(responseString)")
                        }
                        continuation.resume(throwing: WriteViewModelError.networkError(error))
                    }
                }
            }
            
            print("Product registration success: \(response)")
        } catch {
            print("Error in registerProduct: \(error)")
            self.error = error as? WriteViewModelError ?? .networkError(error)
            throw error
        }
    }
}
