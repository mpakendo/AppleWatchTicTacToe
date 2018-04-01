//
//  ViewController.swift
//  TicTacToe
//
//  Created by Martin on 11.08.17.
//  Copyright © 2017 akendoo. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    
    @IBOutlet var opponentStrongSwitch: UISwitch!
    @IBOutlet var getInformationButton: UIButton!
    @IBOutlet var playerWinCount: UILabel!
    @IBOutlet var watchWinCount: UILabel!
    @IBOutlet var drawCount: UILabel!
    
    let defaults = UserDefaults.init()
    
   
    @objc func applicationContextChanged() {
        OperationQueue.main.addOperation( {
            //NSLog("ApplicationContextChanged")
            self.playerWinCount.text = String(self.defaults.integer(forKey: "playerWinCount"))
            self.watchWinCount.text = String(self.defaults.integer(forKey: "watchWinCount"))
            self.drawCount.text = String(self.defaults.integer(forKey: "drawCount"))
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opponentStrongSwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        opponentStrongSwitch.setOn(true, animated: true)
        defaults.set(true, forKey: "opponentStrong")
        
        playerWinCount.text = String(defaults.integer(forKey: "playerWinCount"))
        watchWinCount.text = String(defaults.integer(forKey: "watchWinCount"))
        drawCount.text = String(defaults.integer(forKey: "drawCount"))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationContextChanged),
                                               name: Notification.Name("ApplicationContextChanged"),
                                               object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func switchChanged(aSwitch: UISwitch) {
        var val: Bool
        if aSwitch.isOn {
            defaults.set(true, forKey: "opponentStrong")
            val = true
        }
        else {
            defaults.set(false, forKey: "opponentStrong")
            val = false
        }
        do {
            try WCSession.default.updateApplicationContext(["opponentStrong": val])
        }
        catch let error {
            NSLog("Error updating opponentStrong flag on watch: \(error).")
        }
    }
    
    func getOpponentStrong() -> Bool {
        return defaults.bool(forKey: "opponentStrong")
    }
    
    @IBAction func resetScores() {
        let alertController = UIAlertController(title: "Reset Scores", message: "Reset scores (Y/N)?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
            {(action) in
                self.defaults.set(0, forKey: "playerWinCount")
                self.defaults.set(0, forKey: "watchWinCount")
                self.defaults.set(0, forKey: "drawCount")
                self.playerWinCount.text = String(self.defaults.integer(forKey: "playerWinCount"))
                self.watchWinCount.text = String(self.defaults.integer(forKey: "watchWinCount"))
                self.drawCount.text = String(self.defaults.integer(forKey: "drawCount"))
                do {
                    try WCSession.default.updateApplicationContext(["playerWinCount": 0])
                    try WCSession.default.updateApplicationContext(["watchWinCount": 0])
                    try WCSession.default.updateApplicationContext(["drawCount": 0])
                }
                catch let error {
                    NSLog("Error updating scores on watch: \(error).")
                }
                
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func showInformationInAlert() {
        let alertController = UIAlertController(title: "Information on TicTacToe Settings", message: "Strong Opponent in User Defaults:\(getOpponentStrong())", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

