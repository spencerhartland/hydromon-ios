//
//  RequestHandler.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import Foundation

public struct Request {
    enum RequestType: String {
        case connectionTest = "/connectionTest"
        case preferences = "/preferences"
        case fillLevel = "/fillLevel"
    }
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    private static let baseURL = "http://192.168.4.1"
    private static let headers = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    private static func requestURL(path: String) -> URL? {
        let urlString = baseURL + path
        guard let url = URL(string: urlString) else {
            print("Unable to create URL from Request.baseURL")
            return nil
        }
        return url
    }
    
    fileprivate static func createRequest(type: RequestType, method: HTTPMethod) -> URLRequest? {
        guard let url = requestURL(path: type.rawValue) else {
            print("Error while unwrapping url from requestURL()")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}


public struct RequestHandler {
    private func handle(_ request: URLRequest, completion: @escaping (Bool, String) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        }
        
        task.resume()
    }
    
    public func testConnection(completion: @escaping (Bool, String) -> Void) {
        guard let request = Request.createRequest(type: .connectionTest, method: .GET) else {
            completion(false, "There was an error getting a response from the server.")
            return
        }
        handle(request, completion: completion)
    }
    
    public func getPreferences(completion: @escaping (Bool, String) -> Void) {
        guard let request = Request.createRequest(type: .preferences, method: .GET) else {
            completion(false, "There was an error getting a response from the server.")
            return
        }
        handle(request, completion: completion)
    }
    
    public func setPreferences(data: Data, completion: @escaping (Bool, String) -> Void) {
        guard var request = Request.createRequest(type: .preferences, method: .POST) else {
            completion(false, "There was an error getting a response from the server.")
            return
        }
        request.httpBody = data
        request.timeoutInterval = 120
        handle(request, completion: completion)
    }
    
    public func getFillLevel(completion: @escaping (Bool, String) -> Void) {
        guard let request = Request.createRequest(type: .fillLevel, method: .GET) else {
            completion(false, "There was an error getting a response from the server.")
            return
        }
        handle(request, completion: completion)
    }
}
