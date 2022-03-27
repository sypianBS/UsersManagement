//
//  UtilNetwork.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//  based on https://gist.github.com/stinger/e8b706ab846a098783d68e5c3a4f0ea5

import Foundation
import Combine

func fetch(url: URL) -> AnyPublisher<Data, Error> {
    let request = URLRequest(url: url)

    return URLSession.DataTaskPublisher(request: request, session: .shared)
        .tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw FetchError.unknown
            }
            return data
        }
        .mapError { error in
            if let error = error as? FetchError {
                return error
            } else {
                return FetchError.fetchError(reason: error.localizedDescription)
            }
        }
        .eraseToAnyPublisher()
}

func decodeJSON<T: Decodable>(url: URL, localFileName: String?) -> AnyPublisher<T, Error> {
    
    if let localFileName = localFileName {
        return decodeJSON(url: url, locaFileName: localFileName)
    } else {
        return decodeJSON(url: url)
    }
}

private func decodeJSON<T: Decodable>(url: URL, locaFileName: String) -> AnyPublisher<T, Error> {
    fetch(url: url)
    //use a local file if an fetch error occured
        .replaceError(with: try! Data(contentsOf: Bundle.main.url(forResource: locaFileName, withExtension: "json")!))
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

private func decodeJSON<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
    fetch(url: url)
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

enum FetchError: Error, LocalizedError {
    case unknown
    case fetchError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "unknown error"
        case .fetchError(let reason):
            return "fetch error \(reason)"
        }
    }
}


