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
    @IBOutlet weak var suggestedCard: UIImageView!
    @IBOutlet weak var suggestedCardTray: UIImageView!
    @IBOutlet weak var deckCardParentView: UIView!
    @IBOutlet weak var deckCard: UIImageView!
    @IBOutlet weak var replaceIcon: UIImageView!
    
    
    // set up initial positions of the suggestion parent
    var suggestedParentOriginalX: CGFloat!
    var suggestedParentOriginalY: CGFloat!
    
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
    
    // deck cards
    var deckParentOriginalX: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        suggestedParentOriginalX = suggestedCardParentView.center.x
        
        replaceIcon.alpha = 0
        
    }
    
    /////////////////////////////////
    ///// Suggested Card Parent//////
    /////////////////////////////////
    
    @IBAction func didPanSuggestedCardParent(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        // half of a card's width, plus half the gap between cards
        halfWay = ((suggestedCard.frame.width + 10) / 2)
        
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
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX - (self.suggestedCard.frame.width + 2)
                    print ("Did pan halfway left.")
                } else if self.didPanHalfWayRight! {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX + (self.suggestedCard.frame.width + 2)
                    print("Did pan halfway right")
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
    
    
    /////////////////////////////////
    /////// Dragging Sequence ///////
    /////////////////////////////////
    
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
            
            // set the center of the duplicate card
            duplicatedCard.center = imageView.center
            
            // center the new card
            duplicatedCard.center.y += suggestedCard.center.y - 10
            duplicatedCard.center.x = suggestedCard.center.x
            
            // record the original center
            duplicatedCardOriginalCenter = duplicatedCard.center
            
            // hide the suggested card, giving the impression that the duplicate card is the suggested card
            self.suggestedCard.isHidden = true
            
            print ("Duplicate card center.x: \(duplicatedCard.center.x)")
            
            
        } else if sender.state == .changed {
            
            /////// Move Suggested Card with Drag ///////
            let translation = sender.translation(in: view)
            
            duplicatedCard.center = CGPoint(x: duplicatedCardOriginalCenter.x + translation.x, y: duplicatedCardOriginalCenter.y + translation.y)
            
            /////// Dragging Replace or Add a Deck Card ///////
            
            replacingDeckCard = duplicatedCard.center.x > 75 && duplicatedCard.center.x < 350 && duplicatedCard.center.y < 350
            
            addingDeckCard = (duplicatedCard.center.x < 75 || duplicatedCard.center.x > 300) && duplicatedCard.center.y > 300
            
            // Dragging to replace a deck card
            
            if replacingDeckCard! {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayDown
                    self.deckCard.alpha = 0.4
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
                    self.deckCard.alpha = 1
                    self.replaceIcon.alpha = 0
                })
                
            }
            
        } else if sender.state == .ended {
            
            // Do these immediately upon release
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
                
                self.duplicatedCard.center = CGPoint(x: self.duplicatedCardOriginalCenter.x, y: self.duplicatedCardOriginalCenter.y)
                
                self.suggestedCardTray.frame.origin.y = self.suggestedTrayUp
                self.deckCard.alpha = 1
                self.replaceIcon.alpha = 0
            })
            
            // Do these after release, with a delay
            delay(0.3, closure: {
                self.duplicatedCard.removeFromSuperview()
                self.suggestedCard.isHidden = false
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
        
        if sender.state == .began {
            
            deckParentOriginalX = deckCardParentView.center.x
            
        } else if sender.state == .changed {
            
            deckCardParentView.center.x = deckParentOriginalX + translation.x
            
        } else if sender.state == .ended {
            
            halfWay = ((deckCard.frame.width + 10) / 2)
            
            didPanHalfWayRight = Double(translation.x) > Double(halfWay)
            didPanHalfWayLeft = translation.x < 0 && translation.x < -halfWay
            
            
            if didPanHalfWayRight! {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.deckCardParentView.center.x = self.deckParentOriginalX + self.deckCard.frame.width
                })
                
            } else if didPanHalfWayLeft! {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.deckCardParentView.center.x = self.deckParentOriginalX - self.deckCard.frame.width
                })
            } else {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    
                    self.deckCardParentView.center.x = self.deckParentOriginalX
                })
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
