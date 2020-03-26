//
//  ViewController.swift
//  Flashcards
//
//  Created by Kevin Liu on 2/15/20.
//  Copyright © 2020 Kevin Liu. All rights reserved.
//

import UIKit

struct Flashcard
{
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var card: UIView!
    
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //read saved flashcards
        readSavedFlashcards()
        
        //adding inital flashcard if needed
        if flashcards.count == 0
        {
            updateFlashcard(question: "What's the capital of Brazil?", answer: "Brasilia")
        }
        else
        {
            updateLabels()
            updateNextPrevButtons()
        }
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
        flipFlashcard()
    }
    
    func flipFlashcard()
    {
        //move all code from didTapOnFlashcard to here
        frontLabel.isHidden=true;
        
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: { self.frontLabel.isHidden = true})
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //decrease current index
        currentIndex = currentIndex - 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //increase current index
        currentIndex = currentIndex + 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
        
        //animate
        animateCardOut()
    }
    
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        
        //do stuff here
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        
        //adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        
        //update current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        //update buttons
        updateNextPrevButtons()
        
        //update labels
        updateLabels()
        
        //update disk
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons()
    {
        //disable next button if at the end
        if currentIndex == flashcards.count-1
        {
            nextButton.isEnabled = false
        }
        else
        {
            nextButton.isEnabled = true
        }
        
        //disable prev button if at the beginning
        if currentIndex == 0
        {
            prevButton.isEnabled = false
        }
        else
        {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels()
    {
        //get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk()
    {
        //from flashcard array to dictionary array
        let dictionaryArray = flashcards.map
        {
            (card) -> [String: String] in return ["question": card.question, "answer": card.answer]
        }
        
        //save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //log it
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards()
    {
        //read dictionaryArray from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]
        {
            //in here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map
            {
                dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //put these flashcards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    func animateCardOut()
    {
        UIView.animate(withDuration: 0.3, animations: { self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)}, completion: { finished in
            
            //update labels
            self.updateLabels()
            
            //run in animation
            self.animateCardIn()})
    }
    
    func animateCardIn()
    {
        //start on right side
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3, animations: { self.card.transform = CGAffineTransform.identity})
    }
}

