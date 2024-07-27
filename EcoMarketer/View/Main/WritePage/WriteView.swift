//
//  WriteView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/15/24.
//

import SwiftUI

struct WriteView: View {
    @StateObject private var writeViewModel = WriteViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var showPlatformActionSheet = false
    @State private var showCategorySheet = false
    @State private var showConceptSheet = false
    @State private var showLoadingSheet = false
    @State private var showCopiedAlert = false
    @State private var scrollToGenerated = false
    @State private var showWritingLinkView = false
    
    @State private var writeTitle: String = ""
    @State private var priceString: String = ""
    @State private var platformString: String = ""
    @State private var productCategory: String = ""
    @State private var introduceCategory: String = ""
    
    @FocusState private var isPriceFieldFocused: Bool
    
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private var priceWithoutComma: String {
        return priceString.replacingOccurrences(of: ",", with: "")
    }
    
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Pretendard-Medium", size: 20)!]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            // 사진 가져오기 Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("사진 가져오기")
                                    .font(.pretendardMedium14)
                                HStack {
                                    Button(action: {
                                        showActionSheet = true
                                    }) {
                                        if let image = selectedImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 64, height: 64)
                                                .cornerRadius(6)
                                                .overlay(
                                                    Image(systemName: "arrow.triangle.2.circlepath")
                                                        .foregroundColor(.unselected_tab)
                                                        .background(Color.clear)
                                                    , alignment: .topTrailing
                                                )
                                        } else {
                                            Image(systemName: "camera.fill")
                                                .foregroundColor(Color.unselected_tab)
                                                .padding(.vertical, 20)
                                                .padding(.horizontal, 17.5)
                                                .background(Color.white)
                                                .cornerRadius(6)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(Color.box_border, lineWidth: 1)
                                                )
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            
                            // 제목 Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("제목")
                                    .font(.pretendardMedium14)
                                TextField("제품명", text: $writeTitle)
                                    .font(.pretendardMedium16)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.box_border, lineWidth: 1)
                                    )
                            }
                            
                            // 가격 Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("가격")
                                    .font(.pretendardMedium14)
                                TextField("가격 입력", text: $priceString)
                                    .font(.pretendardMedium16)
                                    .keyboardType(.numberPad)
                                    .focused($isPriceFieldFocused)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.box_border, lineWidth: 1)
                                    )
                                    .onChange(of: priceString) { newValue in
                                        let filtered = newValue.filter { $0.isNumber }
                                        if let number = Int(filtered) {
                                            priceString = numberFormatter.string(from: NSNumber(value: number)) ?? filtered
                                        } else {
                                            priceString = ""
                                        }
                                    }
                                    .onTapGesture {
                                        isPriceFieldFocused = true
                                    }
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            if isPriceFieldFocused {
                                                Spacer()
                                                Button("완료") {
                                                    isPriceFieldFocused = false
                                                }
                                            }
                                        }
                                    }
                                
                            }
                            // 플랫폼 선택 Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("플랫폼 선택")
                                    .font(.pretendardMedium14)
                                Button(action: {
                                    showPlatformActionSheet = true
                                }) {
                                    HStack {
                                        Text(platformString.isEmpty ? "플랫폼을 선택해주세요" : platformString)
                                            .font(.pretendardMedium16)
                                            .foregroundStyle(platformString.isEmpty ? Color(UIColor.placeholderGray) : colorForPlatform(platformString))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.unselected_tab)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.box_border, lineWidth: 1)
                                    )
                                }
                            }
                            
                            // 카테고리 Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("카테고리")
                                    .font(.pretendardMedium14)
                                Button(action: {
                                    showCategorySheet = true
                                }) {
                                    HStack {
                                        Text(productCategory.isEmpty ? "카테고리를 선택해주세요" : productCategory)
                                            .font(.pretendardMedium16)
                                            .foregroundStyle(productCategory.isEmpty ? Color(UIColor.placeholderGray) : .black)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.unselected_tab)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.box_border, lineWidth: 1)
                                    )
                                }
                            }
                            
                            // 판매컨셉 Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("판매 컨셉")
                                    .font(.pretendardMedium14)
                                Button(action: {
                                    showConceptSheet = true
                                }) {
                                    HStack {
                                        Text(introduceCategory.isEmpty ? "판매 컨셉을 선택해주세요" : introduceCategory)
                                            .font(.pretendardMedium16)
                                            .foregroundStyle(introduceCategory.isEmpty ? Color(UIColor.placeholderGray) : .black)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.unselected_tab)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.box_border, lineWidth: 1)
                                    )
                                }
                            }
                            
                            Spacer()
                            
                            // Ai 소개글 생성 후 표시
                            if !writeViewModel.introduceText.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top) {
                                        Text("생성된 글")
                                            .font(.pretendardBold14)
                                            .foregroundStyle(Color.main_Green)
                                        
                                        Spacer()
                                        
                                        Button {
                                            UIPasteboard.general.string = writeViewModel.introduceText
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showCopiedAlert = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    showCopiedAlert = false
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "doc.on.doc")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.black)
                                                .frame(width: 11, height: 14)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.unselected_tab, lineWidth: 1)
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(Color.unselected_tab)
                                                )
                                        }
                                    }
                                    
                                    Text(writeViewModel.introduceText)
                                        .font(.pretendardMedium16)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(6)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .background(Color.ai_bg)
                                        .overlay (
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.main_Green, lineWidth: 1)
                                        )
                                }
                                .id("generatedText") // 여기에 id 추가
                                
                            }
                            
                            
                            // 소개글 생성 버튼 또는 결과 버튼들
                            if writeViewModel.introduceText.isEmpty {
                                Button {
                                    showLoadingSheet = true
                                    Task {
                                        await generateIntroduceText()
                                    }
                                } label: {
                                    Text("💫 생성하기")
                                        .font(.pretendardSemiBold17)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color.main_Green)
                                        .cornerRadius(8)
                                        .multilineTextAlignment(.center)
                                }
                            } else {
                                HStack(spacing: 12) {
                                    Button {
                                        showLoadingSheet = true
                                        Task {
                                            await generateIntroduceText()
                                        }
                                    } label: {
                                        Text("🔄 다시 생성하기")
                                            .font(.pretendardSemiBold17)
                                            .foregroundStyle(Color.main_Green)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .multilineTextAlignment(.center)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.main_Green, lineWidth: 1)
                                            )
                                    }
                                    
                                    Button {
                                        Task {
                                            do {
                                                await registerProduct()
                                                await MainActor.run {
                                                    showWritingLinkView = true
                                                }
                                            }
                                        }
                                    } label: {
                                        Text("✏️ 글쓰러 가기")
                                            .font(.pretendardSemiBold17)
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .background(Color.main_Green)
                                            .cornerRadius(8)
                                            .multilineTextAlignment(.center)
                                    }                     
                                }
                            }
                            
                            
                            Spacer()
                            
                        }
                        .padding(16)
                        .padding(.top, 8)
                        .onChange(of: writeViewModel.introduceText) { _ in
                            if !writeViewModel.introduceText.isEmpty {
                                withAnimation {
                                    proxy.scrollTo("generatedText", anchor: .top)
                                }
                            }
                        }
                        .onChange(of: writeViewModel.serverPrice) { newPrice in
                            if let intPrice = Int(newPrice), intPrice != 0 {
                                priceString = numberFormatter.string(from: NSNumber(value: intPrice)) ?? ""
                            }
                        }
                        
                    }
                    .navigationBarItems(leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 18, height: 18)
                    })
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("게시글 생성하기")
                }
                // toast 메세시
                if showCopiedAlert {
                    VStack {
                        Spacer()
                        
                        ToastView()
                            .transition(.move(edge: .bottom))
                            .padding(.bottom, 100)
                            .zIndex(1)
                    }
                }
                
                if writeViewModel.isLoading  == true {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { } // 로딩 중 탭 무시
                    
                    LoadingView()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }
                
                if showWritingLinkView {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showWritingLinkView = false
                        }
                    
                    WritingLinkView()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                    
                }
            }
   
            
            .onChange(of: showCopiedAlert) { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showCopiedAlert = false
                        }
                    }
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("사진 선택"), buttons: [
                    .default(Text("카메라로 촬영")) {
                        self.sourceType = .camera
                        self.showImagePicker = true
                    },
                    .default(Text("앨범에서 선택")) {
                        self.sourceType = .photoLibrary
                        self.showImagePicker = true
                    },
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $showImagePicker) {
                ImagePicker(sourceType: sourceType, selectedImage: { image in
                    self.selectedImage = image
                })
                .ignoresSafeArea()
                .onDisappear {
                    isPriceFieldFocused = false
                }
            }
            .sheet(isPresented: $showPlatformActionSheet) {
                PlatformPickerView(selectedPlatform: $platformString)
                    .presentationDetents([.height(250)]) // 높이를 250으로 설정
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showCategorySheet) {
                CategoryPickerView(selectedCategory: $productCategory)
                    .presentationDetents([.height(630)]) // 높이를 250으로 설정
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showConceptSheet) {
                ConceptPickerView(selectedConcept: $introduceCategory)
                    .presentationDetents([.height(380)]) // 높이를 250으로 설정
                    .presentationDragIndicator(.visible)
            }
            
            
        }
        
    }
    // MARK: - functions
    private func colorForPlatform(_ platform: String) -> Color {
        switch platform {
        case "중고나라":
            return Color.main_Green
        case "당근":
            return Color.carrot_bg
        case "번개장터":
            return Color.thunder_bg
        default:
            return Color.black
        }
    }
    
    func generateIntroduceText() async {
        do {
            try await writeViewModel.generateIntroduceText(
                image: selectedImage ?? UIImage(),
                introduceCategory: introduceCategory,
                price: priceWithoutComma,
                product: writeTitle,
                productCategory: productCategory
            )
        } catch {
            print("Failed to generate introduce text: \(error)")
            // 에러 처리 (예: 알림 표시)
        }
    }
    
    func registerProduct() async {
        do {
            try await writeViewModel.registerProduct(
                image: selectedImage ?? UIImage(),
                introduceCategory: introduceCategory,
                productCategory: productCategory,
                price: priceWithoutComma,
                product: writeTitle,
                introduceText: writeViewModel.introduceText,
                companys: [platformString]
            )
        } catch {
            print("Failed to register product: \(error)")
            // 에러 처리 (예: 알림 표시)
        }
    }
    
}

#Preview {
    WriteView()
}
