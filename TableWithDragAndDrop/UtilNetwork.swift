//
//  UtilNetwork.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//  based on https://gist.github.com/stinger/e8b706ab846a098783d68e5c3a4f0ea5

import Foundation
import Combine

func fetch(url: URL) -> AnyPublisher<Data, FetchOrParseError> {
    let request = URLRequest(url: url)

    return URLSession.DataTaskPublisher(request: request, session: .shared)
        .tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw FetchOrParseError.unknown
            }
            return data
        }
        .mapError { error in
            if let error = error as? FetchOrParseError {
                return error
            } else {
                return FetchOrParseError.fetchError(reason: error.localizedDescription)
            }
        }
        .eraseToAnyPublisher()
}

func decodeJSON<T: Decodable>(url: URL) -> AnyPublisher<T, FetchOrParseError> {
    fetch(url: url)
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError { error in
            if let error = error as? DecodingError, let errorMessage = error.errorDescription {
                return FetchOrParseError.jsonParseError(reason: errorMessage)
            }  else {
                return FetchOrParseError.fetchError(reason: error.localizedDescription)
            }
        }
        .eraseToAnyPublisher()
}

enum FetchOrParseError: Error, LocalizedError {
    case unknown
    case fetchError(reason: String)
    case jsonParseError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "unknown error"
        case .fetchError(let reason):
            return "fetch error \(reason)"
        case .jsonParseError(let reason):
            return "json parse error \(reason)"
        }
    }
}


