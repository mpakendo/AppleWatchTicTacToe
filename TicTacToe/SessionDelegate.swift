//
//  SessionDelegate.swift
//  TicTacToe
//
//  Created by Martin on 15.10.17.
//  Copyright © 2017 akendoo. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity

class SessionDelegate: NSObject, WCSessionDelegate {
    
    
    
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) { }
    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("IOS: DID RECEIVE APP CONTEXT")
        let defaults = UserDefaults.init()
        if let playerWinCount = applicationContext["playerWinCount"] as? Int {
            defaults.set(playerWinCount, forKey: "playerWinCount")
            NotificationCenter.default.post(name: Notification.Name("ApplicationContextChanged"), object: nil)
        }
        if let watchWinCount = applicationContext["watchWinCount"] as? Int {
            defaults.set(watchWinCount, forKey: "watchWinCount")
            NotificationCenter.default.post(name: Notification.Name("ApplicationContextChanged"), object: nil)
        }
        if let drawCount = applicationContext["drawCount"] as? Int {
            defaults.set(drawCount, forKey: "drawCount")
            NotificationCenter.default.post(name: Notification.Name("ApplicationContextChanged"), object: nil)
        }
    }
    
    
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let request = message["request"] as? String
        let defaults = UserDefaults.init()
        if request == "getOpponentStrongFlag" {
            replyHandler(["opponentStrong": defaults.bool(forKey: "opponentStrong")])
        }
    }
    
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) {
    }
    
    
    #if os(watchOS)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject], error: Error?) {
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
      let defaults = UserDefaults.init()
      if let strength = applicationContext["opponentStrong"] as? Bool {
        defaults.set(strength, forKey: "opponentStrong")
        NotificationCenter.default.post(name: Notification.Name("ApplicationContextChangedOnWatch"), object: nil)
      }
    
      if let playerWinCount = applicationContext["playerWinCount"] as? Int {
        defaults.set(playerWinCount, forKey: "playerWinCount")
      }
      if let watchWinCount = applicationContext["watchWinCount"] as? Int {
        defaults.set(watchWinCount, forKey: "watchWinCount")
      }
      if let drawCount = applicationContext["drawCount"] as? Int {
       defaults.set(drawCount, forKey: "drawCount")
      }
    
    }
    #endif
    
    
 
}


