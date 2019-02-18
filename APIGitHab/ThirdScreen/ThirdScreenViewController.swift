//
//  ThirdScreenViewController.swift
//  APIGitHab
//
//  Created by Сергей Прокопьев on 17/02/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import UIKit

class ThirdScreenViewController: UIViewController {
    

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var NameUserLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameIssueLabel: UILabel!
    @IBOutlet weak var LabelsLabel: UILabel!
    @IBOutlet weak var dateOfCreateLabel: UILabel!
    @IBOutlet weak var activityIndent: UIActivityIndicatorView!
    @IBOutlet weak var lockedLabel: UILabel!
    
    var login = String()
    var number = String()
    var dateOfCreate = String()
    var labelIssue : [Label]?
    var avatarImageUrl = String()
    var nameIssue = String()
    var locked = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndent.startAnimating()
        DispatchQueue.main.async {
            self.getImage()
            self.activityIndent.isHidden = true
            self.activityIndent.stopAnimating()
            
        }
        getInformation()
       
        
    }
    
    func getImage () {
        
        guard let url = URL(string: avatarImageUrl) else {return}
        
        do{
            let imageData = try Data(contentsOf: url)
            avatarImage.image = UIImage(data: imageData)
        } catch {
            print(error)
        }
    }

    func getInformation () {
        
        NameUserLabel.text = login
        numberLabel.text = number
        getDate()
        nameIssueLabel.text = nameIssue
        lockedLabel.text = locked ? "Закрыта" : "Открыта"
        guard let label = labelIssue else {return}
        if label.count > 0 {
            LabelsLabel.text = label[0].name
        }
        
    }
    
    func getDate () {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        let changeDate = dateOfCreate.replacingOccurrences(of: "T", with: " ")
        
        let dateFromString = dateFormatter.date(from: changeDate)
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateFormat = "MMM d, yyyy"
        
        guard let date = dateFromString else {return}
        
        let dateOfCreateString = secondDateFormatter.string(from: date)
        
        dateOfCreateLabel.text = dateOfCreateString
    }
    

}
