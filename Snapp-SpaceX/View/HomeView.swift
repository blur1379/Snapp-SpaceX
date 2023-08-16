//
//  HomeView.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/9/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack (spacing: 0){
            HStack{
                Text("Snapp Space-X")
                    .foregroundColor(.primary.opacity(0.6))
                    .padding(8)
                    .bold()
                Spacer()
            }
            .background(Color.primary.opacity(0.2))
            RocketListView()
                .padding(.horizontal)
        }
   
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
