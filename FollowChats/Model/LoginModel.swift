//
//  LoginModel.swift
//  FollowChats
//
//  Created by Sanjay Mali on 16/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import Foundation
struct LoginModel: Decodable{
    let status:String
    let msg:String
    let token:String
    let body:Body
}
struct Body: Decodable{
    let user:User
}
struct User:Decodable {
    let id:Int?
    let name:String?
    let first_name:String?
    let last_name:String?
    let email:String?
    let login_type_id:Int?
    let created_date:String?
    let dob:String?
    let isVerified:Bool?
    let profile_img_url:String?
}

