//
//  Networking.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import Foundation

class NetworkManager {
    
    public static let shared = NetworkManager()
    
    public init() {}
    
    public func fetch<T: Codable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            print("HERE")
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("HERE1")
            throw URLError(.badServerResponse)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("HEREx")
            throw URLError(.unknown)
        }
    }
}
