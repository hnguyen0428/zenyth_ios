//
//  SearchController.swift
//  Zenyth
//
//  Created by Hoang on 9/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UITableViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    var users: [User] = [User]()
    
    static let HEIGHT_ROW: CGFloat = 60
    
    override func viewDidLoad() {
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        setupSearch()
    }
    
    func setupSearch() {
        //Setting the searchResultsUpdater property to self, sets the delegate to our view controller instance.
        searchController.searchResultsUpdater = nil
        
        searchController.searchResultsUpdater = self
        
        // prevents the navigation bar from hiding while you type in the search bar.
        searchController.hidesNavigationBarDuringPresentation = false
        
        // The dimsBackgroundDuringPresentation indicates whether the search results look dim when typing a search
        searchController.dimsBackgroundDuringPresentation = false
        
        //ensures that the search bar does not remain on the screen if the user navigates to another view controller while the UISearchController is active
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            if text != "" {
                searchUsers(keyword: text)
            }
            else {
                users.removeAll()
                tableView.reloadData()
            }
        }
    }
    
    func searchUsers(keyword: String) {
        UserManager().searchUser(withKeyword: keyword, onSuccess:
            { users in
                self.users = users
                self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchController.HEIGHT_ROW
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // present a view controller
        let controller = ProfileController()
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        
        let user = cell.user
        
        controller.userId = user!.id
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        
        cell.noFollowButton = true
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
