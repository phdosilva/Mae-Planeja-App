//
//  ViewController.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 09/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child("1").setValue(["username": "Name"])
        ref.child("users").child("2").setValue(["username": "Allyson"])
   
    }


}

