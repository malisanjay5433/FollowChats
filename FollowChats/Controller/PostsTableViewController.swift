//
//  FirstViewController.swift
//  FollowChats
//
//  Created by Sanjay Mali on 16/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit
import Kingfisher
import KRProgressHUD
import CoreData

class PostsTableViewController: UITableViewController,UISearchBarDelegate {
    var post_Arr = [Posts_new]()
    var filtered = [Table_V1]()
    var coreData = [Table_V1]()
    var userinfo:LoginModel?
    var videoUrl:String?
    var searchActive : Bool = false
    var userdefault = UserDefaults()
    var token = "token"
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet var segmentedControl: UISegmentedControl!
    var isSort = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.placeholder = "Search here..."
        self.searchbar.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        DispatchQueue.main.async(execute: { () -> Void in
            self.downloadJSON()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    func fetchData(){
        DispatchQueue.main.async(execute: { () -> Void in
            let post = PersistanceService.FetchRequest()
            self.coreData = post
            self.tableView.reloadData()
            KRProgressHUD.dismiss()
            //                self.navigationItem.title = "\(self.coreData.count) Posts"
            
        })
    }
    private func downloadJSON(){
        KRProgressHUD.show()
        let jsonDict = ["body": ["email":"clicktesting4@gmail.com", "password":"1234567"]]
        let api = "http://dev.followchats.com/api/authenticate/"
        DataManager.getJSON(api,param:jsonDict) { (data,error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(LoginModel.self, from: data)
                print(json)
                self.userinfo = json
                self.downloadPosts()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func downloadPosts(){
        //        let token = self.userdefault.string(forKey: self.token)
        
        let jsonDict = ["body": ["x-access-token":userinfo?.token]]
        let api = "http://dev.followchats.com/api/user/post/get"
        DataManager.getJSON(api,param:jsonDict as! [String : [String : String]]) { (data,error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(PostModel.self, from: data)
                self.post_Arr = json.body.posts_new
                for i in json.body.posts_new{
                    let coredata = Table_V1(context:PersistanceService.context)
                    
                    if i.id != nil{
                        coredata.id = i.id
                    }else{
                        //                        coredata.id = ""
                    }
                    if i.post_id != nil{
                        coredata.post_id = i.post_id
                        
                    }else{
                        //                        coredata.post_id = ""
                    }
                    if i.description != nil{
                        coredata.textDescrption = i.description
                        
                    }else{
                        //                        coredata.textDescrption = ""
                    }
                    
                    if i.thumbnail_url != nil{
                        coredata.thumbnail_url = i.thumbnail_url
                        
                    }else{
                        //                        coredata.thumbnail_url = ""
                    }
                    
                    if i.type != nil{
                        coredata.type = i.type
                        
                    }else{
                        //                        coredata.type = ""
                    }
                    if i.social_network_userid != nil{
                        coredata.social_network_userid = i.social_network_userid
                    }else{
                    }
                    PersistanceService.saveContext()
                    self.fetchData()
                }
            }catch{
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                KRProgressHUD.dismiss()
            }
        }
    }
}
extension PostsTableViewController{
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive == true{
            return self.filtered.count
        }else{
            //            print("from Sanjay Mali:\(self.coreData.count)")
            return self.coreData.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell2:ImagePostCell  = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImagePostCell
        
        if cell2 != nil {
            let profileImageUrl = userinfo?.body.user.profile_img_url
            let url = URL(string:profileImageUrl!)
            cell2.profileImageView.kf.setImage(with:url, placeholder:UIImage(named:"placeholder"), options:nil, progressBlock: nil, completionHandler: nil)
            cell2.nameLbl.text = userinfo?.body.user.name
            
            if searchActive ==  true{
                let userPost = self.filtered[indexPath.row]
                if  filtered.count == 0{
                    cell2.discrptionLbl.text = userPost.textDescrption
                }else{
                    cell2.discrptionLbl.text = userPost.textDescrption
                    if (userPost.thumbnail_url != nil) && userPost.thumbnail_url != ""{
                        cell2.imageHiehgtConstraint.constant = 300
                        let url = URL(string:userPost.thumbnail_url!)
                        cell2.backView.kf.setImage(with:url, placeholder:UIImage(named:"placeholder"), options:nil, progressBlock: nil, completionHandler: nil)
                    }else{
                        cell2.imageHiehgtConstraint.constant = 0
                    }
                    
                }
                return cell2
            }else{
                let userPost = self.coreData[indexPath.row]
                cell2.discrptionLbl.text = userPost.textDescrption
                if (userPost.thumbnail_url != nil) && userPost.thumbnail_url != ""{
                    cell2.imageHiehgtConstraint.constant = 300
                    let url = URL(string:userPost.thumbnail_url!)
                    cell2.backView.kf.setImage(with:url, placeholder:UIImage(named:"placeholder"), options:nil, progressBlock: nil, completionHandler: nil)
                }else{
                    cell2.imageHiehgtConstraint.constant = 0
                }
            }
        }
        return cell2
    }
    
}
extension PostsTableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = post_Arr[indexPath.row].media_url
        print("url:\(String(describing: url))")
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)! as! ImagePostCell
        if cell.vframe?.isPlaying == true || url == "" || url == nil {
            return
        }
        if let url = url {
            let url  = URL(string:url)
            cell.vframe?.alpha = 1
            cell.vframe?.layer.cornerRadius = 3.0
            cell.vframe?.layer.masksToBounds = true
            cell.vframe?.videoUrl = url
            cell.vframe?.shouldAutoplay = true
            cell.vframe?.shouldAutoRepeat = false
            cell.vframe?.showsCustomControls = false
            cell.vframe?.isMuted = true
            cell.vframe?.isPlaying  = true
            cell.vframe?.layer.cornerRadius = 3.0
            cell.vframe?.layer.masksToBounds = true
        }
        else{
            print("No ")
        }
    }
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            print("Text")
            self.sortTextOrImageOrVideo(type: "text")
            break
        case 1:
            print ("Image")
            self.sortTextOrImageOrVideo(type: "image")
            break
            
        case 2:
            print ("Video")
            //            self.sortTextOrImageOrVideo(type: "video")
            break
        default:
            break
        }
    }
    //  Filter the data from model,Image Text,Video
    func sortTextOrImageOrVideo(type:String) {
        let filtredData = self.coreData.filter { $0.type == type}
        self.filtered = filtredData
        isSort = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("filtredData:\(filtredData.count)")
            self.navigationItem.title = "\(self.filtered.count) Posts"
        }
    }
    
}


extension  PostsTableViewController{
    // MARK: - Searchbar Delegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder() // hides the keyboard.
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = coreData.filter({ (model:Table_V1) -> Bool in
            return model.textDescrption?.lowercased().range(of:searchText.lowercased()) != nil
        })
        if searchText != ""{
            searchActive = true
            self.tableView.reloadData()
            
        }else{
            searchActive = false
            self.tableView.reloadData()
        }
    }
}

public extension UITableView {
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let origin = view.bounds.origin
        let viewOrigin = self.convert(origin, from: view)
        let indexPath = self.indexPathForRow(at: viewOrigin)
        return indexPath
    }
}
