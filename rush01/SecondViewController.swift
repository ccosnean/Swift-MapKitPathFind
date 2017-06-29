//
//  SecondViewController.swift
//  day05
//
//  Created by Cristian Cosneanu on 4/26/17.
//  Copyright © 2017 Cristian Cosneanu. All rights reserved.
//

import UIKit
import CoreLocation

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!

    func diableSwitches(){
        for j in stride(from: 0, to: AppDelegate.switches.count, by: 1) {
            AppDelegate.switches[j].setOn(false, animated: true)
        }
    }
    
    @IBAction func RouteFromCurentLocation(_ sender: Any) {
        if AppDelegate.FirstLocation != nil
        {
            AppDelegate.boo = true
            tabBarController?.selectedIndex = 0
        }
    }

    
    func countSwitches() -> Int
    {
        var k = 0
        for j in stride(from: 0, to: AppDelegate.switches.count, by: 1) {
            if AppDelegate.switches[j].isOn {
                k += 1
            }
        }
        return k
    }
    
    @IBAction func selectSwitch(_ sender: Any) {
        let index = (sender as AnyObject).tag!
        let loc = AppDelegate.pins[index]
        
        if self.countSwitches() == 1
        {
            AppDelegate.FirstLocation = CLLocationCoordinate2D(latitude: loc.coordinate_x, longitude: loc.coordinate_y)
        }
        else if self.countSwitches() == 2
        {
            AppDelegate.SecondLocation = CLLocationCoordinate2D(latitude: loc.coordinate_x, longitude: loc.coordinate_y)
            AppDelegate.notDrawed = true
            self.diableSwitches()
            tabBarController?.selectedIndex = 0
        }
        if self.countSwitches() > 2
        {
            AppDelegate.FirstLocation = nil
            AppDelegate.SecondLocation = nil
            AppDelegate.notDrawed = true
            self.diableSwitches()
            AppDelegate.switches[index].setOn(true, animated:true)
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        AppDelegate.switches.removeAll()
        self.tableView.reloadData()
    }
    
    @IBAction func delLocation(_ sender: Any) {
        AppDelegate.pins.remove(at: (sender as AnyObject).tag)
        self.diableSwitches()
        AppDelegate.switches.removeAll()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.contentInset = UIEdgeInsets.zero

        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SecondViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                AppDelegate.selectedIndex = indexPath.row
                performSegue(withIdentifier: "editLocation", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.pins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delBTN.layer.cornerRadius = 15
        cell.location.text = AppDelegate.pins[indexPath.row].name
        cell.address.text = AppDelegate.pins[indexPath.row].title
        cell.delBTN.tag = indexPath.row
        cell.swit.tag = indexPath.row
        AppDelegate.switches.append(cell.swit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FirstViewController.pinNr = indexPath.row
        tabBarController?.selectedIndex = 0
    }
    
}

