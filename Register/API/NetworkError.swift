//
//  NetworkError.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation

 enum NetworkError: LocalizedError {
  case invalidServerResponse
  case invalidURL
     
     var errorDescription: String? {
    switch self {
    case .invalidServerResponse:
      return "The server returned an invalid response."
    case .invalidURL:
      return "URL string is malformed."
    }
  }
}
