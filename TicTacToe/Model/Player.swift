//
//  Player.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-13.
//

import Foundation

struct Player {
    var name: String
    var isTurn: Bool
    var score: Int
    var isComputer: Bool
    
    // An init method used to create an instance of the player with initial values.
    init(name: String, isTurn: Bool, score: Int, isComputer: Bool) {
        self.name = name
        self.isTurn = isTurn
        self.score = score
        self.isComputer = isComputer
    }
}
