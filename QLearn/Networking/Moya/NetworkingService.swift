//
//  NetworkingService.swift
//  QLearn
//
//  Created by Eyad Shokry on 11/20/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Moya

class NetworkingService {
    
    private init() {}
    
    static let shared = NetworkingService()
    
    static private let publicKey = ""
    static private let privateKey = ""

    
    let provider = MoyaProvider<QLearnAPI>(plugins: [CredentialsPlugin { _ -> URLCredential? in
        return URLCredential(user: publicKey, password: privateKey, persistence: .none)
        }
    ])
}
