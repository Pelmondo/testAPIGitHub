//
//  PublicRepViewController.swift
//  APIGitHab
//
//  Created by Сергей Прокопьев on 16/02/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import UIKit
import Foundation

class PublicRepViewController: UIViewController, NetworkProtocol {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var firstSearchBar: UISearchBar!
    @IBOutlet weak var publicRepTableView : UITableView!

    var loadMoreStatus = false
    var initialNum = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
            print("It's okay")
        } else {
            let alert = UIAlertController(title: nil, message: "Internet connections failed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicatorView.startAnimating()
        network.delegate = self
        network.getQuestion(startNumber: initialNum)
        firstSearchBar.delegate = self
        publicRepTableView.delegate = self
        publicRepTableView.dataSource = self
        publicRepTableView.isHidden = true
        publicRepTableView.estimatedRowHeight = 44
        publicRepTableView.rowHeight = UITableView.automaticDimension
       
        // Do any additional setup after loading the view.
    }
    
    let network = NetworkingAPI()
    let segIndent = "segue"
    var test = [String]()
    var displayTest = [Owner]()
    var path = IndexPath()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segIndent {
            segue.destination.title = displayTest[path.row].name
            if let dvc = segue.destination as? ChooseRepViewController {
                dvc.name = displayTest[path.row].owner.login
                dvc.repo = displayTest[path.row].name
                
            }
        }
    }
    
    var testik = [Owner]()
    func answContainer (informData : [Owner]) {
        self.testik = informData
       
//        for item in testik {
//            test.append(item.name)
//        }
        displayTest = testik
        print(test)
        DispatchQueue.main.async {
            self.publicRepTableView.reloadData()
            self.publicRepTableView.isHidden = false
            self.indicatorView.stopAnimating()
//            self.indicatorView.isHidden = true
        }
    }

}


// MARK: - TableView data source

extension PublicRepViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return displayTest.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicCell", for: indexPath)
        if let cell = cell as? PublicTableViewCell {
            cell.resultLabel.text = displayTest[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        path = indexPath
        print (path.row)
        return indexPath
    }
    
}

// MARK: - Search Bar

extension PublicRepViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayTest = testik.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
        publicRepTableView.reloadData()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        firstSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        displayTest = testik
        firstSearchBar.text = ""
        firstSearchBar.showsCancelButton = false
        publicRepTableView.reloadData()
        firstSearchBar.resignFirstResponder()
    }
    
}

