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
    @IBOutlet weak var trayArrow: UIImageView!
    @IBOutlet weak var editorToolbar: UIImageView!
    @IBOutlet weak var textFieldForBlinker: UITextField!
    
    //// Outlets for all suggested cards ////
    
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
    
    // "Real" version of suggestedCard0 "Cultural Anthropology"
    @IBOutlet weak var realCardBackground: UIView!
    @IBOutlet weak var realSuggestedCard0: UIView!
    @IBOutlet weak var realCardBodyText: UITextView!
    @IBOutlet weak var seeMoreGroup: UIImageView!
    
    var realCardOriginalHeight: CGFloat!
    var realCardOrignalY: CGFloat!
    var realTextOriginalHeight: CGFloat!
    
    var realCardExpandedOriginalY: CGFloat!
    
    // Suggestion starter card for the blank deck card. Need this to differentiate that group of suggestions.
    @IBOutlet weak var suggestedCardD1: UIImageView!
    
    
    //// Outlets for deck cards ////
    
    @IBOutlet weak var deckCard0: UIImageView!
    @IBOutlet weak var deckCard1: UIImageView!
    @IBOutlet weak var deckCard2: UIImageView!
    
    
    //// Outlets for suggested terms area ////
    
    @IBOutlet weak var suggestedTermsScrollView: UIScrollView!
    
    @IBOutlet weak var suggestedTerms0: UIImageView!
    @IBOutlet weak var suggestedTerms1: UIImageView!
    @IBOutlet weak var suggestedTerms2: UIImageView!
    @IBOutlet weak var suggestedTermsEthnology: UIImageView!
    
    var suggestedTermsArray: [UIImageView]!
    var suggestedTermsArrayIndex: Int!
    var currentSuggestedTerms: UIImageView!
    var suggestedTermsOriginalX: CGFloat!
    var suggestedScrollOriginalX: CGFloat!
    var suggestedScrollOriginalY: CGFloat!
    
    
    // set up initial positions of the suggestion parent
    var suggestedParentOriginalX: CGFloat!
    var suggestedParentOriginalY: CGFloat!
    var permanentSuggestedParentOriginalX: CGFloat!
    
    // tray movement
    var suggestedTrayOriginalY: CGFloat!
    var suggestedTrayUp: CGFloat!
    var suggestedTrayDown: CGFloat!
    var suggestionOffset: CGFloat!
    var arrowOriginalY: CGFloat!
    var arrowUp: CGFloat!
    var arrowDown: CGFloat!
    
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
    
    var suggestions0: [UIImageView]! // suggestions based on position 0
    var suggestions1: [UIImageView]! // suggestions based on position 1
    var suggestions2: [UIImageView]! // suggestions based on position 2
    var suggestionsEthnology: [UIImageView]! // suggestions based on a user tapping "ethnology"
    
    var currentSuggestedCardIndex: Int!
    var currentSuggestionArrayIndex: Int!
    var allSuggestionArrays: [[UIImageView]]! // a parent array containing each suggestion array
    var currentSuggestionArray: [UIImageView]! // displays the current suggestions
    
    // establish concept of a "current deck card" in the deck area

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        textFieldForBlinker.becomeFirstResponder()
        
        // Alpha states
        replaceIcon.alpha = 0
        dummyCard.alpha = 0
        suggestedTermsEthnology.alpha = 0
        editorToolbar.alpha = 1
        
        // Tray and suggestion positioning
        
        // offset = keyboard height
        suggestionOffset = 181
        
        arrowUp = 218
        arrowDown = arrowUp + suggestionOffset
        trayArrow.center.y = arrowDown
        
        suggestedTrayUp = 200
        suggestedTrayDown = suggestedTrayUp + suggestionOffset
        suggestedCardTray.frame.origin.y = suggestedTrayDown
        
        suggestedParentUp = 231
        suggestedParentDown = suggestedParentUp + suggestionOffset
        suggestedCardParentView.frame.origin.y = suggestedParentDown
        
        arrowOriginalY = trayArrow.center.y
        suggestedParentOriginalX = suggestedCardParentView.center.x
        permanentSuggestedParentOriginalX = suggestedCardParentView.center.x
        suggestedScrollOriginalY = suggestedTermsScrollView.center.y
        suggestedTermsOriginalX = 29
        
        // Set up the "real" card to expand
        
        let cardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didExpandCard(sender:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(collapseCard(sender:)))
        
        suggestedCard0.addGestureRecognizer(cardTapGestureRecognizer)
        realSuggestedCard0.addGestureRecognizer(panGestureRecognizer)

        
        realCardOrignalY = realSuggestedCard0.frame.origin.y
        realCardOriginalHeight = realSuggestedCard0.frame.height
        realTextOriginalHeight = realCardBodyText.frame.height
        
        realSuggestedCard0.alpha = 0
        realSuggestedCard0.layer.cornerRadius = 8.0
        realSuggestedCard0.isUserInteractionEnabled = true
        realCardBackground?.backgroundColor = UIColor(white: 0, alpha: 0)
        realCardBackground.isHidden = true
        
        
        
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
        suggestions2 = [suggestedCardD1, suggestedCard3, suggestedCardB0, suggestedCardC1]
        
        suggestionsEthnology = [suggestedCardC0, suggestedCardC1, suggestedCardC2, suggestedCardC3]
        
        // Set up a way reference suggested-card arrays in the future when I want to quickly switch between them
        
        allSuggestionArrays = [suggestions0, suggestions1, suggestions2]
        
        // Display the chosen group of suggested cards, and the one card that the viewer should be seeing
        
        currentSuggestionArrayIndex = 1
        currentSuggestedCardIndex = 0
        
        currentSuggestionArray = allSuggestionArrays[currentSuggestionArrayIndex]
        currentSuggestedCard = currentSuggestionArray[currentSuggestedCardIndex]
        
        // Hide all suggested cards except for the first array.
        for array in allSuggestionArrays {
            
            if array != allSuggestionArrays[1] {
                for card in array {
                    card.alpha = 0
                }
            }
        }
        
        // Hide the 'ethnology' special case array
        
        for card in suggestionsEthnology {
            card.alpha = 0
        }
        
        print ("currentSuggestionArrayIndex: \(currentSuggestionArrayIndex)")
        print ("suggestedParentOriginalX = \(suggestedParentOriginalX)")
        
        
        
        // Suggested Terms: Set up array and define 'current'
        
        suggestedTermsArray = [suggestedTerms0, suggestedTerms1, suggestedTerms2]
        suggestedTermsArrayIndex = 1
        currentSuggestedTerms = suggestedTermsArray[suggestedTermsArrayIndex]
        
        suggestedTermsScrollView.contentSize = currentSuggestedTerms.frame.size
        suggestedScrollOriginalX = suggestedTermsScrollView.center.x
        
        // Hide all suggested term groups except for the first.
        for terms in suggestedTermsArray {
            if terms != suggestedTermsArray[1] {
                terms.alpha = 0
            }
            if terms == suggestedTermsArray[1] {
                terms.alpha = 1
            }
        }
        
    } // end viewDidLoad
    
    
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
        
        if sender.state == .began {
            
            suggestedTrayOriginalY = suggestedCardTray.frame.origin.y
            suggestedParentOriginalY = suggestedCardParentView.frame.origin.y
            arrowOriginalY = trayArrow.center.y
            
        } else if sender.state == .changed {
            
            suggestedCardTray.frame.origin.y = suggestedTrayOriginalY + translation.y
            suggestedCardParentView.frame.origin.y = suggestedParentOriginalY + translation.y
            suggestedTermsScrollView.center.y = suggestedScrollOriginalY + translation.y
            trayArrow.center.y = arrowOriginalY + translation.y
            
            
        } else if sender.state == .ended {
            
            var alpha: CGFloat!
            
            if isMovingDown {
                
                toggleTextField(hasFocus: true)
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayDown
                    self.suggestedCardParentView.frame.origin.y = self.suggestedParentDown
                    self.suggestedTermsScrollView.center.y = self.suggestedScrollOriginalY + 300
                    self.trayArrow.center.y = self.arrowDown
                    self.trayArrow.transform = CGAffineTransform(rotationAngleDegrees: 180)
                    alpha = 1
                })
                
                toggleToolbar(alpha: alpha)
                
                
            } else { // moving up
                
                toggleTextField(hasFocus: false)
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayUp
                    self.suggestedCardParentView.frame.origin.y = self.suggestedParentUp
                    self.suggestedTermsScrollView.center.y = self.suggestedScrollOriginalY
                    self.trayArrow.center.y = self.arrowUp
                    self.trayArrow.transform = CGAffineTransform(rotationAngleDegrees: 0)
                    alpha = 0
                })

                toggleToolbar(alpha: alpha)
                
            }

            
        }
    } // end didPanTray
    
    
    ////////////////////////////////////////
    /////// Dragging Suggested Cards ///////
    ////////////////////////////////////////
    
    
    @IBAction func didDragSuggestion(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
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
            duplicatedCard.center.y += currentSuggestedCard.center.y + 35
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
                    self.trayArrow.center.y = self.arrowDown
                    
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
                    self.trayArrow.center.y = self.arrowUp
                })
                
            }
            
        } else if sender.state == .ended {
            
            // Do these immediately upon release
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
                
                self.duplicatedCard.center = CGPoint(x: self.duplicatedCardOriginalCenter.x, y: self.duplicatedCardOriginalCenter.y)
                
                self.suggestedCardTray.frame.origin.y = self.suggestedTrayUp
                self.currentDeckCard.alpha = 1
                self.replaceIcon.alpha = 0
                self.trayArrow.center.y = self.arrowUp
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
        let previousSuggestedTerms: UIImageView!
        
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
                
                ////// 'Load' new suggestions and terms //////
                
                // hide the cards that have been showing so far
                
                
                // reference the array that will be shown
                currentSuggestionArrayIndex = currentSuggestionArrayIndex - 1
                currentSuggestionArray = allSuggestionArrays[currentSuggestionArrayIndex]
                
                // load the new suggestions
                hidePreviousSuggestionArray()
                showNewSuggestionArray()
                
                print ("currentSuggestionArrayIndex: \(currentSuggestionArrayIndex)")
                
                
                // reset what the 'current' suggested card is
                resetSuggestionsToBeginning()
                
                // load new terms
                previousSuggestedTerms = currentSuggestedTerms
                
                suggestedTermsArrayIndex = suggestedTermsArrayIndex - 1
                currentSuggestedTerms = suggestedTermsArray[suggestedTermsArrayIndex]
                showNewSuggestedTerms(previousSuggestedTerms: previousSuggestedTerms, newSuggestedTerms: currentSuggestedTerms)
                
                print ("suggestedTermsArrayIndex = \(suggestedTermsArrayIndex)")

            } else if didPanHalfWayLeft! {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.deckCardParentView.center.x = self.deckParentOriginalX - (self.currentDeckCard.frame.width + 2)
                })
                
                ////// 'Load' new suggestions //////
                
                // hide the cards that have been showing so far
                
                
                // reference the array that will be shown
                currentSuggestionArrayIndex = currentSuggestionArrayIndex + 1
                currentSuggestionArray = allSuggestionArrays[currentSuggestionArrayIndex]
                
                // load the new suggestions
                hidePreviousSuggestionArray()
                showNewSuggestionArray()
                
                print ("currentSuggestionArrayIndex: \(currentSuggestionArrayIndex)")
                
                // reset what the 'current' suggested card is
                resetSuggestionsToBeginning()
                
                // load new terms
                previousSuggestedTerms = currentSuggestedTerms
                
                suggestedTermsArrayIndex = suggestedTermsArrayIndex + 1
                currentSuggestedTerms = suggestedTermsArray[suggestedTermsArrayIndex]
                showNewSuggestedTerms(previousSuggestedTerms: previousSuggestedTerms, newSuggestedTerms: currentSuggestedTerms)
                
                print ("suggestedTermsArrayIndex = \(suggestedTermsArrayIndex)")
                
                
            } else {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    
                    self.deckCardParentView.center.x = self.deckParentOriginalX
                })
            }
        }
    } // end didPanDeck
    
    
    
    @IBAction func didTapEthnologyTerm(_ sender: UIButton) {
        
        // Tapping the "ethnology" suggested term triggers a series of events that exist outside of the array structure that handles all other scrolling. It is a special case that is handled here in an isolated way.
        
        // hide previous terms, show new ones with 'ethnology' selected
        currentSuggestedTerms.alpha = 0
        suggestedTermsEthnology.alpha = 1
        suggestedTermsEthnology.center.x = currentSuggestedTerms.center.x + 6
        
        // hide suggested cards that have been showing so far
        for card in currentSuggestionArray {
            UIView.animate(withDuration: 0.2, animations: {
                card.alpha = 0
            })
        }
        
        // show and hide the dummy card
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.dummyCard.alpha = 1
                        
        }, completion: {complete in
            UIView.animate(
                withDuration: 0.2,
                delay: 0.7,
                animations: {
                self.dummyCard.alpha = 0
            })
        })
        
        run(after: 0.3, closure:{self.resetSuggestionsToBeginning()})
        
        
        for card in suggestionsEthnology {
            UIView.animate(withDuration: 0.2, delay: 0.3, animations: {
                card.alpha = 1
            })

        }
        
    } // end didTapEthnologyTerm
    
    ////////////////////////////////////////////
    /////// Expand and collapse real card //////
    ////////////////////////////////////////////
    
    
    func didExpandCard( sender: Any) {
        
        print ("tapped")
        
        realCardBackground.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations:{
            
            self.realSuggestedCard0.alpha = 1
            self.realCardBackground.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            
            self.realSuggestedCard0.frame.origin.y = 40
            
        })
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            
            self.realSuggestedCard0.frame.size = CGSize(width: 342, height: 465)
            
            self.realCardBodyText.frame.size = CGSize(width: 277, height: (self.realSuggestedCard0.frame.height))
            
            self.seeMoreGroup.alpha = 0
            
        })
        
        
    } // end didExpandCard
    
    
    func collapseCard( sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        realCardExpandedOriginalY = realSuggestedCard0.frame.origin.y
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            realSuggestedCard0.frame.origin.y = realCardExpandedOriginalY + translation.y
            
        } else if sender.state == .ended {
            
            if velocity.y > 0 {
               
                UIView.animate(withDuration: 0.3, animations:{
                    
                    self.realSuggestedCard0.alpha = 0
                    self.realCardBackground.backgroundColor = UIColor(white: 0, alpha: 0)
                    
                })
                
                UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    
                    self.realSuggestedCard0.frame.origin.y = self.realCardOrignalY
                    
                })
                
                UIView.animate(withDuration: 0.3, delay: 0, animations: {
                    
                    self.realSuggestedCard0.frame.size = CGSize(width: 342, height: self.realCardOriginalHeight)
                    
                    self.realCardBodyText.frame.size = CGSize(width: 277, height: self.realTextOriginalHeight)
                    
                    self.seeMoreGroup.alpha = 1
                    
                })
                
                run(after: 0.5, closure: {
                    self.realCardBackground.isHidden = true
                })
                
                
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: { 
                    self.realSuggestedCard0.frame.origin.y = self.realCardExpandedOriginalY
                })
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    ///////////////////////////////
    /////// Useful Functions //////
    ///////////////////////////////
    
    func hidePreviousSuggestionArray() {
        
        print (" ")
        print ("running 'hidePreviousSuggestionArray'")
        print (" ")
        
        // Dismiss the special case if applicable (user tapped the "ethnology" suggested term)
        if suggestedTermsEthnology.alpha > 0 {
            
            // hide ethnology suggested terms
            UIView.animate(withDuration: 0.2, animations: {
                self.suggestedTermsEthnology.alpha = 0
            })
            
            // hide the ethnology suggestions
            for card in suggestionsEthnology {
                UIView.animate(withDuration: 0.2, animations: {
                    card.alpha = 0
                })
            }
        }
        
        // Hide any suggestions that have been showing so far
        
        
        for array in allSuggestionArrays {
            if array != allSuggestionArrays[currentSuggestionArrayIndex] {
                
                for card in array {
                    
                    UIView.animate(
                        withDuration: 0.2,
                        animations: {
                            card.alpha = 0
                            print ("card hidden")
                    })
                    
                    // show the dummy card if the tray is up
                    if self.suggestedCardTray.frame.origin.y < 300 {
                        self.dummyCard.alpha = 1
                        print ("SHOW dummyCard: dummyCard.alpha = \(self.dummyCard.alpha)")
                    }
                }
            }
        }
    }
    
    func showNewSuggestionArray() {

        print (" ")
        print ("running showNewSuggestionArray")
        print ("currentSuggestionArrayIndex: \(currentSuggestionArrayIndex)")
        print (" ")

        
        // show the new suggestions
        for card in currentSuggestionArray {
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0.7,
                animations: {
                    card.alpha = 1
                    print("card shown")
            },
                
                completion: { complete in
                    // hide the dummy card
                    UIView.animate(withDuration: 0.2, animations: {
                        self.dummyCard.alpha = 0
                        print ("HIDE dummyCard: dummyCard.alpha = \(self.dummyCard.alpha)")
                    })
            })
        }

    
    
} // end showNewSuggestionArray


    func resetSuggestionsToBeginning() {
        
        print (" ")
        print ("running 'resetSuggestionsToBeginning'")
        print (" ")
    
        currentSuggestedCardIndex = 0
        currentSuggestedCard = currentSuggestionArray[0]
        suggestedCardParentView.center.x = permanentSuggestedParentOriginalX
        
        print ("currentSuggestedCardIndex \(currentSuggestedCardIndex)")
        print ("suggestedCardParentView.center.x = \(suggestedCardParentView.center.x)")
        
    } // end resetSuggestionsToBeginning
    
    
    func showNewSuggestedTerms(previousSuggestedTerms: UIImageView, newSuggestedTerms: UIImageView) {
        
        print (" ")
        print ("running 'showNewSuggestedTerms'")
        print (" ")
        
        currentSuggestedTerms.frame.origin.x = suggestedTermsOriginalX
        suggestedTermsScrollView.contentSize = currentSuggestedTerms.frame.size
        
        UIView.animate(
            withDuration: 0.2,
            animations:{
            previousSuggestedTerms.alpha = 0
        },
            completion: {complete in
                
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0.7,
                    animations: {
                    newSuggestedTerms.alpha = 1
                })
        })
        
    } // end showNewSuggestedTerms
    
    
    func toggleToolbar (alpha: CGFloat) {
        
        print ("Running toggleToolbar")
        
        if alpha == 1 {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations:{
                self.editorToolbar.alpha = 1
            })
            
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations:{
                self.editorToolbar.alpha = 0
            })
        }
    } // end toggleToolbar
    
    
    func toggleTextField (hasFocus: Bool){
        
        if hasFocus {
            textFieldForBlinker.becomeFirstResponder()
            
        } else {
            textFieldForBlinker.resignFirstResponder()
        }
    } // end toggleTextField
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
} // END CLASS
