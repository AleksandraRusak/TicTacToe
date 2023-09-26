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
    
    
    // Fördröjning för datorns drag.
    var timer: Timer?
    
    
    // variabler används för att lagra namnen på spelarna. De är initialt satta till nil.
    var receivingName1: String?
    var receivingName2: String?

    var isComputerGame: Bool = false
    
    // Skapa en instans av spelet och sätta dess initiala värden. Game är en instans av TicTacToeGame-klassen
    var game: TicTacToeGame = TicTacToeGame(
        player1: Player(name: "Player 1", isTurn: true, score: 0, isComputer: false),
        player2: Player(name: "Player 2", isTurn: false, score: 0, isComputer: false))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.layer.cornerRadius = 23
        setupGame() //I detta fall anropar den setupGame-metoden för att förbereda spelet när vyn har laddats.
    }
    
    // setupGame-metoden används för  att ställa in spelet, inklusive spelarnas namn och om det är ett spel mot datorn.
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
        
        // Deklarera en variabel för att lagra taggen på den klickade knappen.
        var tag: Int?
        
        // Om det är datorns tur och datorn är nästa spelare, använd datorns drag.
        if game.player2.isComputer && game.isPlayerTurn[1] {
            tag = game.computerTurn()
        } else {
            // Annars, använd den tagg som är associerad med den klickade knappen.
            tag = sender.tag
        }
        
        // Den här delen av koden hanterar vilken cell som klickades på baserat på knappens tag. Den anropar cellOnPress(tag:) för att hantera draget.
        
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
        // Kontrollera om namnen på spelarna har mottagits och är giltiga.
        if let receivingName1 = receivingName1,
           let receivingName2 = receivingName2 {
            
            // Återställ spelets tillstånd genom att köra setupGame-metoden.
            setupGame()
            
            // Återställ alla spelceller genom att tömma dem och aktivera dem igen.
            blankAllCells(UIButtons: imgBtns)
            enableAllCells(UIButtons: imgBtns)
            
            // Återställ titeln till "Turn to play:" och aktuellt spelarnamn.
            lblTitle.text = "Turn to play:"
            lblName.text = getPlayerName(isPlayerTurn: game.isPlayerTurn, name1: receivingName1, name2: receivingName2)
            
            // Dölj återställningsknappen igen.
            btnReset.isHidden = true

            // Anropa onGameReset-metoden för att återställa spellogiken.
            game.onGameReset()
            
            // Prompts datorn att göra ett drag om datorn börjar.
            if game.player2.isComputer && game.isPlayerTurn[1] {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: computerPress(timer:))
            }
        }
    }
    
    
    
    // Denna metod hanterar logiken när en cell (knapp) klickas på. Den uppdaterar spelets tillstånd, kontrollerar om det finns en vinnare eller oavgjort, och uppdaterar användargränssnittet.
    func cellOnPress(tag: Int) {
        // Kontrollera om namnen på spelarna har mottagits och är giltiga.
        if let receivingName1 = receivingName1,
           let receivingName2 = receivingName2 {
            
            // Markera att spelet har startat.
            game.isGameStarted = true
            
            
            // Visa återställningsknappen om spelet har startat.
            if game.isGameStarted {
                btnReset.isHidden = false;
            }
            
            // Sätt bilden på den klickade spelcellen baserat på den aktuella spelarens tur.
            imgBtns[tag].setImage(getImage(isPlayerTurn: game.isPlayerTurn), for: .normal)
            
            // Byt tur till den andra spelaren.
            game.isPlayerTurn = game.switchPlayerTurn(isPlayerTurn: game.isPlayerTurn)
            
            // Uppdatera namnet på den aktuella spelaren.
            lblName.text = getPlayerName(isPlayerTurn: game.isPlayerTurn, name1: receivingName1, name2: receivingName2)
            
            // Lägg till den klickade spelcellens index i den aktuella spelarens array.
            game.appendToPlayerArray(isPlayerTurn: game.isPlayerTurn, index: tag)
            
            // Inaktivera den cell som klickades på.
            if game.isButtonTapped[tag] == false {
                game.isButtonTapped[tag] = true
                imgBtns[tag].isUserInteractionEnabled = false
            }
            
            // Kolla om någon har vunnit.
            if game.isPlayerTurn[0] {
                game.hasWon = game.checkIfWon(playerArray: game.player1Array)
            } else {
                game.hasWon = game.checkIfWon(playerArray: game.player2Array)
            }
            
            // Om någon har vunnit, uppdatera gränssnittet med vinnarens namn och poäng.
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
                
                // Inaktivera alla spelceller och uppdatera poängen.
                disableAllCells(UIButtons: imgBtns)
                game.updateScore()
                lblPlayer1Score.text = String(game.player1.score)
                lblPlayer2Score.text = String(game.player2.score)
             
                game.isGameStarted = false
            }
            
            // Kolla om spelet är oavgjort.
            game.isDraw = game.checkIfDraw()
            
            // Om spelet är oavgjort, visa meddelande om oavgjort.
            if game.isDraw {
                lblTitle.text = ""
                lblName.text = "Draw"
                disableAllCells(UIButtons: imgBtns)
                game.isGameStarted = false
            }
            
            // Promptar datorn att göra ett drag om spelet inte är över.
            if game.hasWon == false && game.isDraw == false && game.player2.isComputer {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: computerPress(timer:))
            }
        }
    }
    
    
    // Funktion för automatiskt datorns drag.
    func computerPress(timer: Timer) {
        
        // Kontrollera om det är datorns tur (player2) och att spelet inte har avgjorts (ingen har vunnit eller det är inte oavgjort).
        if game.isPlayerTurn[1] && !game.hasWon && !game.isDraw {
            // Generera ett slumpmässigt drag för datorspelaren (player2).
            var randomMove = Int.random(in: 0...8)

            // Fortsätt att generera slumpmässiga drag tills ett tillgängligt drag hittas (en spelcell som inte är klickad på).
            while game.isButtonTapped[randomMove] {
                randomMove = Int.random(in: 0...8)
            }
            // Anropa cellOnPress med den beräknade taggen för draget.
            cellOnPress(tag: randomMove)
        }
    }
    
    
    // Denna funktion används för att hämta rätt bild (X eller O) för den aktuella spelaren baserat på det aktuella dragets spelarvändning.
    
    func getImage(isPlayerTurn: [Bool]) -> UIImage {
        if game.isPlayerTurn[0] {
            return UIImage(named: "X") ?? UIImage(named: "cell")!
        } else if game.isPlayerTurn[1] {
            return UIImage(named: "o") ?? UIImage(named: "cell")!
        }
        // Om det inte finns någon giltig spelarvändning returneras en standardbild ("cell").
        return UIImage(named: "cell") ?? UIImage(named: "cell")!
    }
    
    // Denna funktion används för att hämta rätt spelarnamn baserat på den aktuella spelarvändningen.
    // Om det är spelare 1:s tur returneras namn1, och om det är spelare 2:s tur returneras namn2.
    func getPlayerName(isPlayerTurn: [Bool], name1: String, name2: String) -> String {
        if game.isPlayerTurn[0] {
            return name1
        } else if game.isPlayerTurn[1] {
            return name2
        }
        // Om det inte finns någon giltig spelarvändning returneras "Error".
        return "Error"
    }
    
    // Denna funktion används för att hämta indexet för den vinnande spelaren i spelet.
    // Om det är spelare 1 som vinner returneras 1, om det är spelare 2 som vinner returneras 0.
    func getWinnerName() -> Int? { // använder en optional Int? för att representera situationen där ingen vinnare har hittats
        if game.isPlayerTurn[0] { // 1 om spelare 1 har vunnit
            return 1
        } else if game.isPlayerTurn[1] { // 0 om spelare 2 har vunnit
            return 0
        }
        // nil om ingen vinnare har hittats
        return nil
    }
    
    // Denna funktion används för att inaktivera och dimma alla spelceller (knappar) som passerar i den medföljande arrayen.
    func disableAllCells(UIButtons: [UIButton]) {
        for button in UIButtons {
            button.isUserInteractionEnabled = false  // Inaktivera knappen.
            button.alpha = 0.7 // Sätt knappens opacitet för att dimma den.
        }
    }
    
    // Denna funktion används för att aktivera och återställa opaciteten för alla spelceller (knappar) som passerar i den medföljande arrayen.
    func enableAllCells(UIButtons: [UIButton]) {
        for button in UIButtons {
            button.isUserInteractionEnabled = true  // Aktivera knappen.
            button.alpha = 1.0  // Återställ knappens opacitet för att göra den fullt synlig.
        }
    }
    
    // Denna funktion används för att återställa alla spelceller (knappar) till standardbilden ("cell").
    func blankAllCells(UIButtons: [UIButton]) {
        for button in UIButtons {
            button.setImage(UIImage(named: "cell"), for: .normal)
        }
    }
}
