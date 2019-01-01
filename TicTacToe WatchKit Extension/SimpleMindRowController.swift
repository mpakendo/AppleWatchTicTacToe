//
//  SimpleMindRowController.swift
//  TicTacToe WatchKit Extension
//
//  Created by Martin on 29.07.18.
//  Copyright © 2018 akendoo. All rights reserved.
//

import WatchKit

@available(watchOSApplicationExtension 4.0, *)
class SimpleMindRowController: NSObject {
    
    
    var myInterfaceController: SimpleMindInterfaceController!

    @IBOutlet weak var colour1: WKInterfacePicker!
    @IBOutlet weak var colour2: WKInterfacePicker!
    @IBOutlet weak var colour3: WKInterfacePicker!
    @IBOutlet weak var colour4: WKInterfacePicker!
    
    @IBOutlet weak var result1: WKInterfaceLabel!
    @IBOutlet weak var result2: WKInterfaceLabel!
    @IBOutlet weak var result3: WKInterfaceLabel!
    @IBOutlet weak var result4: WKInterfaceLabel!
    
    
    @IBOutlet weak var okButton: WKInterfaceButton!
    
    
    let initialPickerChoices = [
        SimpleMindInterfaceController.ColorPeg(peg: SimpleMindInterfaceController.PegType.Empty, image:WKImage(imageName: "blackcircle"))]
    
    func initRowData(interfaceController: SimpleMindInterfaceController , forRow: Int) {
        result1.setText("")
        result2.setText("")
        result3.setText("")
        result4.setText("")
      
        if myInterfaceController == nil {
            myInterfaceController = interfaceController
        }
        
         let img = WKImage(imageName: "greycircle")
         let itm = WKPickerItem()
         itm.contentImage = img
         colour1.setItems([itm])
         colour2.setItems([itm])
         colour3.setItems([itm])
         colour4.setItems([itm])
        
        interfaceController.pickerDictionary[colour1] = SimpleMindInterfaceController.Coord(x:forRow, y: 0)
        interfaceController.pickerDictionary[colour2] = SimpleMindInterfaceController.Coord(x:forRow, y: 1)
        interfaceController.pickerDictionary[colour3] = SimpleMindInterfaceController.Coord(x:forRow, y: 2)
        interfaceController.pickerDictionary[colour4] = SimpleMindInterfaceController.Coord(x:forRow, y: 3)
        
        okButton.setEnabled(false)
    }
    
    func setThePeg(forColorIndex: Int) {
        let interface = WKExtension.shared().visibleInterfaceController as! SimpleMindInterfaceController
        interface.setPeg(index: forColorIndex)
        okButton.setEnabled(true)
    }
    
     @IBAction func colour1PickerDidChange(selectedIndex i: Int) {
        setThePeg(forColorIndex: i)
     }
    
    @IBAction func colour2PickerDidChange(selectedIndex i: Int) {
         setThePeg(forColorIndex: i)
    }
    
    @IBAction func colour3PickerDidChange(selectedIndex i: Int) {
         setThePeg(forColorIndex: i)
    }
    
    @IBAction func colour4PickerDidChange(selectedIndex i: Int) {
         setThePeg(forColorIndex: i)
    }
   
 
    @IBAction func okPressed() {
        let interface = WKExtension.shared().visibleInterfaceController as! SimpleMindInterfaceController
        let r = interface.checkCode()
        let codeCracked = r.map({ $0 == SimpleMindInterfaceController.blackResultPeg}).reduce(true, {$0 && $1})
        //interface.printGrid()
        
        result1.setText(r[0])
        result2.setText(r[1])
        result3.setText(r[2])
        result4.setText(r[3])
        
        let imgs = interface.getPickerImages()
        var items = [WKPickerItem]()
        
        for img in imgs {
            let itm = WKPickerItem()
            itm.contentImage = img
            items.append(itm)
        }
        
        colour1.setItems([items[0]])
        colour1.resignFocus()
        colour1.setEnabled(false)
        colour2.setItems([items[1]])
        colour2.resignFocus()
        colour2.setEnabled(false)
        colour3.setItems([items[2]])
        colour3.resignFocus()
        colour3.setEnabled(false)
        colour4.setItems([items[3]])
        colour4.resignFocus()
        colour4.setEnabled(false)
        okButton.setEnabled(false)
        
        interface.revealCodeIfDone(codeCrackedFlag: codeCracked)
    }
    
        
}
