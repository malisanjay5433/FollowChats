//
//  PostModel.swift
//  FollowChats
//
//  Created by Sanjay Mali on 16/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//
struct PostModel: Decodable{
    let status:String
    let msg:String
    let token:String
    let body:PostsBody
}
struct PostsBody:Decodable{
    let posts_new:[Posts_new]
}
struct Posts_new:Decodable{
    let network_id:Int?
    let post_id:String?
    let id:String?
    let fc_post_id:String?
    let media_url:String?
    let thumbnail_url:String?
    let type:String?
    let description:String?
    let social_network_userid:String?
    let location:String?
    let last_updated:String?
}

