//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-17.
//

import Foundation
import UIKit

class TicTacToeGame {
    var player1: Player
    var player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    var isPlayerTurn: Array<Bool> = [true, false]
    var isGameStarted = false
    var hasWon: Bool = false
    var isDraw = false
    
    var isButtonTapped: Array<Bool> = [false, false, false, false, false, false, false, false, false]
    
    var player1Array: Array<Int> = []
    var player2Array: Array<Int> = []
    
    var winConditions: Array<Array<Int>> = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]
    
    // Datorns drag
    func computerTurn() -> Int {
        if hasWon || isDraw { return -1 }
        
        let randomInt = getRandomInt()
        if isButtonTapped[randomInt] == false {
            return randomInt
        }
        return computerTurn()
    }
    
    func getRandomInt() -> Int {
        let randomInt = Int.random(in: 0...8)
        return randomInt
    }

    // Metoder för spelets logik
    func toggleTurn(isPlayerTurn: Array<Bool>) -> Array<Bool> {
        var isPlayerTurn = isPlayerTurn
        
        if isPlayerTurn[0] {
            isPlayerTurn = [false, true]
        } else if isPlayerTurn[1] {
            isPlayerTurn = [true, false]
        }
        return isPlayerTurn
    }
    
    func appendToPlayerArray(isPlayerTurn: Array<Bool>, index: Int) {
        if isPlayerTurn[0] {
            player1Array.append(index)
        } else {
            player2Array.append(index)
        }
    }
    
    func checkIfWon(playerArray: Array<Int>) -> Bool {
        if playerArray.count < 3 {
            return false
        } else {
            for winCondition in winConditions {
                if winCondition.allSatisfy(playerArray.contains) {
                    return true
                }
            }
        }
        return false
    }
    
    func checkIfDraw() -> Bool {
        var count = 0
        for tapped in isButtonTapped {
            if tapped == true {
                count += 1
            }
        }
        if count == 9 && !hasWon {
            return true
        }
        return false
    }
    
    func onGameReset() {
        isButtonTapped = [false, false, false, false, false, false, false, false, false]
        player1Array = []
        player2Array = []
        hasWon = false
        isDraw = false
    }
    
    func updateScore() {
        if isPlayerTurn[0] {
            player2.score += 1
        } else {
            player1.score += 1
        }
    }
}
