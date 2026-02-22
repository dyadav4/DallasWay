//
//  ExplorerAPIService.swift
//  DallasWay
//
//  Created by Dharamvir Yadav on 12/2/24.
//

import Foundation

class ExplorerAPIService {
    private let apiKey = "fsq3bxt+vATf/fyPqkFkMKiryHVlS6+YDwX2bU9lkdydleE="

    /// Fetches a list of places based on the search query
    func fetchPlaces(completion: @escaping (Result<PlacesResponse?, Error>) -> Void) {
        let urlString = "https://api.foursquare.com/v3/places/search?near=Dallas,TX&categories=16000&sort=POPULARITY&limit=50"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let results = try JSONDecoder().decode(PlacesResponse.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Fetches a list of images based on the search query
    func fetchPlaceImages(placeid: String, completion: @escaping (Result<PlaceImages?, Error>) -> Void) {
        let urlString = "https://api.foursquare.com/v3/places/\(placeid)/photos"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let results = try JSONDecoder().decode(PlaceImages.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Fetches a list of images based on the search query
    func fetchPlaceTips(placeid: String, completion: @escaping (Result<PlaceTips?, Error>) -> Void) {
        let urlString = "https://api.foursquare.com/v3/places/\(placeid)/tips"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let results = try JSONDecoder().decode(PlaceTips.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
}
