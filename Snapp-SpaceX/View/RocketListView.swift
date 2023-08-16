//
//  RocketListView.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/10/23.
//

import SwiftUI

struct RocketListView: View {
    //MARK: - PROPERTIES
    @StateObject var vm = RocketViewModel()
    @State var isLoading = false
    @State var errorMessage : String?
    @State var showSkeleton: Bool = false
  
    
    //MARK: - VIEWS
    
    var skeletonLoder : some View{
        ZStack{
            HStack{
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 80, height: 80)
                    .padding(16)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8){
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.09))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                        
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.09))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.09))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.09))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                    
                }
                .padding(.horizontal , 16)
                
            }
            HStack{
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 80, height: 80)
                    .padding(16)
                
                
                
                VStack(alignment: .trailing, spacing: 8){
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.6))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.6))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.6))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.6))
                        .frame( height: 10)
                        .frame(maxWidth: .infinity)
                        
                    
                }
                .padding(.horizontal , 16)
                
            }
            .mask(
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .rotationEffect(.init(degrees: 70))
                .offset(x: showSkeleton ? 1000 : -350)
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 12).foregroundColor(Color("cellBackground"))
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
                showSkeleton.toggle()
            }
            loadMore()
        }
    }
    
    var retryButton: some View{
        Button {
            loadMore()
        } label: {
            HStack{
                Spacer()
                VStack{
                    Text(errorMessage ?? "")
                        .bold()
                        .foregroundColor(.red)
                        .opacity(0.8)
                        
                    Spacer()
                    Text("Tap for Retry")
                        .bold()
                        .foregroundColor(.red)
                        .opacity(0.8)
                       
                        
                }
                .padding()
                Spacer()
            }
            .frame(height: 150)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("lightColor"))
                       
            )
        }
    }
    
    //MARK: - BODY VIEW
    var body: some View {
        ScrollView(.vertical) {
            Spacer().frame(height: 16)
            LazyVStack(spacing: 16){
                ForEach(vm.rocketListItems) { item in
                    RocketItemView(rocketInfo: item)
                      
                }
                // skeleton view
                if vm.hasNexPage && errorMessage == nil{
                    skeletonLoder
                }
                if errorMessage != nil{
                    retryButton
                }
            }//VSTACK
        }//SCROLLVIEW
    }
    
    //MARK: - FUNCTIONS
    func loadMore(){
       
        Task{
            isLoading = true
            errorMessage = nil
            do{
                try await vm.loadMore()
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
            isLoading = false
        }
    }
}
//MARK: - PREVIEW
struct RocketListView_Previews: PreviewProvider {
    static var previews: some View {
        RocketListView()
    }
}
