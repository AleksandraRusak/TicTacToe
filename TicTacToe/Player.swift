//
//  Player.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-13.
//

import Foundation

// Definiera en struktur som representerar en spelare i spelet.
struct Player {
    var name: String
    var isTurn: Bool
    var score: Int
    var isComputer: Bool
    
    // En init-metod som används för att skapa en instans av spelaren med initiala värden.
    init(name: String, isTurn: Bool, score: Int, isComputer: Bool) {
        self.name = name
        self.isTurn = isTurn
        self.score = score
        self.isComputer = isComputer
    }
}
