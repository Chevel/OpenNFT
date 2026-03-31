//
//  NFTPort.swift
//  LootBox
//
//  Created by Matej on 01/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

final class NFTPortService {

    private let session: URLSession
        
    // MARK: - Init
    
    init(session: URLSession) {
        self.session = session
    }
}

// MARK: - API

extension NFTPortService {
    
    func easyMint(metadata: NFTPortService.RequestData.EasyMint.NftMetadata) async throws -> NFTPortService.RequestData.EasyMint.Response {
        guard let request = Self.buildRequest(for: .easyMint(metadata)) else {
            throw AppError.parse
        }
        return try await perform(request: request)
    }
}

// MARK: - Request helper

private extension NFTPortService {

    func perform<T: Decodable>(request: URLRequest) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                guard let jsonData = data else {
                    continuation.resume(throwing: NFTPortService.Error.noData)
                    return
                }
                
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    do {
                        let response = try JSONDecoder().decode(T.self, from: jsonData)
                        continuation.resume(returning: response)
                    } catch {
                        continuation.resume(throwing: NFTPortService.Error.noData)
                    }
                }
            }.resume()
        }
    }

    static func buildRequest(for endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nftport.xyz"
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            CustomLogger.log(type: .network, message: "Failed to create URL request in \(#file) at \(#line) for \(endpoint)", error: AppError.parse)
            return nil
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers
        Self.applyBody(to: &request, for: endpoint)
        
        return request
    }

    // MARK: - Helper

    private static func applyBody(to request: inout URLRequest, for endpoint: Endpoint) {
        switch endpoint {
        case .easyMint(let data):
            guard let fileData = try? Data(contentsOf: data.localFileURL) else {
                return
            }

            let boundary = UUID().uuidString
            
            let contentType = "multipart/form-data; boundary=\(boundary)"
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            var body = Data()

            // Image boundary
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            // Image
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(data.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
            
            // End boundary
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body
        }
    }
}
