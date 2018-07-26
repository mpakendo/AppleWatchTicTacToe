//
//  TicTacToeInterfaceController.swift
//  TicTacToe WatchKit Extension
//
//  Created by Martin on 11.08.17.
//  Copyright © 2017 akendoo. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class TicTacToeInterfaceController: WKInterfaceController {
    
    /* ticTacToe button structure
     [b00, b01, b02]
     [b10, b11, b12]
     [b20 ,b21, b22]
    */
    
    @IBOutlet weak var b00: WKInterfaceButton!
    @IBOutlet weak var b01: WKInterfaceButton!
    @IBOutlet weak var b02: WKInterfaceButton!

    @IBOutlet weak var b10: WKInterfaceButton!
    @IBOutlet weak var b11: WKInterfaceButton!
    @IBOutlet weak var b12: WKInterfaceButton!

    @IBOutlet weak var b20: WKInterfaceButton!
    @IBOutlet weak var b21: WKInterfaceButton!
    @IBOutlet weak var b22: WKInterfaceButton!

    @IBOutlet weak var startButton: WKInterfaceButton!

    
    let defaults = UserDefaults.init()
    let colorX = UIColor.orange
    let colorO = UIColor.cyan
    let colorBlank1 = UIColor.darkGray
    let colorBlank2 = UIColor.lightGray
    let colorBlue = UIColor.blue
    let colorGreen = UIColor.purple
    let colorMagenta = UIColor.magenta
    let colorYellow = UIColor.yellow
    let colorRed = UIColor.red
    var isWatchUIActive = false
    
    var buttonGrid = [[WKInterfaceButton]]()
    var buttonClickedGrid = [[BooleanLiteralType]]()
    var ticTacToe = TicTacToeLogic()
    
    func setStartButtonInit() {
        startButton.setBackgroundColor(colorBlue)
        startButton.setTitle("Start New")
    }
    
    func setStartButtonDraw() {
        startButton.setBackgroundColor(colorMagenta)
        startButton.setTitle("Draw. Play?")
    }

    func setStartButtonPlayerWins() {
        startButton.setBackgroundColor(colorGreen)
        startButton.setTitle("You win. Play?")
    }
    
    func setStartButtonWatchWins() {
        startButton.setBackgroundColor(colorRed)
        startButton.setTitle("I win. Play?")
    }

    func setOpponentButtonData (b: WKInterfaceButton) {
        b.setTitle("O")
        b.setBackgroundColor(colorO)
    }

    func incrementGameCount(key: String) {
        let count = defaults.integer(forKey: key)
        defaults.set(count+1, forKey: key)
        do {
            try WCSession.default.updateApplicationContext([key: count+1])
        }
        catch let error {
            NSLog("Error updating scores on iPhone: \(error).")
        }
    }
    
    func setButtonData (b: WKInterfaceButton) {
        b.setTitle("X")
        b.setBackgroundColor(colorX)
        if ticTacToe.checkForWin(cellType: TicTacToeLogic.CellType.X) {
            setStartButtonPlayerWins()
            incrementGameCount(key: "playerWinCount")
        }
        else if ticTacToe.checkForDraw() {
            setStartButtonDraw()
            incrementGameCount(key: "drawCount")
        }
        else {
            let c = ticTacToe.opponentMove()
            setOpponentButtonData(b: buttonGrid[c.x][c.y])
            buttonClickedGrid[c.x][c.y] = true
            if ticTacToe.checkForWin(cellType: TicTacToeLogic.CellType.O) {
                buttonClickedGrid = [[true, true, true],
                                     [true, true, true],
                                     [true ,true, true]]

                setStartButtonWatchWins()
                incrementGameCount(key: "watchWinCount")
            }
        }
    }
 
    func clearButtonData (b: WKInterfaceButton, color: UIColor) {
        b.setEnabled(true)
        b.setTitle("")
        b.setBackgroundColor(color)
    }
    
   
    @IBAction func b00Pressed() {
        if !buttonClickedGrid[0][0] {
            ticTacToe.setX(x: 0, y:0)
            setButtonData(b: b00)
            buttonClickedGrid[0][0] = true
        }
    }
    @IBAction func b01Pressed() {
        if !buttonClickedGrid[0][1] {
          ticTacToe.setX(x: 0, y:1)
          setButtonData(b: b01)
          buttonClickedGrid[0][1] = true
        }
    }
    @IBAction func b02Pressed() {
        if !buttonClickedGrid[0][2] {
            ticTacToe.setX(x: 0, y:2)
            setButtonData(b: b02)
            buttonClickedGrid[0][2] = true
        }
    }
    @IBAction func b10Pressed() {
        if !buttonClickedGrid[1][0] {
            ticTacToe.setX(x: 1, y:0)
            setButtonData(b: b10)
            buttonClickedGrid[1][0] = true
        }
    }
    @IBAction func b11Pressed() {
        if !buttonClickedGrid[1][1] {
            ticTacToe.setX(x: 1, y:1)
            setButtonData(b: b11)
            buttonClickedGrid[1][1] = true
        }
    }
    @IBAction func b12Pressed() {
        if !buttonClickedGrid[1][2] {
            ticTacToe.setX(x: 1, y:2)
            setButtonData(b: b12)
            buttonClickedGrid[1][2] = true
        }
    }
    @IBAction func b20Pressed() {
        if !buttonClickedGrid[2][0] {
            ticTacToe.setX(x: 2, y:0)
            setButtonData(b: b20)
            buttonClickedGrid[2][0] = true
        }
    }
    @IBAction func b21Pressed() {
        if !buttonClickedGrid[2][1] {
            ticTacToe.setX(x: 2, y:1)
            setButtonData(b: b21)
            buttonClickedGrid[2][1] = true
        }
    }
    @IBAction func b22Pressed() {
        if !buttonClickedGrid[2][2] {
            ticTacToe.setX(x: 2, y:2)
            setButtonData(b: b22)
            buttonClickedGrid[2][2] = true
        }
    }
    

    @IBAction func startPressed() {
         presentAlert(withTitle: "Starting game",
         message: "Tic, Tac, Toe!",
         preferredStyle: .alert,
         actions: [WKAlertAction(title: "Close", style: .default, handler:{})])
    }
    
    func recolorButtonsUponOpponentStrengthChange() {
         let opponentStrong = defaults.bool(forKey:"opponentStrong")
         let flatButtonGrid = self.buttonGrid.flatMap { $0 }
         let flatButtonClickedGrid = self.buttonClickedGrid.flatMap { $0 }
         let col = opponentStrong ? colorBlank1 : colorBlank2
         
         for (i, buttonClicked) in flatButtonClickedGrid.enumerated() {
           if !buttonClicked {
            clearButtonData(b: flatButtonGrid[i],color: col)
           }
         }
    }
    
    /* APP LIFECYCLE
     0) Initial event after installation: AWAKEWITHCONTEXT
     1) Event prior to opening the app: WILLACTIVATE
     2) Close the app: DIDDEACTIVATE
     3) App visible in favourites scroller: WILLACTIVATE
     4) Launch other app from favourites scroller: DIDDEACTIVATE
     5) Change data in iPhone app (Watch app not visible): WATCHOS RECEIVED APP CONTEXT
     6) Register changed application context: APPLICATIONCONTEXTCHANGEDONWATCH
     7) Open app on watch again: WILLACTIVATE
     
     Lifecycle for data:
     0) Awake with Context -> Data could have been updated on either side last. Exchange both ways and both sides discard oldest.
        a) OpponentStrong: Master data on phone (always).
        b) Win counts: written on both
     1) OpponentStrong changed -> what happens if the watch is not close by?
     2) Count Data changed -> ditto
     
     
    */
    
    @objc func applicationContextChangedOnWatch() {
        //NSLog("APPLICATIONCONTEXTCHANGEDONWATCH")
        OperationQueue.main.addOperation( {
            if self.isWatchUIActive {
                self.recolorButtonsUponOpponentStrengthChange() 
            }
        })
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //NSLog("AWAKEWITHCONTEXT")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationContextChangedOnWatch),
                                               name: Notification.Name("ApplicationContextChangedOnWatch"),
                                               object: nil)
        
        defaults.set(0, forKey: "playerWinCount")
        defaults.set(0, forKey: "watchWinCount")
        defaults.set(0, forKey: "drawCount")
        
        do {
            try WCSession.default.updateApplicationContext(["playerWinCount": 0])
            try WCSession.default.updateApplicationContext(["watchWinCount": 0])
            try WCSession.default.updateApplicationContext(["drawCount": 0])
        }
        catch let error {
            NSLog("Error updating scores on iPhone: \(error).")
        }
        
         /*
         WCSession.default.sendMessage(["request" : "getOpponentStrongFlag"],
         replyHandler: {(response: [String : Any]) -> Void in // layout  ["opponentStrong": true|false]
            self.defaults.set(response["opponentStrong"], forKey: "opponentStrong")
            let res = self.defaults.bool(forKey: "opponentStrong")
            NSLog("AWAKE - OPPONENTSTRONG FLAG :: \(res)")
         },
         errorHandler: {(error: Error) -> Void in
            self.defaults.set(false, forKey: "opponentStrong")
            NSLog("AWAKE - OPPONENTSTRONG FLAG :: \(error)")
         })
         */
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        // NSLog("WILLACTIVATE")
        super.willActivate()
        let opponentStrong = defaults.bool(forKey:"opponentStrong")
        
        buttonGrid = [[b00, b01, b02],
                      [b10, b11, b12],
                      [b20 ,b21, b22]]
        
        ticTacToe = TicTacToeLogic()
        
        buttonClickedGrid = [[false, false, false],
                             [false, false, false],
                             [false ,false, false]]
        
        let col = opponentStrong ? colorBlank1 : colorBlank2
        
        for buttonRow in buttonGrid {
            for button in buttonRow {
                clearButtonData(b: button, color: col)
            }
        }
        setStartButtonInit()
        self.isWatchUIActive = true
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        //NSLog("DIDDEACTIVATE")
        super.didDeactivate()
        self.isWatchUIActive = false
    }
    
    
}
