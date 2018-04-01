//
//  TicTacToeLogic.swift
//  TicTacToe
//
//  Created by Martin on 16.08.17.
//  Copyright © 2017 akendoo. All rights reserved.
//

import Foundation

class TicTacToeLogic {

    
    /* ticTacToe grid structure
     [[0.0, 0.1, 0.2],
      [1.0, 1.1, 1.2],
      [2.0 ,2.1, 2.2]]
     
     Lines
     
     [[----L 0 ----],
      [----L 1 ----],
      [----L 2 ----]]
     
     
     [[|, |, |],
      [L3,L4,L5],
      [|, |, |]]

     [[\L6,.,/],
     [.,  X, .],
     [ /L7,.,\]]
     
     Strategy as per Wikipedia article, not fully implemented yet.
     
     https://en.wikipedia.org/wiki/Tic-tac-toe
     
     Fork possibility detection for O:
     
     O--  ---
     ---  ---    Lines starting with O: a) L0, L6  b) L6, L5. Fork rule: one standard line plus diagonal free. Placement: opposite diagonal
     X--  X-O
     
     O--  --O
     ---  ---    Lines starting with O: a) L0, L3 b) L0, L5. Fork rule: Direct diagonal blocked. Placement: middle
     --X  X--
     
     Opposite corner rule: 0->2, 2->0
     
     Also see: https://blog.ostermiller.org/tic-tac-toe-strategy
     
    */
    
    let blankCell = 0
    let defaults = UserDefaults.init()
    
    enum CellType :Int {
      case  Blank = 0
      case  X, O
    }
    
    var grid = [[CellType]]()

    struct Coord {
        var x: Int
        var y: Int
    }
    
    struct CellCheck {
        var checkResult: BooleanLiteralType
        var successCoordinates: Coord
    }

    enum Line :Int {
        case L0 = 0
        case L1,L2,L3,L4,L5,L6,L7
        func coordinates() -> [Coord] {
        switch self {
            case .L0:
                return [Coord(x:0, y:0), Coord(x:0, y:1), Coord(x:0, y:2)]
            case .L1:
                return [Coord(x:1, y:0), Coord(x:1, y:1), Coord(x:1, y:2)]
            case .L2:
                return [Coord(x:2, y:0), Coord(x:2, y:1), Coord(x:2, y:2)]
            case .L3:
                return [Coord(x:0, y:0), Coord(x:1, y:0), Coord(x:2, y:0)]
            case .L4:
                return [Coord(x:0, y:1), Coord(x:1, y:1), Coord(x:2, y:1)]
            case .L5:
                return [Coord(x:0, y:2), Coord(x:1, y:2), Coord(x:2, y:2)]
            case .L6:
                return [Coord(x:0, y:0), Coord(x:1, y:1), Coord(x:2, y:2)]
            case .L7:
                return [Coord(x:2, y:0), Coord(x:1, y:1), Coord(x:0, y:2)]
            }
        }
    }
    
    let lines = [Line.L0,Line.L1,Line.L2,Line.L3,Line.L4,Line.L5,Line.L6,Line.L7]

    var firstMove = true
    
    init() {
        grid = [[CellType.Blank,CellType.Blank,CellType.Blank],
                [CellType.Blank,CellType.Blank,CellType.Blank],
                [CellType.Blank,CellType.Blank,CellType.Blank]]
        firstMove = true
    }
    
    func setX(x :Int,y :Int) {
        grid[x][y] = CellType.X
    }
    
    func checkForWin(cellType :CellType) -> BooleanLiteralType {
        for l in lines {
            var count = 0
            for c in l.coordinates() {
                if grid[c.x][c.y] == cellType {
                    count = count+1
                }
                if count == 3 {
                    return true
                }
            }
        }
        return false
    }
    
    func checkForDraw() -> BooleanLiteralType {
        var countBlank = 0
        for l in lines {
            var countX = 0
            var countO = 0
            for c in l.coordinates() {
                switch grid[c.x][c.y] {
                case CellType.X:
                    countX = countX + 1
                case CellType.O:
                    countO = countO + 1
                case CellType.Blank:
                    countBlank = countBlank + 1
                }
                if countX == 3 || countO == 3 {
                    return false
                }
            }
        }
        if countBlank == 0 {
            return true
        }
        return false
    }
    
    func checkForTwoInARow(line: Line, cellType :CellType) -> CellCheck {
        var result = CellCheck(checkResult: false, successCoordinates: Coord(x: -1, y: -1))
        var count = 0
        var countBlank = 0
            let crds = line.coordinates()
            for c in crds {
                if grid[c.x][c.y] == cellType {
                count = count+1
                }
                else if grid[c.x][c.y] == CellType.Blank {
                    countBlank = countBlank+1
                    result.successCoordinates = c
                }
            }
        if count == 2 && countBlank == 1 { //two in a row and one free
            result.checkResult = true
        }
        return result
    }
    
    func findBlankCells() -> [Coord] {
        var cells = [Coord]()
        var i = 0
        for row in grid {
            var j = 0
            for cell in row {
                if cell == CellType.Blank {
                    cells.append(Coord(x: i, y: j))
                }
             j = j + 1
            }
          i = i + 1
        }
        return cells
    }
    
    
    func findBlankCorners() -> [Coord] {
        let corners = [Coord(x:0, y:0), Coord(x:0, y:2), Coord(x:2, y:0), Coord(x:2, y:2)]
        var emptyCorners = [Coord]()
       //NSLog("New Corner Search\n")
        for c in corners {
            if grid[c.x][c.y] == CellType.X && grid[2-c.x][2-c.y] == CellType.Blank {
                emptyCorners.append(Coord(x: 2-c.x, y:2-c.y)) // Opposites
           //NSLog("Found X in \(c.x).\(c.y)")
           //NSLog("Opposite empty in \(2-c.x).\(2-c.y)")
            }
        }
        return emptyCorners
    }
    
    
    func defaultMoveO() -> Coord {
        var blankCells = findBlankCorners()
        var len = blankCells.count
        var moveCoord :Coord
        
        //NSLog("SMART MOVE O\n")

        if len > 0 && firstMove == true { //occupy corners only after first move
           firstMove = false
           moveCoord = blankCells[Int(arc4random_uniform(UInt32(len)))] //corner
           return moveCoord
        }
        else if grid[1][1] == CellType.Blank { // center
            firstMove = false
            moveCoord = Coord(x:1, y:1)
            return moveCoord
        }
        else
        {
            blankCells = findBlankCells()
            len = blankCells.count
            firstMove = false
            moveCoord = blankCells[Int(arc4random_uniform(UInt32(len)))] // random blank cell
            return moveCoord
        }
    }
    
    func defaultMoveOSimple() -> Coord {
        var blankCells = findBlankCells()
        let len = blankCells.count
        let moveCoord = blankCells[Int(arc4random_uniform(UInt32(len)))] // random blank cell
        firstMove = false
        //NSLog("SIMPLE MOVE O\n")
        return moveCoord
    }
    
    
    func moveO() -> Coord {
        
        let opponentStrong = defaults.bool(forKey:"opponentStrong")
        var moveCoord = opponentStrong ? defaultMoveO() : defaultMoveOSimple()
        var winCheck = CellCheck(checkResult: false, successCoordinates: moveCoord)
        var blockCheck = CellCheck(checkResult: false, successCoordinates: moveCoord)
        
    
        // Check for possible win
        for l in lines {
            winCheck = checkForTwoInARow(line: l, cellType: CellType.O)
            if winCheck.checkResult == true {
               moveCoord = winCheck.successCoordinates
               break
            }
        }
        if winCheck.checkResult  {
            return moveCoord
        }
        
        // Check for possible block
        for l in lines {
            blockCheck = checkForTwoInARow(line: l, cellType: CellType.X)
            if blockCheck.checkResult  {
                moveCoord = blockCheck.successCoordinates
                break
            }
        }
        
        if blockCheck.checkResult  {
            return moveCoord
        }
        return moveCoord
    }
    
    func opponentMove () -> Coord {
        let coord = moveO()
        
        grid[coord.x][coord.y] = CellType.O
        return coord
        
    }
    
    func checkMessage() -> String {
       
        var msg = "Next Move:\n"
        let moveCoords = moveO()        
         msg = msg + "Coord: \(moveCoords.x),\(moveCoords.y)"
        return msg
    }
    
}
