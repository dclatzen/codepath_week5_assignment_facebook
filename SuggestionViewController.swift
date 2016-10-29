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
    
    var suggestedParentOriginalX: CGFloat!
    var suggestionsTranslateX: CGFloat!
    
    var halfWay: CGFloat!
    var didPanHalfWayRight: Bool!
    var didPanHalfWayLeft: Bool!
    
    var suggestedTrayOriginalY: CGFloat!
    var suggestedTrayUp: CGFloat!
    var suggestedTrayDown: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        suggestedParentOriginalX = suggestedCardParentView.center.x
        
        print ("suggestedParentOriginalX: \(Double(suggestedParentOriginalX))")
        
    }
    
    
    @IBAction func didPanSuggestedCardParent(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        halfWay = ((suggestedCard.frame.width + 10) / 2)
        
        didPanHalfWayRight = Double(translation.x) > Double(halfWay)
        didPanHalfWayLeft = translation.x < 0 && translation.x < -halfWay
        
        
        if sender.state == .began {
            suggestedParentOriginalX = suggestedCardParentView.center.x
            
        } else if sender.state == .changed {
            
            print ("Left theshold \(halfWay)")
            print ("Right threshold \(-halfWay)")
            print ("Currently at: \(translation.x)")
            
            suggestedCardParentView.center.x = suggestedParentOriginalX + translation.x
            
        } else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                
                if self.didPanHalfWayLeft! {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX - (self.suggestedCard.frame.width + 2)
                    print ("Did pan halfway left.")
                } else if self.didPanHalfWayRight! {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX + (self.suggestedCard.frame.width + 2)
                    print("Did pan halfway right")
                } else {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX
                    
                    print ("Not halfway.")
                }
                
            })
            
        }
        
    } // end didPanSuggestedCardParent
    

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        let isMovingDown = velocity.y > 0
        
        suggestedParentOriginalX = suggestedCardParentView.center.x
        
        suggestedTrayUp = 176
        
        // the tray moves down by the height of the keyboard
        suggestedTrayDown = 392
        
        if sender.state == .began {
            
            suggestedTrayOriginalY = suggestedCardTray.frame.origin.y
            
        } else if sender.state == .changed {
            
            if isMovingDown {
                
                suggestedCardTray.frame.origin.y = suggestedTrayOriginalY + translation.y
                
                // move suggestions out of the way as the tray moves down
                suggestionsTranslateX = convertValue(inputValue: translation.x, r1Min: suggestedTrayUp, r1Max: suggestedTrayDown, r2Min: 1, r2Max: 100)
                
                suggestedCardParentView.center.x = suggestedParentOriginalX - suggestionsTranslateX
                
                print ("Moving tray down.")
                print ("suggestionsTranslateX: \(Double(suggestionsTranslateX))")
                print ("suggestedCardParentView.center.x = \(Double(suggestedCardParentView.center.x))")
                
            } else {
                
                // if the tray is moving up, don't bring suggestions in until the gesture ends
                suggestedCardTray.frame.origin.y = suggestedTrayOriginalY + translation.y
            }
            
        } else if sender.state == .ended {
            
            if isMovingDown {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayDown
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX + 375
                    
                })
                
                
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                    self.suggestedCardTray.frame.origin.y = self.suggestedTrayUp
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX - 375
                })

            }
            
        }
        
        
    }
    
    

}
