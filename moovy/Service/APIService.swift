//
//  APIService.swift
//  moovy
//
//  Created by fârûqî on 25.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

//https://api.themoviedb.org/3/movie/550?api_key=5c3f14a468fe223a9d38df038fea07f8

class APIService {
    static let instance = APIService()
    
    let headers: HTTPHeaders = [
        "Accept": "*/*",
        "User-Agent": "Mozilla/5.0"
    ]
    
    public func fetch<T:Codable> (_ method: HTTPMethod, url: String, requestModel: T?, model: T.Type, completion: @escaping (AFResult<Codable>) -> Void ) {
        AF.request(url, method: method, parameters: APIService.toParameters(model: requestModel), encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String: AnyObject]):
                    //print(response)
                    do{
                        let responseJsonData = JSON(value)
                        let responseModel = try JSONDecoder().decode(model.self, from: responseJsonData.rawData())
                        completion(.success(responseModel))
                    }
                    catch let parsingError{
                        print("success but : \(parsingError)");
                    }
                
                case .failure(let error):
                print("failure: \(error)")
                    completion(.failure(error))
                
                default:
                    fatalError("fatal error")
            }
        }
    }
    static func toParameters<T:Encodable>(model: T?) ->[String:AnyObject]? {
        if  model == nil {
            return nil
        }
        let jsonData = modelToJson(model: model)
        let parameters = jsonToParameters(from: jsonData!)
        return parameters! as [String: AnyObject]
    }
    
    static func modelToJson<T:Encodable>(model:T) -> Data? {
        return try? JSONEncoder().encode(model.self)
    }
    
    static func jsonToParameters(from data: Data) -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
