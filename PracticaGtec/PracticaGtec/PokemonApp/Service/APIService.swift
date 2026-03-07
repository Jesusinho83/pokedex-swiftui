//
//  APIService.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

enum NetworkError: LocalizedError  {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingError
    case unknown

    var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "La URL no es válida."
            case .invalidResponse:
                return "La respuesta del servidor no es válida."
            case .badStatusCode(let code):
                return "El servidor respondió con código \(code)."
            case .decodingError:
                return "No se pudo procesar la información."
            case .unknown:
                return "Ocurrió un error inesperado."
            }
        }
}


protocol APIServiceProtocol {
    func fetch<T: Decodable>(urlString: String) async throws -> T
}

final class APIService: APIServiceProtocol {
    
    func fetch<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw  NetworkError.unknown
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
                
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error:", error)
            throw NetworkError.decodingError
        }
    }
}
