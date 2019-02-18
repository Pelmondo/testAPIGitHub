//
//  ChooseRepViewController.swift
//  APIGitHab
//
//  Created by Сергей Прокопьев on 16/02/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import UIKit
import Foundation

class ChooseRepViewController: UIViewController,NetworkSecondProtocol {
  
    @IBOutlet weak var chooseSearchBar: UISearchBar!
    @IBOutlet weak var chooseTableView: UITableView!
    @IBOutlet weak var chooseActivityIndent: UIActivityIndicatorView!
    
    var loadMoreStatus = false
    let network = NetworkingSecond()
    let indentifire = "Choose"
    let segue = "segueTwo"
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        chooseTableView.addSubview(refreshControl)
        
        
        chooseActivityIndent.startAnimating()
        guard let name = name else {return}
        guard let repo = repo else{return}
        network.delegate = self
        network.getIssues(login: name, repo: repo)
        chooseSearchBar.delegate = self
        chooseTableView.dataSource = self
        chooseTableView.delegate = self
        chooseTableView.isHidden = true
        chooseTableView.rowHeight = UITableView.automaticDimension
        chooseTableView.estimatedRowHeight = 44
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(_ sender: Any) {
//        TODO : Is near future
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        
self.refreshControl.endRefreshing()
        }
    }

    
    var displayChoose = [Title]()
   
    var name : String?
    var repo : String?
    var titles = [Title]()
    var path = IndexPath()
    
    func getData(getIssue: [Title]) {
        titles = getIssue
        displayChoose = titles
        DispatchQueue.main.async {
            self.chooseTableView.reloadData()
            self.chooseActivityIndent.stopAnimating()
            self.chooseTableView.isHidden = false
        }
    }
    
    // MARK: - refresh
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue {
            segue.destination.title = displayChoose[path.row].title
            if let dvc = segue.destination as? ThirdScreenViewController {
                dvc.login = displayChoose[path.row].user.login
                dvc.number = "\(displayChoose[path.row].number)"
                dvc.dateOfCreate = displayChoose[path.row].created_at
                dvc.labelIssue = displayChoose[path.row].labels
                dvc.avatarImageUrl = displayChoose[path.row].user.avatar_url
                dvc.nameIssue = displayChoose[path.row].title
                dvc.locked = displayChoose[path.row].locked
            }
            
      }
    }
    
    // MARK: - Infinity scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !loadMoreStatus {
                beginBatchFetch()
            }
            
        }
    }
    
    var new = Title.init(title: "load", user: User.init(login: "load", avatar_url: "load"), number: 1, created_at: "load", labels: [Label.init(name: "load")], locked: true)
    var i = 0
    
    func beginBatchFetch() {
        loadMoreStatus = true
        new.title = "load\(i)"
        print("beginBatchFetch!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            for _ in 1...4 {
            self.i += 1
            self.displayChoose.append(self.new)
            }
            self.loadMoreStatus = false
            self.chooseTableView.reloadData()
        })
    }
    
    
    
}


// MARK: - TabelView Data and Delegate

extension ChooseRepViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayChoose.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath)
        if let cell = cell as? ChooseTableViewCell {
            cell.chooseLabel.text = displayChoose[indexPath.row].title
            cell.numberLabel.text = "\(indexPath.row + 1)"
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        path = indexPath
        print (path.row)
        return indexPath
    }
    
    
    
}

// MARK: - SearchBar

extension ChooseRepViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayChoose = titles.filter { $0.title.range(of: searchText, options: .caseInsensitive) != nil }
        chooseTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        chooseSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        chooseSearchBar.text = ""
        chooseSearchBar.showsCancelButton = false
        displayChoose = titles
        chooseTableView.reloadData()
        chooseSearchBar.resignFirstResponder()
    }
}
