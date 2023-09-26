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
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet var imgBtns: [UIButton]!
    
    
    // Delay for computer's move
    var timer: Timer?
    
    
    // Variables used to store player names, initially set to nil
    var receivingName1: String?
    var receivingName2: String?

    var isComputerGame: Bool = false
    
    // Create an instance of the game and set its initial values
    var game: TicTacToeGame = TicTacToeGame(
        player1: Player(name: "Player 1", isTurn: true, score: 0, isComputer: false),
        player2: Player(name: "Player 2", isTurn: false, score: 0, isComputer: false))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.layer.cornerRadius = 23
        setupGame()
    }
    
    // set up the game, including player names and whether it's a game against the computer.
    func setupGame() {
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
    
    
    // The onPress method is called when one of the game cells (buttons) is clicked.
    @IBAction func onPress(_ sender: UIButton) {
        
        // Declare a variable to store the tag of the clicked button
        var tag: Int?
        
        // If it's the computer's turn and the computer is the next player, use the computer's move
        if game.player2.isComputer && game.isPlayerTurn[1] {
            tag = game.computerTurn()
        } else {
            // Otherwise, use the tag associated with the clicked button.
            tag = sender.tag
        }
        
        // This part of the code handles which cell was clicked based on the button's tag
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
    

    
    @IBAction func onReset(_ sender: UIButton) {
        // Check if player names have been received
        if let receivingName1 = receivingName1,
           let receivingName2 = receivingName2 {
            
            // Reset the game state by running the setupGame method.
            setupGame()
            
            // Reset all game cells by clearing and enabling them.
            blankAllCells(UIButtons: imgBtns)
            enableAllCells(UIButtons: imgBtns)
            
            // Reset the title to "Turn to play:" and the current player's name.
            lblTitle.text = "Turn to play:"
            lblName.text = getPlayerName(isPlayerTurn: game.isPlayerTurn, name1: receivingName1, name2: receivingName2)
            
            btnReset.isHidden = true

            // Call the onGameReset method to reset the game logic
            game.onGameReset()
            
            // Prompt the computer to make a move if it starts
            if game.player2.isComputer && game.isPlayerTurn[1] {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: computerPress(timer:))
            }
        }
    }
    
    
    
    // This method handles the logic when a cell (button) is clicked.
    func cellOnPress(tag: Int) {
        // Check if player names have been received
        if let receivingName1 = receivingName1,
           let receivingName2 = receivingName2 {
            
            // Mark that the game has started.
            game.isGameStarted = true
            
            
            // Show the reset button if the game has started.
            if game.isGameStarted {
                btnReset.isHidden = false;
            }
            
            // Set the image on the clicked game cell based on the current player's turn
            imgBtns[tag].setImage(getImage(isPlayerTurn: game.isPlayerTurn), for: .normal)
            
            // Switch the turn to the other player
            game.isPlayerTurn = game.switchPlayerTurn(isPlayerTurn: game.isPlayerTurn)
            
            // Update the name of the current player
            lblName.text = getPlayerName(isPlayerTurn: game.isPlayerTurn, name1: receivingName1, name2: receivingName2)
            
            // Add the index of the clicked game cell to the current player's array
            game.appendToPlayerArray(isPlayerTurn: game.isPlayerTurn, index: tag)
            
            // Disable the cell that was clicked
            if game.isButtonTapped[tag] == false {
                game.isButtonTapped[tag] = true
                imgBtns[tag].isUserInteractionEnabled = false
            }
            
            // Check if there is a winner.
            if game.isPlayerTurn[0] {
                game.hasWon = game.checkIfWon(playerArray: game.player1Array)
            } else {
                game.hasWon = game.checkIfWon(playerArray: game.player2Array)
            }
            
            // If there is a winner, update the interface with the winner's name and score.
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
                
                // Disable all game cells and update the scores.
                disableAllCells(UIButtons: imgBtns)
                game.updateScore()
                lblPlayer1Score.text = String(game.player1.score)
                lblPlayer2Score.text = String(game.player2.score)
             
                game.isGameStarted = false
            }
            
            // Check if the game is a draw.
            game.isDraw = game.checkIfDraw()
            
            // If it's a draw, display a draw message.
            if game.isDraw {
                lblTitle.text = ""
                lblName.text = "Draw"
                disableAllCells(UIButtons: imgBtns)
                game.isGameStarted = false
            }
            
            // Prompt the computer to make a move if the game is not over.
            if game.hasWon == false && game.isDraw == false && game.player2.isComputer {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: computerPress(timer:))
            }
        }
    }
    
    
    // Function for the automatic computer move.
    func computerPress(timer: Timer) {
        
        if game.isPlayerTurn[1] && !game.hasWon && !game.isDraw {
            // Generate a random move for the computer player (player2).
            var randomMove = Int.random(in: 0...8)

            // Continue generating random moves until an available move is found (an unclicked game cell).
            while game.isButtonTapped[randomMove] {
                randomMove = Int.random(in: 0...8)
            }
            // Call cellOnPress with the calculated tag for the move.
            cellOnPress(tag: randomMove)
        }
    }
    
    
    
    // to retrieve the correct image (X or O) for the current player based on the current player turn.
    func getImage(isPlayerTurn: [Bool]) -> UIImage {
        if game.isPlayerTurn[0] {
            return UIImage(named: "X") ?? UIImage(named: "cell")!
        } else if game.isPlayerTurn[1] {
            return UIImage(named: "o") ?? UIImage(named: "cell")!
        }
        // If there is no valid player turn, return a default image ("cell").
        return UIImage(named: "cell") ?? UIImage(named: "cell")!
    }
    
    
    func getPlayerName(isPlayerTurn: [Bool], name1: String, name2: String) -> String {
        if game.isPlayerTurn[0] {
            return name1
        } else if game.isPlayerTurn[1] {
            return name2
        }
        // If there is no valid player turn, return "Error".
        return "Error"
    }
    
    
    func getWinnerName() -> Int? { //an optional Int? to represent the situation where no winner has been found
        if game.isPlayerTurn[0] { // 1 if player 1 wins
            return 1
        } else if game.isPlayerTurn[1] { // 0 if player 2 wins
            return 0
        }
        // nil if no winner has been found
        return nil
    }
    
    // to disable and dim all game cells (buttons)
    func disableAllCells(UIButtons: [UIButton]) {
        for button in UIButtons {
            button.isUserInteractionEnabled = false
            button.alpha = 0.7
        }
    }
    
    // to enable and reset the opacity of all game cells (buttons)
    func enableAllCells(UIButtons: [UIButton]) {
        for button in UIButtons {
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
        }
    }
    
    // to reset all game cells (buttons) to the default image ("cell").
    func blankAllCells(UIButtons: [UIButton]) {
        for button in UIButtons {
            button.setImage(UIImage(named: "cell"), for: .normal)
        }
    }
}
