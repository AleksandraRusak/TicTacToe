//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-17.


// This class manages the game logic, including checking for a winner, a draw, etc.
import Foundation

class TicTacToeGame {
    var player1: Player
    var player2: Player
    
    // Constructor to create an instance of the game with two players.
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    // Arrays to track player turns, game status, and button clicks.
    var isPlayerTurn: [Bool] = [true, false] // true for player1, and false - player2.
    var isGameStarted = false
    var hasWon: Bool = false
    var isDraw = false
    
    // An array that keeps track of which cells have been clicked.
    var isButtonTapped: [Bool] = [false, false, false, false, false, false, false, false, false]
    
    var player1Array: [Int] = []
    var player2Array: [Int] = []
    
    var winConditions: [[Int]] = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]
    
    // Computer's turn logic.
    func computerTurn() -> Int {
        if hasWon || isDraw { return -1 }
        
        let randomInt = getRandomInt()
        if isButtonTapped[randomInt] == false {
            return randomInt
        }
        return computerTurn()
        
    }
    
    // Generate a random integer between 0 and 8.
    func getRandomInt() -> Int {
        let randomInt = Int.random(in: 0...8)
        return randomInt
    }

    // Switch player turns.
    func switchPlayerTurn(isPlayerTurn: [Bool]) -> [Bool] {
        return [isPlayerTurn[1], isPlayerTurn[0]]
    }
    
    // Add the index of a marked cell to the current player's array.
    func appendToPlayerArray(isPlayerTurn: [Bool], index: Int) {
        if isPlayerTurn[0] {
            player1Array.append(index)
        } else {
            player2Array.append(index)
        }
    }
    
    func checkIfWon(playerArray: [Int]) -> Bool {
        if playerArray.count < 3 { return false } // Checks if the player has fewer than 3 marked cells
            for winCondition in winConditions {
                if winCondition.allSatisfy(playerArray.contains) {
                    return true
                }
            }
        return false
    }
    
    // Check if the game is a draw.
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
    
    // Reset the game state
    func onGameReset() {
        isButtonTapped = [false, false, false, false, false, false, false, false, false]
        player1Array = []
        player2Array = []
        hasWon = false
        isDraw = false
    }
    
    // Update player scores
    func updateScore() {
        if isPlayerTurn[0] {
            player2.score += 1
        } else {
            player1.score += 1
        }
    }
}
