//
//  NetworkingSecond.swift
//  APIGitHab
//
//  Created by Сергей Прокопьев on 17/02/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import Foundation
import UIKit

struct Title : Decodable {
    var title : String
    var user : User
    var number : Int
    var created_at : String
    var labels : [Label]
    var locked : Bool
}

struct User : Decodable {
    var login : String
    var avatar_url : String
    
}

struct Label : Decodable {
    var name : String
}

protocol NetworkSecondProtocol : class{
    func getData (getIssue : [Title])
}

class NetworkingSecond {
    
    let decoder = JSONDecoder()
    var delegate : NetworkSecondProtocol?
    
    func getIssues (login : String, repo : String) {
        guard let url = URL(string: "https://api.github.com/repos/\(login)/\(repo)/issues") else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error)  in
            if let response = response {
                    print(response)
            }
            
            guard let data = data else {return}
            
            do{
                let json = try self.decoder.decode([Title].self, from: data)
                self.delegate?.getData(getIssue: json)
                
            } catch {
                print(error)
            }
            }.resume()
        
        
        
        
    }
}
