//
//  PlayerViewController.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-13.
//

import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var imgResult: UIImageView!
    @IBOutlet weak var tfPlayer1: UITextField!
    @IBOutlet weak var tfPlayer2: UITextField!
    @IBOutlet weak var switchComputer: UISwitch!
    
    
    var isComputerGame: Bool = false
    
    let gameSegue: String = "gameSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btnPlay(_ sender: Any) {
    }
    
    // Switch between playing against the computer and playing against a player.
    @IBAction func switchAction(_ sender: UISwitch) {
        isComputerGame = sender.isOn
                tfPlayer2.isHidden = isComputerGame
                imgResult.image = UIImage(named: isComputerGame ? "computer" : "person")
                lblResult.text = isComputerGame ? "Game against computer" : "Game against player"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == gameSegue {
            let destinationVC = segue.destination as! GameViewController
            
            // Set players' names (can be empty)
            if tfPlayer1.text == "" {
                tfPlayer1.text = "Player 1"
            }
            
            if tfPlayer2.text == "" {
                tfPlayer2.text = "Player 2"
            }
            
            // Check if it's a game with computer or a two-player game and send relevant information to the next view
            if isComputerGame {
                destinationVC.isComputerGame = true
                destinationVC.receivingName1 = tfPlayer1.text
                destinationVC.receivingName2 = "Computer"
            } else {
                destinationVC.isComputerGame = false
                destinationVC.receivingName1 = tfPlayer1.text
                destinationVC.receivingName2 = tfPlayer2.text
            }
             
        }
    }
        

}
