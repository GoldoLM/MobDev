//
//  API_Call.swift
//  Project_DevMob
//
//  Created by goldorak on 31/01/2022.
//

import Foundation

class APICall {
    private static var token = "keyHFsqSMPyhxtdOW"
    
    static func call<T: Decodable>(_ returning: T.Type, url: String, completionHandler: @escaping (T?) -> Void, errorHandler: @escaping (ApiError?) -> Void) {
        let url = URL(string: url)
        
        // URL pour appel de l'api
        var request = URLRequest(url: url!)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                // Erreur HTTP
                errorHandler(ApiError.httpError(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                // Erreur API
                let httpCode: String = String((response as? HTTPURLResponse)?.statusCode ?? 0)
                errorHandler(ApiError.apiError(httpCode, String(bytes: data ?? Data(), encoding: .utf8) ?? ""))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    // Formats des dates: 2019-11-15T14:30:00.000Z
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                    dateFormatter.locale = Locale(identifier: "en_US")
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let decoded = try decoder.decode(T.self, from: data)
                    completionHandler(decoded)
                } catch {
                    // Erreur de parsing
                    errorHandler(ApiError.parseError(error, String(bytes: data, encoding: .utf8) ?? ""))
                }
            }
        })
        
        task.resume()
    }
}
