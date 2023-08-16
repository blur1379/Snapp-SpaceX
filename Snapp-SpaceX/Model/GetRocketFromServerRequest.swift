import Foundation


struct GetRocketFromServerRequest : APIRequest{
    var endPoint: String  = APIs.LunchesQuery.rawValue
    
    var method: APIMetods = .Post
    
    var parametr: [String : Any]
    
    init(page: Int) {
        self.parametr = ["query":["upcoming": false],
                         "options":[ "limit" : 50,
                                   "page": page,
                                   "sort":["flight_number": "desc"]] as [String : Any]]
    }
    
}
