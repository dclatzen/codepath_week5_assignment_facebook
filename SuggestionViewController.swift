//
//  SuggestionViewController.swift
//  recommended_cards_proto
//
//  Created by StudyBlue on 10/28/16.
//  Copyright © 2016 myself. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController {
    
    @IBOutlet weak var suggestedCardParentView: UIView!
    @IBOutlet weak var suggestedCardTray: UIImageView!
    @IBOutlet weak var deckCardParentView: UIView!
    @IBOutlet weak var replaceIcon: UIImageView!
    @IBOutlet weak var dummyCard: UIImageView!
    
    // outlets for all suggested cards
    
    
    // Suggestion Group 0
    @IBOutlet weak var suggestedCardB0: UIImageView!
    @IBOutlet weak var suggestedCardB1: UIImageView!
    @IBOutlet weak var suggestedCardB2: UIImageView!
    @IBOutlet weak var suggestedCardB3: UIImageView!
    
    
    // Suggestion Group 1
    @IBOutlet weak var suggestedCard0: UIImageView!
    @IBOutlet weak var suggestedCard1: UIImageView!
    @IBOutlet weak var suggestedCard2: UIImageView!
    @IBOutlet weak var suggestedCard3: UIImageView!
    

    
    // Suggestion Group 2
    @IBOutlet weak var suggestedCardC0: UIImageView!
    @IBOutlet weak var suggestedCardC1: UIImageView!
    @IBOutlet weak var suggestedCardC2: UIImageView!
    @IBOutlet weak var suggestedCardC3: UIImageView!
    
    
    
    // outlets for all deck cards
    
    @IBOutlet weak var deckCard0: UIImageView!
    @IBOutlet weak var deckCard1: UIImageView!
    @IBOutlet weak var deckCard2: UIImageView!
    
    
    
    // set up initial positions of the suggestion parent
    var suggestedParentOriginalX: CGFloat!
    var suggestedParentOriginalY: CGFloat!
    var permanentSuggestedParentOriginalX: CGFloat!
    
    // tray movement
    var suggestedTrayOriginalY: CGFloat!
    var suggestedTrayUp: CGFloat!
    var suggestedTrayDown: CGFloat!
    var suggestionOffset: CGFloat!
    
    // move the suggestions simultaneously with with the tray
    var suggestedParentUp: CGFloat!
    var suggestedParentDown: CGFloat!
    
    // horizontal panning in suggested parent
    var halfWay: CGFloat!
    var didPanHalfWayRight: Bool!
    var didPanHalfWayLeft: Bool!
    
    // drag and drop
    var duplicatedCard: UIImageView!
    var duplicatedCardOriginalCenter: CGPoint!
    var replacingDeckCard: Bool!
    var addingDeckCard: Bool!
    var deckTarget: CGPoint!
    
    // Deck card variables
    var deckParentOriginalX: CGFloat!
    var currentDeckCard: UIImageView!
    var currentDeckCardIndex: Int!
    var deckCards: [UIImageView]!
    
    // Suggestion variables
    var currentSuggestedCard: UIImageView!
    
    var suggestions0: [UIImageView]! // suggestions based on second card
    var suggestions1: [UIImageView]! // suggestions based on first card
    var suggestions2: [UIImageView]! // suggestions based on third card
    
    var currentSuggestedCardIndex: Int!
    var currentSuggestionArrayIndex: Int!
    var allSuggestionArrays: [[UIImageView]]! // a parent array containing each suggestion array
    var currentSuggestionArray: [UIImageView]! // displays the current suggestions
    
    // establish concept of a "current deck card" in the deck area
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        suggestedParentOriginalX = suggestedCardParentView.center.x
        permanentSuggestedParentOriginalX = suggestedParentOriginalX
        
        replaceIcon.alpha = 0
        dummyCard.isHidden = true
        
        
        //// Deck Cards: set up array, define 'current'////
        // Set up the array of deck cards
        
        deckCards = [deckCard0, deckCard1, deckCard2]
        currentDeckCardIndex = 1
        currentDeckCard = deckCards[currentDeckCardIndex]
        
        print ("Before: deckCardParentView.center.x = \(deckCardParentView.center.x)")
        
        deckParentOriginalX = deckCardParentView.center.x
        deckCardParentView.center.x = deckParentOriginalX - ((currentDeckCard.frame.width + 2) * CGFloat(currentDeckCardIndex))
        
        print ("After: deckCardParentView.center.x = \(deckCardParentView.center.x)")
        
        //// Suggestions: set up array, define 'current'////
        // Set up all of my potential groups of suggested cards
    
        suggestions0 = [suggestedCardB0, suggestedCardB1, suggestedCardB2, suggestedCardB3]
        suggestions1 = [suggestedCard0, suggestedCard1, suggestedCard2, suggestedCard3]
        suggestions2 = [suggestedCardC0, suggestedCardC1, suggestedCardC2, suggestedCardC3]
        
        // Set up a way reference suggested-card arrays in the future when I want to quickly switch between them
        
        allSuggestionArrays = [suggestions0, suggestions1, suggestions2]
        
        // What will I use to actually display the chosen group of suggested cards, and the one card that the viewer should be seeing?
        
        currentSuggestionArrayIndex = 1
        currentSuggestedCardIndex = 0
        
        currentSuggestionArray = allSuggestionArrays[currentSuggestionArrayIndex]
        currentSuggestedCard = currentSuggestionArray[currentSuggestedCardIndex]
        
        // Hide all suggested cards except for the first array.
        for array in allSuggestionArrays {
            
            if array != allSuggestionArrays[1] {
                for card in array {
                    card.isHidden = true
                }
            }
        }
        
        
        print ("currentSuggestionArrayIndex: \(currentSuggestionArrayIndex)")
        print ("suggestedParentOriginalX = \(suggestedParentOriginalX)")
        
    }
    
    /////////////////////////////////
    ///// Suggested Card Parent//////
    /////////////////////////////////
    
    @IBAction func didPanSuggestedCardParent(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        // half of a card's width, plus half the gap between cards
        halfWay = ((currentSuggestedCard.frame.width + 10) / 2)
        
        didPanHalfWayRight = Double(translation.x) > Double(halfWay)
        didPanHalfWayLeft = translation.x < 0 && translation.x < -halfWay
        
        
        if sender.state == .began {
            suggestedParentOriginalX = suggestedCardParentView.center.x
            
        } else if sender.state == .changed {
            
            suggestedCardParentView.center.x = suggestedParentOriginalX + translation.x
            
        } else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                
                // if the user panned more than halfway to the next card, advance to the next card
                if self.didPanHalfWayLeft! {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX - (self.currentSuggestedCard.frame.width + 2)
                    
                    // Re-set the current card, and its center
                    self.currentSuggestedCardIndex = self.currentSuggestedCardIndex + 1
                    self.currentSuggestedCard = self.currentSuggestionArray[self.currentSuggestedCardIndex]
                    
                    print ("Did pan halfway left.")
                    print("currentSuggestedCardIndex = \(self.currentSuggestedCardIndex)")
                    print("suggestedCardParentView.center.x = \(self.suggestedCardParentView.center.x)")
                    
                } else if self.didPanHalfWayRight! {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX + (self.currentSuggestedCard.frame.width + 2)
                    
                    // Re-set the current card, and its center
                    self.currentSuggestedCardIndex = self.currentSuggestedCardIndex - 1
                    self.currentSuggestedCard = self.currentSuggestionArray[self.currentSuggestedCardIndex]
                    
                    print("Did pan halfway right")
                    print("currentSuggestedCardIndex: \(self.currentSuggestedCardIndex)")
                    print("suggestedCardParentView.center.x = \(self.suggestedCardParentView.center.x)")
                }
                    
                // otherwise snap the current card back to center
                else {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX
                    
                    print ("Not halfway.")
                }
                
            })
        }
    } // end didPanSuggestedCardParent
    
    
    /////////////////////////////////
    ////// Suggested Card Tray //////
    /////////////////////////////////
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        let isMovingDown = velocity.y > 0
        
        // offset = keyboard height
        suggestionOffset = 216
        
        suggestedTrayUp = 176
        suggestedTrayDown = suggestedTrayUp + suggestionOffset
        
        suggestedParentUp = 202
        suggestedParentDown = suggestedParentUp + suggestionOffset
        
        if sender.state == .began {
            
            suggestedTrayOriginalY = suggestedCardTray.frame.origin.y
            suggestedParentOriginalY = suggestedCardParentView.frame.origin.y
            
        } else if sender.state == .changed {
            
            if isMovingDown {
                
                suggestedCardTray.frame.origin.y = suggestedTrayOriginalY + translation.y
                
                // move suggestions down with the tray
                suggestedCardParentView.frame.origin.y = suggestedParentOriginalY + translation.y
                
                print ("Moving tray down.")
                print ("suggestedCardParentView.center.y = \(Double(suggestedCardParentView.center.y))")
                
            } else {
                
                suggestedCardTray.frame.origin.y = suggestedTrayOriginalY + translation.y
                
                suggestedCardParentView.frame.origin.y = suggestedParentOriginalY + translation.y
            }
            
        } else if sender.state == .ended {
            
            if isMovingDown {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayDown
                    self.suggestedCardParentView.frame.origin.y = self.suggestedParentDown
                    
                })
                
                
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayUp
                    self.suggestedCardParentView.frame.origin.y = self.suggestedParentUp
                })
            }
        }
    } // end didPanTray
    
    
    ////////////////////////////////////////
    /////// Dragging Suggested Cards ///////
    ////////////////////////////////////////
    
    @IBAction func didDragSuggestion(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        // offset = keyboard height
        suggestionOffset = 216
        
        suggestedTrayUp = 176
        suggestedTrayDown = suggestedTrayUp + suggestionOffset
        
        suggestedParentUp = 202
        suggestedParentDown = suggestedParentUp + suggestionOffset
        
        if sender.state == .began {
            
            /////// Duplicate Suggested Card on Drag ///////
            // initialize a new image view from the sender
            let imageView = sender.view as! UIImageView
            
            // assign the senders image to the new image view
            duplicatedCard = UIImageView(image: imageView.image)
            
            // add the new image to the current view
            view.addSubview(duplicatedCard)
            
            print ("addSubview completed. center.x: \(duplicatedCard.center.x)")
            print ("addSubview completed. center.y: \(duplicatedCard.center.y)")
            
            // set the center of the duplicate card
            duplicatedCard.center = imageView.center
            
            print ("'duplicatedCard.center = imageView.center' completed. center.x: \(duplicatedCard.center.x)")
            print ("'duplicatedCard.center = imageView.center' completed. center.y: \(duplicatedCard.center.y)")
            
            // center the new card
            duplicatedCard.center.y += currentSuggestedCard.center.y - 9
            duplicatedCard.center.x -= (currentSuggestedCard.frame.width + 2) * CGFloat(currentSuggestedCardIndex)
            
            
            print ("duplicatedCard.center + currentSuggestedCard.center.y = \(duplicatedCard.center.y) + \(currentSuggestedCard.center.y) = \(duplicatedCard.center.y + currentSuggestedCard.center.y)")
            print ("duplicatedCard.center.y should = \(duplicatedCard.center.y + currentSuggestedCard.center.y)")
            print ("duplicatedCard.center.y actually = \(duplicatedCard.center.y)")
            
            
            // record the original center
            duplicatedCardOriginalCenter = duplicatedCard.center
            
            // hide the suggested card, giving the impression that the duplicate card is the suggested card
            self.currentSuggestedCard.isHidden = true
            
            print ("Duplicate card center.x: \(duplicatedCard.center.x)")
            
            
        } else if sender.state == .changed {
            
            /////// Move Suggested Card with Drag ///////
            let translation = sender.translation(in: view)
            
            duplicatedCard.center = CGPoint(x: duplicatedCardOriginalCenter.x + translation.x, y: duplicatedCardOriginalCenter.y + translation.y)
            
            /////// Dragging: Replace or Add a Deck Card ///////
            
            replacingDeckCard = duplicatedCard.center.x > 75 && duplicatedCard.center.x < 350 && duplicatedCard.center.y < 350
            
            addingDeckCard = (duplicatedCard.center.x < 75 || duplicatedCard.center.x > 300) && duplicatedCard.center.y > 300
            
            // Dragging to replace a deck card
            
            if replacingDeckCard! {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayDown
                    self.currentDeckCard.alpha = 0.4
                    self.replaceIcon.alpha = 1
                    
                })
            }
            // Dragging to add a deck card
                
            else if addingDeckCard! {
                // animate deck cards out of the way
                // drop the tray
                // show the "add" icon
            }
                
            else {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayUp
                    self.currentDeckCard.alpha = 1
                    self.replaceIcon.alpha = 0
                })
                
            }
            
        } else if sender.state == .ended {
            
            // Do these immediately upon release
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
                
                self.duplicatedCard.center = CGPoint(x: self.duplicatedCardOriginalCenter.x, y: self.duplicatedCardOriginalCenter.y)
                
                self.suggestedCardTray.frame.origin.y = self.suggestedTrayUp
                self.currentDeckCard.alpha = 1
                self.replaceIcon.alpha = 0
            })
            
            // Do these after release, with a delay
            delay(0.3, closure: {
                self.duplicatedCard.removeFromSuperview()
                self.currentSuggestedCard.isHidden = false
            })
            
            
            if replacingDeckCard! {
                // move the suggested card into the deck card's place
                // swap the suggestion-style card with its corresponding deck version
                // move suggestions over to fill the gap
            }
            
        }
        
        
    } // end didDragSuggestion
    
    
    ///////////////////////////////
    /////// User Deck Cards ///////
    ///////////////////////////////
    
    
    @IBAction func didPanDeck(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        let previousSuggestionArray: [UIImageView]!
        
        if sender.state == .began {
            
            deckParentOriginalX = deckCardParentView.center.x
            
        } else if sender.state == .changed {
            
            deckCardParentView.center.x = deckParentOriginalX + translation.x
            
        } else if sender.state == .ended {
            
            halfWay = ((currentDeckCard.frame.width + 10) / 2)
            
            didPanHalfWayRight = Double(translation.x) > Double(halfWay)
            didPanHalfWayLeft = translation.x < 0 && translation.x < -halfWay
            
            if didPanHalfWayRight! {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.deckCardParentView.center.x = self.deckParentOriginalX + (self.currentDeckCard.frame.width + 2)
                })
                
                ////// 'Load' new suggestions //////
                
                // reference the array that has been showing so far
                previousSuggestionArray = currentSuggestionArray
                
                // reference the array that will be shown
                currentSuggestionArrayIndex = currentSuggestionArrayIndex - 1
                currentSuggestionArray = allSuggestionArrays[currentSuggestionArrayIndex]
                
                // load the new suggestions
                showNewSuggestionArray(previousSuggestionArray: previousSuggestionArray, newSuggestionArray: currentSuggestionArray)
                
                // reset what the 'current' suggested card is
                resetSuggestionsToBeginning()
                
                print ("currentSuggestionArrayIndex: \(currentSuggestionArrayIndex)")
                
            } else if didPanHalfWayLeft! {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.deckCardParentView.center.x = self.deckParentOriginalX - (self.currentDeckCard.frame.width + 2)
                })
                
                ////// 'Load' new suggestions //////
                
                // reference the array that has been showing so far
                previousSuggestionArray = currentSuggestionArray
                
                // reference the array that will be shown
                currentSuggestionArrayIndex = currentSuggestionArrayIndex + 1
                currentSuggestionArray = allSuggestionArrays[currentSuggestionArrayIndex]
                
                // load the new suggestions
                showNewSuggestionArray(previousSuggestionArray: previousSuggestionArray, newSuggestionArray: currentSuggestionArray)
                
                // reset what the 'current' suggested card is
                resetSuggestionsToBeginning()
                
                print ("currentSuggestionArrayIndex: \(currentSuggestionArrayIndex)")
                
            } else {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    
                    self.deckCardParentView.center.x = self.deckParentOriginalX
                })
            }
        }
    }
    
    
    ///////////////////////////////
    /////// Useful Functions //////
    ///////////////////////////////
    
    func showNewSuggestionArray(previousSuggestionArray: [UIImageView], newSuggestionArray: [UIImageView]) {
        
        for card in previousSuggestionArray {
            card.isHidden = true
        }
        
        dummyCard.isHidden = false
        
        run(after: 0.9, closure:{
        
            self.dummyCard.isHidden = true
            for card in newSuggestionArray {
                card.isHidden = false
            }
            
        }
        )
        
    }

    func resetSuggestionsToBeginning() {
    
        currentSuggestedCardIndex = 0
        currentSuggestedCard = currentSuggestionArray[0]
        suggestedCardParentView.center.x = permanentSuggestedParentOriginalX
        
        print (" ")
        print ("currentSuggestedCardIndex \(currentSuggestedCardIndex)")
        print ("suggestedCardParentView.center.x should be: \(permanentSuggestedParentOriginalX)")
        print ("suggestedCardParentView.center.x is actually: \(suggestedCardParentView.center.x)")
        
    }
    
    
    
    
    
    
}
