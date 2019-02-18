//
//  NetworkingAPI.swift
//  APIGitHab
//
//  Created by Сергей Прокопьев on 17/02/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkProtocol : class{
    func answContainer (informData : [Owner])
}

struct Owner : Decodable {
    var owner : inOwner
    var name : String
}

struct inOwner : Decodable {
    var login : String
}


class NetworkingAPI {
    
    var delegate : NetworkProtocol?
    

    let decoder = JSONDecoder()
    
    func getQuestion (startNumber: Int) {
        
        guard let url = URL(string: "https://api.github.com/repositories?since=\(startNumber)") else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else {return}
            
            
            do{
                let json = try self.decoder.decode([Owner].self, from: data)
                print(json[0].name)
                self.delegate?.answContainer(informData: json)
            } catch {
                print(error)
            }
            }.resume()
    }
    
}
