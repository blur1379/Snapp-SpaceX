//
//  RocketItemView.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/10/23.
//

import SwiftUI

struct RocketItemView: View {
    //MARK: -PEROPERTIES
    @State var logo : UIImage?
    @State var errorMessage: String?
    @State var IsloadingImage: Bool = false
    @State var isShowDetail: Bool = false
    @State var isBooked: Bool = false
    let rocketInfo: RocketInfo
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    // MARK: - BODY
    var body: some View {
        HStack{
            ZStack{
                if logo != nil{
                    Image(uiImage: logo!)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .scaledToFill()
                }
                if IsloadingImage {
                    ProgressView("Loading")
                        .frame(width: 80, height: 80)
                    
                }
                if errorMessage != nil{
                    Image(systemName: "repeat.circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .scaledToFill()
                }
            }.padding(16)
            .animation(.easeOut(duration: 2), value: IsloadingImage)
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4){
                HStack(alignment: .center){
                    if isBooked {
                        Image(systemName: "bookmark.square.fill")
                            .foregroundColor(.gray)
                    }
                    
                    Text(String(rocketInfo.flightNumber))
                        .font(.headline)
                        .frame(width: 40, height: 24)
                        .opacity(0.4)
                    
                }
                .padding(.horizontal, 12)
                .padding(.top,12)
               
                
                Text(String(rocketInfo.name))
                    .bold()
                    .font(.headline)
                    .lineLimit(1)
                    .opacity(0.4)
                    .padding(.horizontal, 12)
                
                Text(rocketInfo.success ?? false ? "success" : "faild")
                    .font(.headline)
                    .frame(height: 24)
                    .padding(.horizontal,12)
                    .foregroundColor(rocketInfo.success ?? false ? .green : .red)
                
                Text("\(rocketInfo.dateUnix.unixToDate(),formatter: dateFormatter)")
                    .font(.headline)
                    .frame(height: 24)
                    .padding(.horizontal,12)
                
                Text(rocketInfo.details ?? "")
                    .font(.headline)
                    .frame(height: 24)
                    .opacity(0.6)
                    .padding([.horizontal,.bottom],12)
                    .lineLimit(1)
            }
            
        }
        
        .background(
            RoundedRectangle(cornerRadius: 12).foregroundColor(Color("cellBackground"))
        )
        .onTapGesture {
            isShowDetail = true
        }
        .sheet(isPresented: $isShowDetail) {
            RocketDetailView(isBookMarked: $isBooked, rocketInfo: rocketInfo)
        }
        .task{
            guard let path = rocketInfo.links?.patch?.small else {
                errorMessage = "nill path"
                return
            }
            if AppStorage.shared.isItemBookMarked(id: rocketInfo.id){
                isBooked = true
            }
            await loadImage(path: path)
        }
        
    }
    
    //MARK: - FUNCTION
    func loadImage(path: String) async{
        IsloadingImage = true
        errorMessage = nil
        do{
            logo = try await Network.shared.downloadAndCacheImage(from: path)
        }catch NetworkError.invalidURL{
            errorMessage = NetworkError.invalidResponse.rawValue
        }catch NetworkError.invalidParameter{
            errorMessage = NetworkError.invalidParameter.rawValue
        }catch NetworkError.invalidData{
            errorMessage = NetworkError.invalidData.rawValue
        }catch NetworkError.invalidResponse{
            errorMessage = NetworkError.invalidResponse.rawValue
        }catch NetworkError.emptyResponse{
            errorMessage = NetworkError.emptyResponse.rawValue
        }catch{
            errorMessage = error.localizedDescription
        }
        IsloadingImage = false
    }
}
