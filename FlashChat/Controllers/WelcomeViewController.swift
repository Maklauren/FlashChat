//
//  WelcomeViewController.swift
//  FlashChat
//
//  Created by Павел Черноок on 4.07.22.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!
    
    private var charIndex = 0.0
    
    private let appName = Key.appName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = ""
        
        for character in appName {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { _ in
                self.appNameLabel.text?.append(character)
            }
            
            self.charIndex += 1
        }
    }
}

