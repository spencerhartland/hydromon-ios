//
//  RequestHandler.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import Foundation

public struct Request {
    private static let baseURL = "http://172.20.10.11"
    private static let connectionTestPathComponent = "/connectionTest"
    private static let getPrefsPathComponent = "/getPreferences"
    private static let setPrefsPathComponent = "/setPreferences"
    private static let httpGETMethod = "GET"
    
    private static func requestURL(path: String) -> URL? {
        let urlString = baseURL + path
        guard let url = URL(string: urlString) else {
            print("Unable to create URL from FBRequest.baseURL")
            return nil
        }
        return url
    }
    
    fileprivate static func connectionTestRequest() -> URLRequest? {
        guard let url = requestURL(path: Request.connectionTestPathComponent) else {
            print("Error while unwrapping url from requestURL()")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = Request.httpGETMethod
        return request
    }
    
    fileprivate static func getPreferencesRequest() -> URLRequest? {
        guard let url = requestURL(path: Request.getPrefsPathComponent) else {
            print("Error while unwrapping url from requestURL()")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = Request.httpGETMethod
        return request
    }
}


public struct RequestHandler {
    private func handle(_ request: URLRequest, completion: @escaping (Bool, String) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200 ..< 300).contains(httpResponse.statusCode),
                  let responseData = data
            else {
                completion(false, "There was an error getting a response from the server.")
                return
            }
            let decodedResponse = String(decoding: responseData, as: UTF8.self)
            completion(true, decodedResponse)
        }.resume()
    }
    
    public func testConnection(completion: @escaping (Bool, String) -> Void) {
        guard let request = Request.connectionTestRequest() else {
            completion(false, "There was an error getting a response from the server.")
            return
        }
        handle(request, completion: completion)
    }
    
    public func getPreferences(completion: @escaping (Bool, String) -> Void) {
        guard let request = Request.getPreferencesRequest() else {
            completion(false, "There was an error getting a response from the server.")
            return
        }
        handle(request, completion: completion)
    }
}
