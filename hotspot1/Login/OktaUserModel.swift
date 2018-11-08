//
//  UserCreator.swift
//  OktaPractice
//
//  Created by Zack Rossman on 10/17/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation
import Alamofire
import OktaAuth

class OktaModel {
    
    
    //check if user already signed in, token is valid
    static func isAuthenticated() -> Bool{
        return false;
//        return ((OktaAuth.tokens?.get(forKey: "accessToken")) != nil)
    }
    
    //create & activate user in Okta group, direct to login page
    static func createUser(params: [String: Any], completionHandler: @escaping (Bool?, Error?) -> ()){
        let oktaAPIKey : String = "00-_6NVmANndYasYRWVmXN9u4YfvY5-S7OrEhawRQC"
        let oktaRequestURL : String = "https://dev-158434.oktapreview.com/api/v1/users?activate=true"

        let oktaRequestHeaders : HTTPHeaders =  [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "SSWS \(oktaAPIKey)"
        ]
        
        Alamofire.request(oktaRequestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: oktaRequestHeaders)
        .responseJSON {
            response in switch response.result {
                case .success(let JSON):
                    print(JSON)
                    completionHandler(true, nil)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(false, error)
            }
        }
    }
    
    //direct user to login page
    static func login(viewController: UIViewController, completionHandler: @escaping (Bool?, Error?) -> ()){
        OktaAuth
            .login()
            .start(viewController) { response, error in
                if error != nil {
                    print(error!)
                    completionHandler(false, nil)
                }

                // Success
                if let tokenResponse = response {
                    completionHandler(true, nil)
                    OktaAuth.tokens?.set(value: tokenResponse.accessToken!, forKey: "accessToken")
                    OktaAuth.tokens?.set(value: tokenResponse.idToken!, forKey: "idToken")
                    print("Success! Received accessToken: \(tokenResponse.accessToken!)")
                    print("Success! Received idToken: \(tokenResponse.idToken!)")
                }
            }
    }
}

