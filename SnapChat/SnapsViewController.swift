//
//  SnapsViewController.swift
//  SnapChat
//
//  Created by JOHN KENNY on 29/07/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    //array of snaps
    var snaps : [Snap] = []
    
    
    @IBOutlet var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        // get all the users snaps
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let snap = snapshot.value as? [String: AnyObject]
            print("snapshot2\(snapshot)")
            
            let s = Snap()
            s.from = snap?["from"] as! String
            s.des = snap?["description"] as! String
            s.imageUrl = snap?["imageUrl"] as! String
            print("snapshot2\(s.from)")
            print("snapshot2\(s.des)")
            print("snapshot2\(s.imageUrl)")
            
            self.snaps.append(s)
            
            self.table.reloadData()
        })
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnap", sender: snap)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = snaps[indexPath.row].from
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnap"{
            let next = segue.destination as! SnapViewController
            next.snap = sender as! Snap
        }
        
    }
    
    
    
    
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true) {
            //
        }
    }
    
}
