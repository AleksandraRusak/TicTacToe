//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-17.


//Den hanterar spelets logik, inklusive att avgöra om någon har vunnit, om spelet har slutat oavgjort osv.

import Foundation


// TicTacToeGame-klassen är en Swift-klass som har två spelare: player1 och player2. Dessa spelare representeras av objekt av Player-klassen.
class TicTacToeGame {
    var player1: Player
    var player2: Player
    
    // Konstruktor som skapar en instans av spelet med två spelare.
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    // En array som håller koll på vilken spelare som har tur.
    var isPlayerTurn: [Bool] = [true, false] // true representerar player1, och false - player2.
    var isGameStarted = false
    var hasWon: Bool = false
    var isDraw = false
    
    // En array som håller koll på vilka celler som har klickats på.
    var isButtonTapped: [Bool] = [false, false, false, false, false, false, false, false, false]
    
    // player1Array och player2Array är arrayer som håller koll på vilka celler varje spelare har markerat.
    var player1Array: [Int] = []
    var player2Array: [Int] = []
    
    // winConditions är en array av arrays som innehåller alla möjliga sätt att vinna spelet.
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
    
    // Datorns drag
    func computerTurn() -> Int {
        if hasWon || isDraw { return -1 } // om spelet redan har vunnits av en spelare eller har slutat oavgjort. I båda fallen returnerar funktionen omedelbart -1 för att indikera att datorspelaren inte ska göra fler drag.
        
        let randomInt = getRandomInt() // välja en slumpmässig cell
        if isButtonTapped[randomInt] == false {
            return randomInt
        } // Här kontrolleras om den slumpmässigt valda cellen inte har blivit tryckt
        return computerTurn() // Om den slumpmässigt valda cellen redan har blivit tryckt (dvs. isButtonTapped[randomInt] är true), anropar funktionen sig själv rekursivt (computerTurn()) för att försöka välja en annan slumpmässig cell tills den hittar en tillgänglig cell att göra ett drag på.
    }
    
    // getRandomInt-metoden genererar ett slumpmässigt heltal mellan 0 och 8.
    func getRandomInt() -> Int {
        let randomInt = Int.random(in: 0...8)
        return randomInt
    }

    // switchPlayerTurn-metoden används för att ändra turordningen mellan spelarna. Om isPlayerTurn är [true, false] kommer det att ändras till [false, true], och vice versa.
    func switchPlayerTurn(isPlayerTurn: [Bool]) -> [Bool] {
        var newTurn = isPlayerTurn
        // det är den första spelarens tur
        if newTurn[0] {
            newTurn = [false, true]
        } else if newTurn[1] { // det är den andra spelarens tur
            newTurn = [true, false]
        }
        return newTurn
    }
    
    // appendToPlayerArray-metoden används för att lägga till indexet för en markerad cell till den aktuella spelarens array (player1Array eller player2Array).
    func appendToPlayerArray(isPlayerTurn: [Bool], index: Int) {
        if isPlayerTurn[0] {
            player1Array.append(index)
        } else {
            player2Array.append(index)
        }
    }
    
    func checkIfWon(playerArray: [Int]) -> Bool {
        if playerArray.count < 3 { // kontrollerar om spelaren har färre än 3 markerade celler
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
    
    // Kontrollera om spelet är oavgjort.
    func checkIfDraw() -> Bool {
        var count = 0 // Här deklareras en variabel count som används för att räkna antalet knappar (spelceller) som har blivit klickade.
        // Här startar en loop som itererar genom arrayen isButtonTapped, som innehåller information om vilka spelceller som har blivit klickade.
        for tapped in isButtonTapped {
            if tapped == true { // betyder att den motsvarande spelcellen har blivit klickad.
                count += 1 // Om villkoret är sant, ökas värdet på count med 1. Detta innebär att om en spelcell har blivit klickad, kommer count att öka med 1.
            }
        }
        
        // Efter att loopen har slutförts, kontrolleras om count är lika med 9 (vilket är det totala antalet spelceller) och om hasWon är false. Om båda dessa villkor är sanna, innebär det att alla spelceller har blivit klickade och att ingen har vunnit spelet.
        if count == 9 && !hasWon {
            return true // Om villkoret är sant, returneras true, vilket indikerar att spelet har slutat i oavgjort (ingen har vunnit).
        }
        return false // Om något av de tidigare villkoren inte är uppfyllda, indikerar att spelet inte har slutat i oavgjort och fortsätter.
    }
    
    // Återställ spelets tillstånd.
    func onGameReset() {
        isButtonTapped = [false, false, false, false, false, false, false, false, false]
        player1Array = []
        player2Array = []
        hasWon = false
        isDraw = false
    }
    
    // Uppdatera spelarnas poäng.
    func updateScore() {
        if isPlayerTurn[0] {
            player2.score += 1
        } else {
            player1.score += 1
        }
    }
}
