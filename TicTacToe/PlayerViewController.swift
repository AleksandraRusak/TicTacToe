//
//  PlayerViewController.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-13.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // En klass som ärver från UIViewController för att hantera spelarvyn.
       
    // Outlets för att ansluta till gränssnittselement i storyboard.
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
    
    
    @IBAction func switchAction(_ sender: UISwitch) {
        // spel mot dator och spel mot spelare.
//        if sender.isOn {
//            isComputerGame = true
//            tfPlayer2.isHidden = true
//            imgResult.image = UIImage(named: "computer")
//            lblResult.text = "Game against computer"
//        } else {
//            isComputerGame = false
//            tfPlayer2.isHidden = false
//            imgResult.image = UIImage(named: "person")
//            lblResult.text = "Game against player"
//        }
        
        
        isComputerGame = sender.isOn
                tfPlayer2.isHidden = isComputerGame
                imgResult.image = UIImage(named: isComputerGame ? "computer" : "person")
                lblResult.text = isComputerGame ? "Game against computer" : "Game against player"
        
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Förberedelser inför övergången till spelvyn.
        if segue.identifier == gameSegue {
            let destinationVC = segue.destination as! GameViewController
            
            // Ange spelarnas namn och spelläge. kan bli tom
            if tfPlayer1.text == "" {
                tfPlayer1.text = "Player 1"
            }
            
            if tfPlayer2.text == "" {
                tfPlayer2.text = "Player 2"
            }
            
            // Kontrollera om det är ett datorspel eller ett tvåspelarsspel och skicka relevanta uppgifter till nästa vy.
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
