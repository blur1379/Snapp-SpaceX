//
//  RocketDetailView.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/10/23.
//

import SwiftUI

struct RocketDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var image : UIImage?
    @State var errorMessage : String?
    @Binding var isBookMarked: Bool
    let rocketInfo :RocketInfo
    let dateFormatter : DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
  
    
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    Button {
                        isBookMarked.toggle()
                        if isBookMarked{
                            AppStorage.shared.addItemToBookMarks(id: rocketInfo.id)
                        }else{
                            AppStorage.shared.removeItemFromBookMarks(id: rocketInfo.id)
                        }
                       
                    } label: {
                        Image(systemName: "bookmark.square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(isBookMarked ? .green: .red)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text(rocketInfo.name)
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.7))
                        .bold()
                        .lineLimit(1)
                        .padding(.horizontal)
                        .padding(.vertical,4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color("lightColor"))
                        )
                       
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.secondary)
                            .padding(5)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("lightColor"))
                            )
                            .padding()
                    }
                }
                .padding(.bottom)
                
                VStack{
                    if let uiimage = image {
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
//                            .frame(height: 300)
                    }else{
                        LottieView(lottieFile: "animation_llcmhd2t")
                    }
                }
                .frame(height: 300)
                .task {
                    guard let path = rocketInfo.links?.flickr?.original, path.count > 0  else {
                        errorMessage = "nill path"
                     return
                    }
                    await loadImage(path: path[0])
                }
              
                Text("\(rocketInfo.dateUnix.unixToDate() , formatter: dateFormatter)")
                    .padding(.horizontal)
                    .padding(.vertical,6)
                    .foregroundColor(.primary)
                    .opacity(0.6)
                    .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("lightColor"))
                    )
                
                Text("full name is \(rocketInfo.name)")
                    .padding(.horizontal)
                    .padding(.vertical,6)
                
                if let detail = rocketInfo.details{
                    VStack(alignment: .leading){
                        HStack{
                       
                           Text("Description:")
                                .font(.headline)
                            
                            Spacer()
                        }
                        
                        Text(detail)
                            .padding(4)
                        
                    }
                    .padding(.horizontal)
                }
               
                
                if let wiki = rocketInfo.links?.wikipedia{
                    Button {
                        if let url = URL(string: wiki) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("See In Wikipedia")
                            .foregroundColor(.primary.opacity(0.7))
                            .padding(4)
                            .padding(.horizontal)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("cellBackground"))
                            )
                    }
                    .padding()

                }
                
                Spacer()
            }
        }
        
    }
    
    
    func loadImage(path: String) async{
        errorMessage = nil
        do{
            image = try await Network.shared.downloadAndCacheImage(from: path)
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
    }
}

struct RocketDetailView_Previews: PreviewProvider {
    @State static var isBooked: Bool = false
    static var previews: some View {
        RocketDetailView(isBookMarked: $isBooked, rocketInfo: RocketInfo(links: Links(wikipedia: "www.google.com", patch: nil, flickr: Flickr(original: ["https://live.staticflickr.com/65535/51474853666_be4615e186_o.jpg"])), success: true, details: "this is new shotel", flightNumber: 129, name: "mam", dateUnix: 87387663, id: "ooooo"))
    }
}
