//
//  SaveViewController.swift
//  day05
//
//  Created by Cristian Cosneanu on 4/26/17.
//  Copyright © 2017 Cristian Cosneanu. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController {
    
    func alert(title: String, message: String)
    {
        let alertTitle = title
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okBTN = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okBTN)
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBOutlet weak var pinname: UITextField!
    @IBOutlet weak var pinDescription: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pinname.text = AppDelegate.pins[AppDelegate.selectedIndex].name
        self.pinDescription.text = AppDelegate.pins[AppDelegate.selectedIndex].title
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func savePinAction(_ sender: Any) {
        AppDelegate.pins[AppDelegate.selectedIndex].name = self.pinname.text!
        AppDelegate.pins[AppDelegate.selectedIndex].title = self.pinDescription.text!
        self.alert(title: "Success", message: "Your location was saved succesifuly\n\nTitle:\(self.pinname.text!)\nDescription:\(self.pinDescription.text!)")
    }
}
