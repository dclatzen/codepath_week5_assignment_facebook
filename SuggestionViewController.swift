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
    
    var suggestedParentOriginalX: CGFloat!
    var halfWay: CGFloat!
    var didPanHalfWayRight: Bool!
    var didPanHalfWayLeft: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
                
                if self.didPanHalfWayLeft! {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX - (self.suggestedCard.frame.width + 2)
                    print ("Did pan halfway left.")
                } else if self.didPanHalfWayRight! {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX + (self.suggestedCard.frame.width - 2)
                    print("Did pan halfway right")
                } else {
                    self.suggestedCardParentView.center.x = self.suggestedParentOriginalX
                    
                    print ("Not halfway.")
                }
                
            })
            
        }
        
    } // end didPanSuggestedCardParent
    


    

}
