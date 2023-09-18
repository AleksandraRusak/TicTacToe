//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-13.
//

import UIKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPlayer1Name: UILabel!
    @IBOutlet weak var lblPlayer2Name: UILabel!
    @IBOutlet weak var lblPlayer1Score: UILabel!
    @IBOutlet weak var lblPlayer2Score: UILabel!
    @IBOutlet weak var btnReset: UIButton!
    
    
    @IBOutlet var imgBtns: [UIButton]!
    
    
    // Fördröjning för datorns drag.
    var timer: Timer?
    
    
    // values received
    var receivingName1: String?
    var receivingName2: String?
    var isComputerGame: Bool = false
    
    // Skapa en instans av spelet och sätta dess initiala värden. Game är en instans av TicTacToeGame-klassen
    var game: TicTacToeGame = TicTacToeGame(
        player1: Player(name: "Player 1", isTurn: true, score: 0, isComputer: false),
        player2: Player(name: "Player 2", isTurn: false, score: 0, isComputer: false))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame() //I detta fall anropar den setupGame-metoden för att förbereda spelet när vyn har laddats.
    }
    
    // setupGame-metoden används för att sätta upp spelet.
    func setupGame() {
        // Sätt etiketter med spelarnas namn.
        if let receivingName1 = receivingName1,
           let receivingName2 = receivingName2 {
            game.player1.name = receivingName1
            game.player2.name = receivingName2
            lblName.text = receivingName1
            lblPlayer1Name.text = game.player1.name
            lblPlayer2Name.text = game.player2.name
            if isComputerGame { game.player2.isComputer = true }
        }
    }
    
    
    // onPress-metoden anropas när en av spelcellerna (knappar) klickas på. Den bestämmer vilken cell som klickades på genom att antingen använda det skickade knappens tag-egenskap eller genom att anropa computerTurn (om det är datorns tur). Sedan anropas cellOnPress-metoden med taggen för att hantera draget.
    @IBAction func onPress(_ sender: UIButton) {
        
        var tag: Int?
        
        if game.player2.isComputer && game.isPlayerTurn[1] {
            tag = game.computerTurn()
        } else {
            tag = sender.tag
        }
        
        // cellOnPress(tag: tag ?? 0)
        
        switch tag {
        case 0: cellOnPress(tag: tag ?? 0)
        case 1: cellOnPress(tag: tag ?? 1)
        case 2: cellOnPress(tag: tag ?? 2)
        case 3: cellOnPress(tag: tag ?? 3)
        case 4: cellOnPress(tag: tag ?? 4)
        case 5: cellOnPress(tag: tag ?? 5)
        case 6: cellOnPress(tag: tag ?? 6)
        case 7: cellOnPress(tag: tag ?? 7)
        case 8: cellOnPress(tag: tag ?? 8)
        default: return
        }
    }
    
    // onReset-metoden används när återställningsknappen trycks. Den återställer spelets tillstånd genom att återställa variabler, rensa alla spelceller och uppdatera användargränssnittet för att visa rätt meddelanden och dölja återställningsknappen.
    @IBAction func onReset(_ sender: UIButton) {
        
        if let receivingName1 = receivingName1,
           let receivingName2 = receivingName2 {
            
            setupGame()
            
            blankAllCells(UIButtons: imgBtns)
            enableAllCells(UIButtons: imgBtns)
            
            lblTitle.text = "Turn to play:"
            lblName.text = getPlayerName(isPlayerTurn: game.isPlayerTurn, name1: receivingName1, name2: receivingName2)
            //btnReset.setImage(UIImage(named: "reset_game"), for: .normal)
            btnReset.isHidden = true

            game.onGameReset()
            
            // Prompts datorn att göra ett drag om datorn börjar.
            if game.player2.isComputer && game.isPlayerTurn[1] {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: autoPress(timer:))
            }
        }
    }
    
    
    
    // Den här funktionen körs när en cell klickas på.
    func cellOnPress(tag: Int) {
        
        if let receivingName1 = receivingName1,
           let receivingName2 = receivingName2 {
            
            game.isGameStarted = true
            
            if game.isGameStarted {
                btnReset.isHidden = false;

            }
            
            imgBtns[tag].setImage(getImage(isPlayerTurn: game.isPlayerTurn), for: .normal)
            game.isPlayerTurn = game.toggleTurn(isPlayerTurn: game.isPlayerTurn)
            lblName.text = getPlayerName(isPlayerTurn: game.isPlayerTurn, name1: receivingName1, name2: receivingName2)
            game.appendToPlayerArray(isPlayerTurn: game.isPlayerTurn, index: tag)
            
            // Inaktiverar den cell som klickades på.
            if game.isButtonTapped[tag] == false {
                game.isButtonTapped[tag] = true
                imgBtns[tag].isUserInteractionEnabled = false
            }
            
            // Kollar om någon har vunnit.
            if game.isPlayerTurn[0] {
                game.hasWon = game.checkIfWon(playerArray: game.player1Array)
            } else {
                game.hasWon = game.checkIfWon(playerArray: game.player2Array)
            }
            
            if game.hasWon {
                lblTitle.text = "Winner:"
                let winner = getWinnerName()
                
                if winner == 0 {
                    lblName.text = receivingName1
                } else if winner == 1 {
                    lblName.text = receivingName2
                } else {
                    lblName.text = "Error"
                }
                
                disableAllCells(UIButtons: imgBtns)
                game.updateScore()
                lblPlayer1Score.text = String(game.player1.score)
                lblPlayer2Score.text = String(game.player2.score)
                //btnReset.setImage(UIImage(named: "play_again"), for: .normal)
                game.isGameStarted = false
            }
            
            game.isDraw = game.checkIfDraw()
            
            if game.isDraw {
                lblTitle.text = ""
                lblName.text = "Draw"
                //btnReset.setImage(UIImage(named: "play_again"), for: .normal)
                disableAllCells(UIButtons: imgBtns)
                game.isGameStarted = false
            }
            
            // Promptar datorn att göra ett drag om spelet inte är över.
            if game.hasWon == false && game.isDraw == false && game.player2.isComputer {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: autoPress(timer:))
            }
        }
    }
    
    // Funktion för automatiskt datorns drag.
    func autoPress(timer: Timer) {
  let dummyButton = UIButton()
       onPress(dummyButton)
       // onPress(nil)
    }
    
    // Nedanstående funktioner hanterar gränssnittet.
    func getImage(isPlayerTurn: Array<Bool>) -> UIImage {
        if game.isPlayerTurn[0] {
            return UIImage(named: "o") ?? UIImage(named: "cell")!
        } else if game.isPlayerTurn[1] {
            return UIImage(named: "X") ?? UIImage(named: "cell")!
        }
        return UIImage(named: "cell") ?? UIImage(named: "cell")!
    }
    
    func getPlayerName(isPlayerTurn: Array<Bool>, name1: String, name2: String) -> String {
        if game.isPlayerTurn[0] {
            return name1
        } else if game.isPlayerTurn[1] {
            return name2
        }
        return "Error"
    }
    
    func getWinnerName() -> Int {
        if game.isPlayerTurn[0] {
            return 1
        } else if game.isPlayerTurn[1] {
            return 0
        }
        return 404
    }
    
    func disableAllCells(UIButtons: Array<UIButton>) {
        for button in UIButtons {
            button.isUserInteractionEnabled = false
            button.alpha = 0.8
        }
    }
    
    func enableAllCells(UIButtons: Array<UIButton>) {
        for button in UIButtons {
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
        }
    }
    
    func blankAllCells(UIButtons: Array<UIButton>) {
        for button in UIButtons {
            button.setImage(UIImage(named: "cell"), for: .normal)
        }
    }
}
