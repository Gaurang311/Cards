//
//  WebAPISession.swift
//  cards
//
//  Created by Gaurang Lathiya on 25/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit
import Reachability
import SwiftyJSON


// WebService Type
enum WSType: String {
    case GET = "GET"
    case POST = "POST"
}

// Development Webserver URL
let serverURL: String = "https://api.myjson.com/"

// Final WebService URL
let wsURL: String = serverURL + "bins/"

let kWserviceUrl_GetCards: String = wsURL + "vt8zx"

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = ("\(value)" ).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

class WebAPISession: URLSession {
    
    lazy var configurationCustom: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configurationCustom)
    
    typealias webServiceResponceHandler = ((JSON?, String?) -> Void)
    typealias webServiceRequestHandler = ((NSURLRequest?, String?) -> Void)
    
    // MARK: - Web Service Call Method
    public func callWebAPI(wsType:WSType, webURLString: String, parameter: Dictionary<String, Any>, completion:
        @escaping webServiceResponceHandler) {
        
        // Set up the URL request
        guard let url = URL(string: webURLString) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy
            , timeoutInterval: 30)
        urlRequest.allowsCellularAccess = true // For allow mobile data
        urlRequest.httpMethod = wsType.rawValue
        // Add Header field
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch wsType {
        case .GET:
            var webURLString_v1 = webURLString
            
            // Set up the Web URL for URLRequest for GET
            let parameterString = parameter.stringFromHttpParameters()
            if parameterString.count > 0 {
                webURLString_v1 = "\(webURLString_v1)?\(parameterString)"
            }
            
            guard let urlLegal = URL(string: webURLString_v1) else {
                print("Error: cannot create URL")
                return
            }
            print("URL: \(urlLegal)")
            urlRequest.url = urlLegal
            
            self.webAPI(urlRequest: urlRequest) { (responce, error) in
                completion(responce, error)
            }
        case .POST:
            // Set up the http body for URLRequest
            self.preparePostParameters(parameter: parameter, urlRequest: urlRequest, completion: { (urlRequestObj, error) in
                if error != nil {
                    completion(nil, error)
                }
                else {
                    urlRequest = urlRequestObj! as URLRequest
                    
                    self.webAPI(urlRequest: urlRequest) { (responce, error) in
                        completion(responce, error)
                    }
                }
            })
        }
    }
    
    // MARK: - Web Service Engine
    func webAPI(urlRequest: URLRequest, completion: @escaping webServiceResponceHandler) {
        
        // Check internet
        if ReachabilityManager.shared.reachability.connection != .none {
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            let task = self.session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                // check for any errors
                guard error == nil else {
                    print("\(String(describing: error?.localizedDescription))")
                    print(error as Any)
                    completion(nil, error?.localizedDescription)
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    completion(nil, Constants.kErrorWSNoData)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                    switch httpResponse.statusCode {
                    case 200, 403,409 : // 403 & 409 -> Header failed to match and provide error in JSON format
                        do {
                            let json =  try JSON.init(data: responseData, options: .allowFragments)
                            completion(json,nil)
                        }
                        catch let error {
                            print("Error: \(error.localizedDescription)")
                            completion(nil, error.localizedDescription)
                        }
                        break
                    default:
                        do {
                            let json = try JSON(data: responseData)
                            completion(json,nil)
                        }
                        catch  let error {
                            print("Error: \(error.localizedDescription)")
                            completion(nil, error.localizedDescription)
                        }
                        break
                    }
                }
            })
            task.resume()
        } else {
            completion(nil, Constants.kNoInterNetConnection)
        }
    }
    
    // MARK: - Helper method for main web-api call
    func preparePostParameters(parameter: Dictionary<String, Any>, urlRequest: URLRequest, completion:
        @escaping webServiceRequestHandler) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: [])
            print("Request URL: \(String(describing: urlRequest.url))")
            
            var urlRequestObj = urlRequest
            urlRequestObj.httpBody = jsonData
            
            completion(urlRequestObj as NSURLRequest, nil)
        } catch {
            print("JSON serialization failed:  \(error)")
            completion(nil, error.localizedDescription)
        }
    }
}
