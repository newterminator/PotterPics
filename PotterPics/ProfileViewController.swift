//
//  ProfileViewController.swift
//  PotterPics
//
//  Created by Suraya Shivji on 12/6/16.
//  Copyright © 2016 Suraya Shivji. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    var user: FIRUser?
    var uid: String?
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    @IBOutlet weak var numPostsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var proileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let stripCol = defaults.colorForKey(key: "navCol")
        self.view.backgroundColor = stripCol
        user = FIRAuth.auth()?.currentUser
        uid = user?.uid
        configureHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureHeader() {
        let uid = self.uid
        var profPicURL: String = ""
        var name: String = "Name"
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            // set name label
            name = value?["name"] as! String
            self.nameLabel.text = name
            
            profPicURL = value?["profPicString"] as! String
            // set image
            if profPicURL.characters.count > 0 {
                let url = URL(string: profPicURL)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)?.circle
                        self.proileImageView.contentMode = UIViewContentMode.scaleAspectFill
                        self.proileImageView.image = image
                    }
                }
            } else {
                let image = UIImage(named: "default")?.circle
                self.proileImageView.contentMode = UIViewContentMode.scaleAspectFill
                self.proileImageView.image = image
            }
            
            // set num posts label
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // set num posts
        self.numPostsLabel.text = "17 Posts"
    }
    
    
    func generateImage(urlString: String) -> UIImage? {
        let url = URL(string: urlString)
        var image: UIImage = UIImage()
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                image = UIImage(data: data!)!
            }
        }
        return image
    }

}