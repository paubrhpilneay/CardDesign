//
//  GetFirebaseData.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 16/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GetFirebaseData: UIViewController {
    
    var rootRef: FIRDatabaseReference!
    var email: String!
    var recos: String!
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var restraurants = [RestaurantModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        rootRef = FIRDatabase.database().reference()
        self.email = "abc@gmail.com"
        
        actInd.frame = CGRect(x:0.0, y:0.0, width:40.0,height: 40.0);
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(actInd)
        actInd.startAnimating()
        //signing in anonymously
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
          let userRef = FIRDatabase.database().reference(withPath: "users")
          userRef.observe(.value, with: { snapshot in
            let enumerator = snapshot.children
            // fetching recomendations for the signed in users
            //this is the point where we will check if there is no recomendations available then we will fetch from a static pool of data
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let childSnapshot = snapshot.childSnapshot(forPath: rest.key)
                let someValue = childSnapshot.value as? NSDictionary
                if (someValue?["email"] as? String ?? "" == self.email) {
                    self.recos = someValue?["recomendations"] as? String ?? ""
                    self.actInd.stopAnimating()
                }
            }
          })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When GET MY DATA is clicked
    @IBAction func hitServer(_ sender: Any) {
        self.actInd.startAnimating()
        let restrauArr = self.recos.components(separatedBy: ",")
        //fetching all restaurants which are there in the recomendations for the user
        for restrau in restrauArr {
          rootRef.child("restaurants").child(restrau).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let restaurant = RestaurantModel.init(snapshot: snapshot)
            self.restraurants.append(restaurant)
            if(self.restraurants.count == restrauArr.count) {
                self.actInd.stopAnimating()
                self.performSegue(withIdentifier: "move", sender: nil)
            }
          }) { (error) in
            print(error.localizedDescription)
          }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "move" {
            let tabBarC : MainTabBar = segue.destination as! MainTabBar
            tabBarC.restaurants = self.restraurants
        }
    }
}
