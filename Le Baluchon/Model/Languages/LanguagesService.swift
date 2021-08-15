//
//  LanguagesService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class LanguagesService {

    func getData(completion: @escaping (Result<Languages, ApiError>) -> Void) {

        guard let request = createRequest() else {
            completion(.failure(.urlError))
            return
        }
        ApiService.shared.getData(for: Languages.self, request: request) { result in
            switch result {
            case .success(let languages):
                completion(.success(languages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createRequest() -> URLRequest? {
        guard let url = URL(string: ApiURL.googleTranslateURL + "/languages?target=fr&key=" + ApiKeys.googleTranslateKey) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
