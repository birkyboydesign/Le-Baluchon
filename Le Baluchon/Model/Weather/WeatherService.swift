//
//  Weatherservice.swift
//  Le Baluchon
//
//  Created by Birkyboy on 12/08/2021.
//

import Foundation

class WeatherService {

    static let shared = WeatherService()
    private init() {}

    private static let currenciesUrl = URL(string: ApiURL.openWeatherMapURL)!
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(_ weatherURL: URL) -> URLRequest {
        var request = URLRequest(url: weatherURL)
        request.httpMethod = "GET"
        return request
    }

    /// Fetch data from API
    ///
    /// - Parameter completion: Returns a Result.
    /// - Succes case:  currency list dictionary.
    /// - Error case :  Error of type ApiError.
    func getRateData(for city: String,
                     completion: @escaping (Result<Weather, ApiError>) -> Void) {

        guard let formattedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let weatherURL = URL(string: ApiURL.openWeatherMapURL + "weather?q=\(formattedCity)&units=metric&lang=fr&appid=" + ApiKeys.openWeatherKEY) else {return}

        // set current request returned from the createRequest method.
        let request = createRequest(weatherURL)

        // cancel previous task
        task?.cancel()
        // set current tast with a session datatask for the current request
        // returns data, a responses status and and eventually an error
        task = session.dataTask(with: request) { (data, response, error) in
            // run the rest of the code in the main thread
            DispatchQueue.main.async {
                // Check if there is an error
                guard error == nil else {
                    completion(.failure(.noNetwork))
                    return
                }
                // Unwrap data optional
                guard let data = data else {
                    completion(.failure(.errorFetching))
                    return
                }
                // check if the response code is 200. if true move on or return
                // completion failure case.
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(.failure(.httpError))
                    return
                }
                // do/catch block for trying to decode data returned from session dataTask
                do {
                    let responseJSON = try JSONDecoder().decode(Weather.self, from: data)
                    // return decoded JSON
                    completion(.success(responseJSON))
                } catch {
                    // return an error in case of failure decoding JSON
                    print(error)
                    completion(.failure(.decodingData))
                }
            }
        }
        // start the task
        task?.resume()
    }
   
}
