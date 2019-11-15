//
//  MyTripsViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 15/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController {
    
    enum CardState{
        case expanded
        case collapsed
    }
    
    var cardViewController: CommuteTripsViewController!
    var visualEffectView: UIVisualEffectView!
    
    let cardHeight: CGFloat = 500
    let cardHandleAreaHeight: CGFloat = 250
    
    var cardVisible = false
    var nextState: CardState{
        return cardVisible ? .collapsed: .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenIntterrupted: CGFloat = 0
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
    }
    
    func setupCard(){
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        cardViewController = CommuteTripsViewController(nibName: "MyTripsViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTripsViewController.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MyTripsViewController.handleCardPan(recognizer:)))
        
        cardViewController.handlerArea.addGestureRecognizer(tapGestureRecognizer)
        
        cardViewController.handlerArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardTap(recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.65)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.35)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handlerArea)
            
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete: -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }

    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval){
        if runningAnimations.isEmpty{
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 5){
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear){
                switch state{
                case . expanded:
                    self.cardViewController.view.layer.cornerRadius = 25
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval){
        if runningAnimations.isEmpty{
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations{
            animator.pauseAnimation()
            animationProgressWhenIntterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat){
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenIntterrupted
        }
    }
    
    func continueInteractiveTransition(){
        for animator in runningAnimations{
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

