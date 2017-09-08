//
//  ViewController.swift
//  FollowersWindow
//
//  Created by Robert  Koepp on 8/30/17.
//  Copyright © 2017 Robert Koepp. All rights reserved.
//

import UIKit

class FollowersController: UITableViewController, UISearchResultsUpdating {
    
    var userId: UInt32?
    
    var users: [User]?
    var followStatuses: [String]?
    // var filteredUsers: [User]?
    var filteredUsers = [User]()
    
    static let HEIGHT_OF_ROW: CGFloat = 60
    
    
    // with a nil value for the searchResultsController, you tell the search controller that you want use the same view you’re searching to display the results
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tells the ui table view, everytime we deque a cell w/ cellID just use table view cell to render
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Followers"
        
        // called everytime view controller is instantiated
        setupUsers()
        setupSearch()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // present a view controller
        let controller = ProfileController()
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        
        let user = cell.user
        
        controller.userId = user!.id
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FollowersController.HEIGHT_OF_ROW
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // will try to recycle cell, if unable, will create
        // downcasted to user cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        
        if isFiltering() {
            let user = filteredUsers[indexPath.row]
            cell.user = user
        } else {
            let user = users?[indexPath.row]
            cell.user = user
        }
        
        if let statuses = followStatuses {
            cell.followStatus = statuses[indexPath.row]
        }
        let loggedInUserId = UserDefaults.standard.object(forKey: "id") as! UInt32
        if cell.user?.id == loggedInUserId {
            cell.followButton.removeFromSuperview()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  check whether the user is searching or not, and use either the filtered or normal users as a data source for the table
        if isFiltering() {
            return filteredUsers.count
        }
        if let count = users?.count {
            // refreshes self
            return count
        }
        
        return 0
    }
    
    func setupUsers() {
        guard self.userId != nil else { return }
        
        UserManager().getFollowers(ofUserId: self.userId!, onSuccess:
            { users in
                self.users = users
                self.followStatuses = [String].init(repeating: "", count: users.count)
                self.tableView.reloadData()
                
                let group = DispatchGroup()
                for i in 0..<users.count {
                    let user = users[i]
                    group.enter()
                    UserManager().getRelationship(withUserHavingUserId: user.id,
                                                  onSuccess:
                        { relationship in
                            if let rel = relationship {
                                if rel.status {
                                    self.followStatuses?[i] = "Following"
                                }
                                else {
                                    self.followStatuses?[i] = "Request sent"
                                }
                            }
                            else {
                                self.followStatuses?[i] = "Not following"
                            }
                            group.leave()
                    })
                }
                
                group.notify(queue: .main) {
                    self.tableView.reloadData()
                }
        })
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
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredUsers = users!.filter({( user : User) -> Bool in
            
            let name = user.name() ?? ""
            // checks username and full name
            return user.username.lowercased().contains(searchText.lowercased()) || name.lowercased().contains(searchText.lowercased())

        })
        
        tableView.reloadData()
    }
    
    
}

