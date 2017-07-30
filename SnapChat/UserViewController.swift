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
import FirebaseAuth

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //snap data passed from previous segue
    var imageUrl = ""
    var descr = ""
    //used to hold all users
    var users : [User] = []
    
    var cellColors = ["F28044","F0A761","FEC362","F0BB4C","E3CB92","FEA375"]
    
    @IBOutlet var tab: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //get all users from the db
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let snap = snapshot.value as? [String: AnyObject]
            print("snapshot\(snap?["email"] as! String)")
            let user = User()
            user.email = snap?["email"] as! String
            user.uId = snapshot.key
            //adds the user if its not the curre
            if user.email != FIRAuth.auth()!.currentUser!.email{
                self.users.append(user)
            }
            //reload table
            self.tab.reloadData()
            
        })
        //
        tab.delegate = self
        tab.dataSource = self
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    //populate cells with users
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
        let snap = ["from" : FIRAuth.auth()!.currentUser!.email, "description" : descr, "imageUrl" : imageUrl]
        
        FIRDatabase.database().reference().child("users").child(u.uId).child("snaps").childByAutoId().setValue(snap)
        //return to root
        navigationController?.popToRootViewController(animated: true)
    }

}
