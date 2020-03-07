//
//  ViewController.swift
//  Flashcards
//
//  Created by Kevin Liu on 2/15/20.
//  Copyright © 2020 Kevin Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue destination is Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        //Navigation Controller only contains Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        //set flashcardsController property to self
        creationController.flashcardsController = self
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden=true;
    }
    
    func updateFlashcard(question: String, answer: String) {
        //do stuff here
        backLabel.text = answer
        frontLabel.text = question
    }
    
}

