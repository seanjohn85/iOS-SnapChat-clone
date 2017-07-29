//
//  PicViewController.swift
//  SnapChat
//
//  Created by JOHN KENNY on 29/07/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //UI outlets
    @IBOutlet var des: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var nextbtn: UIButton!
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
    }

    
    @IBAction func camera(_ sender: Any) {
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        nextbtn.isEnabled = false
        
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        
        
        let folder =  FIRStorage.storage().reference().child("images")
        folder.child("\(NSUUID().uuidString).jpg").put(imageData, metadata: nil) { (metaData, error) in
            //
            if error != nil{
                print("error upload \(error)")
            }else{
                print("URL \(metaData?.downloadURL())")
                
                self.performSegue(withIdentifier: "selectUser", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    
        
        
    
    }
    
    
    //select image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = img
        imageView.backgroundColor = UIColor.clear
        picker.dismiss(animated: true, completion: nil)
    }

}
