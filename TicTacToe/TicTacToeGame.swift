//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-17.
//Den hanterar spelets logik, inklusive att avgöra om någon har vunnit, om spelet har slutat oavgjort och andra relevanta aspekter av spelet.

import Foundation
import UIKit

// TicTacToeGame-klassen är en Swift-klass som har två spelare: player1 och player2. Dessa spelare representeras av objekt av Player-klassen.
class TicTacToeGame {
    var player1: Player
    var player2: Player
    
// I init metoden, som är en konstruktor, skapar vi en instans av TicTacToeGame med två spelare som skickas som argument. Detta låter oss sätta spelarnas egenskaper när vi skapar ett nytt spel.
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    var isPlayerTurn: Array<Bool> = [true, false] // true representerar player1, och false - player2.
    var isGameStarted = false
    var hasWon: Bool = false
    var isDraw = false
    
     // isButtonTapped är en array som håller koll på vilka spelceller som har blivit tryckta.
    var isButtonTapped: Array<Bool> = [false, false, false, false, false, false, false, false, false]
    
    // player1Array och player2Array är arrayer som håller koll på vilka celler varje spelare har markerat.
    var player1Array: Array<Int> = []
    var player2Array: Array<Int> = []
    
    // winConditions är en array av arrays som innehåller alla möjliga sätt att vinna spelet.
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
    // getRandomInt-metoden returnerar ett slumpmässigt heltal mellan 0 och 8, som används av computerTurn för att välja en ledig cell.
    func getRandomInt() -> Int {
        let randomInt = Int.random(in: 0...8)
        return randomInt
    }

    // toggleTurn-metoden används för att ändra turordningen mellan spelarna. Om isPlayerTurn är [true, false] kommer det att ändras till [false, true], och vice versa.
    func toggleTurn(isPlayerTurn: Array<Bool>) -> Array<Bool> {
        var isPlayerTurn = isPlayerTurn
        
        if isPlayerTurn[0] {
            isPlayerTurn = [false, true]
        } else if isPlayerTurn[1] {
            isPlayerTurn = [true, false]
        }
        return isPlayerTurn
    }
    
    // appendToPlayerArray-metoden används för att lägga till indexet för en markerad cell till den aktuella spelarens array (player1Array eller player2Array).
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
