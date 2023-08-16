//
//  RocketViewModel.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/14/23.
//

import SwiftUI
import Combine
@MainActor
class RocketViewModel: ObservableObject{
    @Published var rocketListItems: [RocketInfo] = []
    var lastDataResived : [RocketInfo] = []
    var hasNexPage : Bool = true
    var nextPage = 1
    
    
    func loadMore() async throws{
        if lastDataResived.isEmpty {
            try await getRocketsFromServer()
        }
        if lastDataResived.count > 19 {
            rocketListItems.append(contentsOf: lastDataResived[...19])
            lastDataResived.removeSubrange(...19)
        }else{
            rocketListItems.append(contentsOf: lastDataResived)
            lastDataResived.removeAll()
        }
    }
    
    func getRocketsFromServer() async throws {
        let response : GetRocketFromServerResponse = try await Network.shared.callRequest(from: GetRocketFromServerRequest(page: nextPage))
        guard let rockets = response.docs else {
            throw NetworkError.emptyResponse
        }
        
        lastDataResived = rockets
        hasNexPage = response.hasNextPage ?? false
        nextPage = response.nextPage ?? nextPage + 1
    }
    
    
}
