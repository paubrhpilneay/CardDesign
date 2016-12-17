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
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
          let userRef = FIRDatabase.database().reference(withPath: "users")
          userRef.observe(.value, with: { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let childSnapshot = snapshot.childSnapshot(forPath: rest.key)
                let someValue = childSnapshot.value as? NSDictionary
                if (someValue?["email"] as? String ?? "" == self.email) {
                    self.recos = someValue?["recomendations"] as? String ?? ""
                    self.actInd.stopAnimating()
                }
//                let someValue = childSnapshot.value["email"] as! [String:AnyObject]
//                if(someValue === email) {
//                
//                }
            }
          })
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitServer(_ sender: Any) {
        self.actInd.startAnimating()
        let restrauArr = self.recos.components(separatedBy: ",")
        var restraurants = [RestaurantModel]()
        for restrau in restrauArr {
          rootRef.child("restaurants").child(restrau).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
//            let value = snapshot.value as? NSDictionary
            let restaurant = RestaurantModel.init(snapshot: snapshot)
            restraurants.append(restaurant)
            if(restraurants.count == restrauArr.count) {
                self.actInd.stopAnimating()
                let cardViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                // Set "Hello World" as a value to myStringValue
                cardViewController.restaurants = restraurants
                
                // Take user to SecondViewController
                self.navigationController?.pushViewController(cardViewController, animated: true)
            }
            // ...
          }) { (error) in
            print(error.localizedDescription)
          }
        }
//        let restrauRef = rootRef.child("restaurants")
        
    }
}
