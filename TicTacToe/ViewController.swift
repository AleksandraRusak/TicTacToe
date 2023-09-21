//
//  ViewController.swift
//  TicTacToe
//
//  Created by Aleksandra Rusak on 2023-09-11.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imgX: UIImageView!
    @IBOutlet weak var imgO: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
                // Animation för den första bilden (upp och ner)
                animateImage(imgX, translationX: 0, translationY: -50)
                
                // Animation för den andra bilden (höger och vänster)
                animateImage(imgO, translationX: 50, translationY: 0)
            }
            
            private func animateImage(_ imageView: UIImageView, translationX: CGFloat, translationY: CGFloat) {
                UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat], animations: {
                    imageView.transform = CGAffineTransform(translationX: translationX, y: translationY)
                })
        
                
                
                // Animation för den första bilden (upp och ner)
                //            UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat], animations: {
                //                self.imgX.transform = CGAffineTransform(translationX: 0, y: -50)
                //            })
                //
                //            // Animation för den andra bilden (höger och vänster)
                //            UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat], animations: {
                //                self.imgO.transform = CGAffineTransform(translationX: 50, y: 0)
                //            })
        
        }
    
    
}

