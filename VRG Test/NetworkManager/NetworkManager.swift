//
//  NetworkManager.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/28/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import Alamofire



class NetworkManager {
    
    static func fetchDataImage(url: String, completion: @escaping (UIImage) -> ()) {
        
        request(url).responseData { (dataResponse) in
            switch dataResponse.result {
                
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    
                    return
                }
                completion(image)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func fetchDataWithAlamofire(url: String, completion: @escaping (Nytimes) -> ()) {
        
        request(url).responseData { (dataResponse) in
            switch dataResponse.result {
                
            case .success(let data):
                guard let article = try? JSONDecoder().decode(Nytimes.self, from: data) else {
                    
                    return
                }
                completion(article)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}
