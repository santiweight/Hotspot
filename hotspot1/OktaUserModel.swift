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

class OktaUserModel {
    
    let oktaRequestURL : String = "https://dev-158434.oktapreview.com/api/v1/users?activate=true"
    
    //check if user already signed in, token is valid
    func isAuthenticated() -> Bool{
        return false;
//        return ((OktaAuth.tokens?.get(forKey: "accessToken")) != nil)
    }
    
    //create & activate user in Okta group, direct to login page
    func createUser(APIKey: String, params: [String: Any]) -> Bool{
        
        let oktaRequestHeaders : HTTPHeaders =  [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "SSWS \(APIKey)"
        ]
        
        Alamofire.request(oktaRequestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: oktaRequestHeaders)
        .responseJSON {
            response in switch response.result {
                case .success(let JSON):
                    print(JSON)
                case .failure(let error):
                    print("Request failed with error: \(error)")
            }
        }
        return true
    }
    
    //direct user to login page
    func login(viewController: UIViewController){
        OktaAuth
            .login()
            .start(viewController) { response, error in
                if error != nil { print(error!) }

                // Success
                if let tokenResponse = response {
                    //go to home screen for logged-in hotspot users
                    self.toHomeView(viewController: viewController)
                    OktaAuth.tokens?.set(value: tokenResponse.accessToken!, forKey: "accessToken")
                    OktaAuth.tokens?.set(value: tokenResponse.idToken!, forKey: "idToken")
                    print("Success! Received accessToken: \(tokenResponse.accessToken!)")
                    print("Success! Received idToken: \(tokenResponse.idToken!)")
                }
    }
    
    //go to home screen for logged-in hotspot users
    func toHomeView(viewController: UIViewController){
        let homeViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        viewController.navigationController?.present(homeViewController, animated: true)
    }
}

