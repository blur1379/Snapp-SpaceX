import Foundation

// MARK: - Welcome
struct GetRocketFromServerResponse :Codable {
    let docs: [RocketInfo]?
    let totalDocs, limit, totalPages, page: Int?
    let pagingCounter: Int?
    let hasPrevPage, hasNextPage: Bool?
    let prevPage, nextPage: Int?
}

// MARK: - Doc
struct RocketInfo :Codable,Identifiable{
    let links: Links?
    let success: Bool?
    let details: String?
    let flightNumber: Int
    let name: String
    let dateUnix: Int
    let id: String
}

// MARK: - Core
struct Core:Codable {
    let core: String?
    let flight: Int?
    let gridfins, legs, reused, landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType, landpad: String?
}


// MARK: - Links
struct Links :Codable{
    let wikipedia: String?
    let patch : Patch?
    let flickr: Flickr?
}

// MARK: - Fliker
struct Flickr : Codable {
    let original : [String]?
}

// MARK: - Patch
struct Patch :Codable{
    let small: String?
}

