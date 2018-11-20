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
        return ((OktaAuth.tokens?.get(forKey: "accessToken")) != nil)
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
                    if(createdUser(JSON: JSON as! NSDictionary)){
                        let sessionParams = params["profile"] as! [String: Any]
                        let sessionEmail = sessionParams["email"] as! String
                        setSessionEmail(sessionEmail: sessionEmail)
                        completionHandler(true, nil)
                    }else{
                        completionHandler(false, nil)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(false, error)
            }
        }
    }
    
    //direct user to login page
    //Password requirements: at least 8 characters, a lowercase letter, an uppercase letter, a number, no parts of your username.
    static func login(viewController: UIViewController, completionHandler: @escaping (Bool?, Error?) -> ()){
        OktaAuth
            .login()
            .start(viewController) { response, error in
                if error != nil {
                    print(error!)
                    completionHandler(false, nil)
                }

                if let tokenResponse = response {
                    //set Okta tokens
                    OktaAuth.tokens?.set(value: tokenResponse.accessToken!, forKey: "accessToken")
                    OktaAuth.tokens?.set(value: tokenResponse.idToken!, forKey: "idToken")

                    OktaAuth.userinfo() { response, error in
                        if error != nil {
                            setSessionEmail(sessionEmail: "SESSION EMAIL ERROR")
                        }
                        
                        if let userinfo = response {
                            let sessionEmail = userinfo["preferred_username"] as! String
                            setSessionEmail(sessionEmail: sessionEmail)
                        }
                    }
                    
                    completionHandler(true, nil)
                }
            }
    }
    
    //parse JSOM response to determine a new Okta user was successfully created
    static func createdUser(JSON: NSDictionary)->Bool{
        return JSON["errorSummary"] == nil
    }
    
    //set session variables (only email right now)
    static func setSessionEmail(sessionEmail: String){
            UserDefaults.standard.set(sessionEmail, forKey:"sessionEmail");
            UserDefaults.standard.synchronize();
    }
}

