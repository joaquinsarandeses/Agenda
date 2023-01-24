//
//  NetworkHelper.swift
//  Agenda
//
//  Created by joaquin sarandeses on 16/1/23.
//

import Foundation


class NetworkHelper{
    
    enum RequestType: String{
        case GET
        case POST
    }
    
    //Singleton
    static let shared = NetworkHelper()
    
    //Se comunica con la API
   private  func requestAPI(request: URLRequest, completion: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }

    //Se comunica con la función requestAPI
    func requestProvider(url: String, type: RequestType = .POST, params: [String: Any]? = nil, completion: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: url)
        
        guard let urlNotNil = url else { return }
        var request = URLRequest(url: urlNotNil)
        
        request.httpMethod = type.rawValue
        
        if let dictionary = params{
            let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
            request.httpBody = data
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestAPI(request: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
    }
    
    
}
