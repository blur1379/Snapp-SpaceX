import SwiftUI

// MARK: - Network
/// An actor that provides networking capabilities, including making API requests and downloading images.
actor Network {
    // Shared instance of the network for convenience.
    static var shared = Network()
    private init() {}
    
    /// Performs an asynchronous API request and decodes the response into a specified Codable type.
    ///
    /// - Parameters:
    ///   - request: The API request configuration.
    /// - Returns: The decoded result of the API request.
    /// - Throws: An error if the request fails or the response is invalid.
    func callRequest<T: Codable>(from request: APIRequest) async throws -> T {
        guard let url = URL(string: request.endPoint) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if request.method == .Post {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: request.parametr) else {
                throw NetworkError.invalidParameter
            }
            urlRequest.httpBody = jsonData
            urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    /// Downloads an image from a specified URL asynchronously.
    ///
    /// - Parameters:
    ///   - urlStr: The URL string of the image.
    /// - Returns: The downloaded image.
    /// - Throws: An error if the download fails or the response is invalid.
    func downloadImage(from urlStr: String) async throws -> UIImage {
        guard let url = URL(string: urlStr) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidData
        }
        return image
    }
    
    /// Downloads and caches an image from a specified URL asynchronously.
    ///
    /// - Parameters:
    ///   - urlStr: The URL string of the image.
    /// - Returns: The downloaded and cached image.
    /// - Throws: An error if the download fails, the response is invalid, or caching encounters issues.
    func downloadAndCacheImage(from urlStr: String) async throws -> UIImage {
        if let cacheImage = await CacheManager.shared.get(name: urlStr) {
            return cacheImage
        }
        
        let image = try await downloadImage(from: urlStr)
        await CacheManager.shared.add(image: image, name: urlStr)
        return image
    }
}
