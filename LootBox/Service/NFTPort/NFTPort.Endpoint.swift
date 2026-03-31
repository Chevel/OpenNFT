//
//  NFTPort.Endpoint.swift
//  LootBox
//
//  Created by Matej on 01/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension NFTPortService {
    
    enum Endpoint {

        case easyMint(NFTPortService.RequestData.EasyMint.NftMetadata)

        var path: String {
            switch self {
            case .easyMint: return "/v0/mints/easy/files"
            }
        }
        
        var method: String {
            switch self {
            case .easyMint: return "POST"
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .easyMint(let metadata):
                return [
                    URLQueryItem(name: "chain", value: "polygon"),
                    URLQueryItem(name: "name", value: metadata.nftName),
                    URLQueryItem(name: "description", value: metadata.nftDescription),
                    URLQueryItem(name: "mint_to_address", value: metadata.walletAddress)
                ]
            }
        }
        
        var headers: [String: String] {
            switch self {
            case .easyMint:
                return [
                    "Authorization": AppSettings.Constants.Mintky
                  ]
            }
        }
    }
}
