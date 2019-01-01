//
//  SimpleMindInterfaceController.swift
//  TicTacToe WatchKit Extension
//
//  Created by Martin on 29.07.18.
//  Copyright © 2018 akendoo. All rights reserved.
//

import Foundation
import WatchKit

@available(watchOSApplicationExtension 4.0, *)
class SimpleMindInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var gameEntryTable: WKInterfaceTable!
    @IBOutlet weak var codeImage1: WKInterfaceImage!
    @IBOutlet weak var codeImage2: WKInterfaceImage!
    @IBOutlet weak var codeImage3: WKInterfaceImage!
    @IBOutlet weak var codeImage4: WKInterfaceImage!
    
    
    
     enum PegType :UInt32 {
       case  Empty
       case  Red, Green, Yellow, Blue, Magenta, Cyan
        func toString() -> String {
            switch self {
            case .Empty: return "greycircle"
            case .Red: return "redcircle"
            case .Green: return "greencircle"
            case .Yellow: return "yellowcircle"
            case .Blue: return "bluecircle"
            case .Magenta: return "magentacircle"
            case .Cyan: return "cyancircle"
            }
        }
     }
    
    enum ResultPegType :UInt32 {
        case Empty
        case Black,White
        func toString() -> String {
            switch self {
            case .Empty: return "E"
            case .Black: return "B"
            case .White: return "W" }
        }
    }
    
    struct Coord {
        var x: Int
        var y: Int
        func toString() -> String {return "(\(x),\(y))"}
    }
    
    struct ColorPeg {
        var peg: PegType
        var image: WKImage
        func toString() -> String {return peg.toString()}
    }
    
    var grid = [[PegType]]()
    var code = [PegType]()
    var attempts = [Bool]()
    var coordinates = Coord(x:0, y:0)
    var pickerDictionary = [WKInterfacePicker: Coord]()
    var pickerChoices = [ColorPeg]()
    
    
    static let blackResultPeg = "\u{26AB}" //medium black circle
    static let whiteResultPeg = "\u{26AA}" //medium white circle
    static let emptyResultPeg = ""
    
    public func startGame() {
        var pegSet = Set<PegType>()
        grid = [[PegType.Empty,PegType.Empty,PegType.Empty,PegType.Empty],
                [PegType.Empty,PegType.Empty,PegType.Empty,PegType.Empty],
                [PegType.Empty,PegType.Empty,PegType.Empty,PegType.Empty],
                [PegType.Empty,PegType.Empty,PegType.Empty,PegType.Empty],
                [PegType.Empty,PegType.Empty,PegType.Empty,PegType.Empty],
                [PegType.Empty,PegType.Empty,PegType.Empty,PegType.Empty]
        ]
        attempts = [false,false,false,false,false,false] // needs same # as grid
        code = [PegType]()
        while pegSet.count < 4 {
            let rnd = arc4random_uniform(UInt32(PegType.Cyan.rawValue)) + 1
            let randomPeg = PegType(rawValue: rnd)
            if  !(pegSet.contains(randomPeg!)) {
                pegSet.insert(randomPeg!)
                code.append(randomPeg!)
            }
        }
        codeImage1.setImageNamed("greycircle")
        codeImage2.setImageNamed("greycircle")
        codeImage3.setImageNamed("greycircle")
        codeImage4.setImageNamed("greycircle")
        
    }
    
    override init() {
      super.init()
        
       pickerChoices = [
            ColorPeg(peg: PegType.Red, image: WKImage(imageName: "redcircle")),
            ColorPeg(peg: PegType.Green, image: WKImage(imageName: "greencircle")),
            ColorPeg(peg: PegType.Yellow, image: WKImage(imageName: "yellowcircle")),
            ColorPeg(peg: PegType.Blue, image: WKImage(imageName: "bluecircle")),
            ColorPeg(peg: PegType.Magenta, image: WKImage(imageName: "magentacircle")),
            ColorPeg(peg: PegType.Cyan, image: WKImage(imageName: "cyancircle"))
        ]
    }
    
     
     override func awake(withContext context: Any?) {
        super.awake(withContext: context)
     }
    
     override func willActivate() {
        super.willActivate()
        gameEntryTable.setNumberOfRows(grid.count, withRowType: "GameEntryRow")
        for i in 0 ..< gameEntryTable.numberOfRows {
            guard let rowController = gameEntryTable.rowController(at: i)
                as? SimpleMindRowController else { continue }
            rowController.initRowData(interfaceController: self, forRow: i)
        }
        startGame()
     }
     
     override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    
    override func pickerDidFocus(_ picker: WKInterfacePicker) {
        coordinates = pickerDictionary[picker]!
        if grid[coordinates.x][coordinates.y] == PegType.Empty
            && attempts[coordinates.x] == false {
            let colorItems: [WKPickerItem] = pickerChoices.map { choice in
                let pickerItem = WKPickerItem()
                pickerItem.contentImage = choice.image
                return pickerItem
            }
            picker.setItems(colorItems)
            grid[coordinates.x][coordinates.y] = pickerChoices[0].peg
            
            guard let rowController = gameEntryTable.rowController(at: coordinates.x)
                as? SimpleMindRowController else { return }
            rowController.okButton.setEnabled(true)
        }
    }
    
    public func setPeg(index: Int){
        grid[coordinates.x][coordinates.y] = pickerChoices[index].peg
    }
    
    public func printGrid() {
       let _ = grid.map({ let _ = $0.map ({ print($0, terminator:" ") }) ; print("")})
       print("CODE: ")
       let _ = code.map ({print($0, terminator:" ")})
    }
    
    public func revealCodeIfDone(codeCrackedFlag: Bool) {
        
      let allAttempts = attempts.reduce(true, {$0 && $1})
        
        if allAttempts == true || codeCrackedFlag {
            let imageNames = code.map({$0.toString()})
            codeImage1.setImageNamed(imageNames[0])
            codeImage2.setImageNamed(imageNames[1])
            codeImage3.setImageNamed(imageNames[2])
            codeImage4.setImageNamed(imageNames[3])
        }
        
    }
    
    public func getPickerImages() -> [WKImage] {
        var results = [WKImage]()
        
        for i in 0...3 {
          results.append(WKImage(imageName: grid[coordinates.x][i].toString()))
        }
        
        return results
    }
    
    public func checkCode() -> [String] {
        var results = [SimpleMindInterfaceController.emptyResultPeg, SimpleMindInterfaceController.emptyResultPeg, SimpleMindInterfaceController.emptyResultPeg, SimpleMindInterfaceController.emptyResultPeg]
        var codeSet = Set<PegType>()
        var gridSet = Set<PegType>()
        
        for i in 0...3 {
            codeSet.insert(code[i])
            gridSet.insert(grid[coordinates.x][i])
        }
        
        let len = (codeSet.intersection(gridSet)).count - 1
  
        if len >= 0 {
            for i in 0...len {
                results[i] = SimpleMindInterfaceController.whiteResultPeg
            }
            
            var j = 0
            for i in 0...3 {
                if code[i]==grid[coordinates.x][i] {
                    results[j] = SimpleMindInterfaceController.blackResultPeg
                    j = j + 1
                }
            }
        }
        attempts[coordinates.x] = true
        return results
    }
    
}
