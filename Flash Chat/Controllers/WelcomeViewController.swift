//
//  WelcomeViewController.swift
//  Flash Chat
//
//  Created by Hanna Putiprawan on 1/24/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    // Hide navigation bar in the welcome screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // Unhide nagivation bar after this screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Animated app name
        titleLabel.text = ""
        let titleText = K.appName
        var charIndex = 0.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: (0.1 * charIndex), repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    

}
