//
//  UserViewController.swift
//  SnapChat
//
//  Created by JOHN KENNY on 29/07/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users : [User] = []
    
    var cellColors = ["F28044","F0A761","FEC362","F0BB4C","E3CB92","FEA375"]
    
    @IBOutlet var tab: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let snap = snapshot.value as? [String: AnyObject]
            print("snapshot\(snap?["email"] as! String)")
            let user = User()
            user.email = snap?["email"] as! String
            user.uId = snapshot.key
            self.users.append(user)
            
            self.tab.reloadData()
            
        })
       
        tab.delegate = self
        tab.dataSource = self
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let u = users[indexPath.row]
        cell.textLabel?.text = u.email
        cell.textLabel?.backgroundColor = UIColor(colorLiteralRed: 52, green: 152, blue: 219, alpha: 1)
        return cell
    }
    
    //when a user is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let u = users[indexPath.row]
        
        let snap = ["from" : u.email, "description" : "", "imageUrl" : ""]
        
        FIRDatabase.database().reference().child("users").child(u.uId).child("snaps").childByAutoId().setValue(snap)
    }

}
