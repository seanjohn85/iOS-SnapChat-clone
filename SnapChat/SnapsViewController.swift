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
import FirebaseStorage

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
            s.UUID = snap?["UUID"] as! String
            print("snapshot2\(s.from)")
            print("snapshot2\(s.des)")
            print("snapshot2\(s.imageUrl)")
            s.key = snapshot.key
            
            self.snaps.append(s)
            
            self.table.reloadData()
        })
        
        // listens for removed snaps
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            let snap = snapshot.value as? [String: AnyObject]
            print("snapshot2\(snapshot)")
            
            //remove the snap from the locally stored array
            var index  = 0
            for snap in self.snaps{
                if snap.key == snapshot.key{
                    self.snaps.remove(at: index)
                    break
                }
                index += 1
 
            }
            
            self.table.reloadData()
        })
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnap", sender: snap)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0{
            cell.textLabel?.text = "You Have no snaps"
        }else{
            cell.textLabel?.text = snaps[indexPath.row].from
        }
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
