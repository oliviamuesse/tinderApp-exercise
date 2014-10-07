//
//  CardsViewController.swift
//  tinderApp-exercise
//
//  Created by Olivia Muesse on 10/6/14.
//  Copyright (c) 2014 Olivia Muesse. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var imageView: UIImageView!
    
    var cardInitialCenter: CGPoint!
    var isPresenting: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 6

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanCard(panGestureRecognizer: UIPanGestureRecognizer) {
        var location = panGestureRecognizer.locationInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            cardInitialCenter = imageView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            imageView.center.x = translation.x + cardInitialCenter.x
            //imageView.center.y = translation.y + cardInitialCenter.y
            
            if location.y > imageView.center.y {
                imageView.transform = CGAffineTransformMakeRotation(translation.x * CGFloat(-M_PI) / 360)
            } else {
                imageView.transform = CGAffineTransformMakeRotation(translation.x * CGFloat(M_PI) / 360)
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if translation.x > 50 || translation.x < -50 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.imageView.center.x = translation.x*10
                    }, completion: { (finished: Bool) -> Void in
                    println("ended")
                })
            } else {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 6, options: nil, animations: { () -> Void in
                    self.imageView.center = self.cardInitialCenter
                    self.imageView.transform = CGAffineTransformIdentity
                    }, completion: { (finsihed: Bool) -> Void in
                    
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationViewController = segue.destinationViewController as ProfileViewController
        //var sourceViewController = segue.sourceViewController as CardsViewController
        
        destinationViewController.image = self.imageView.image
        
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
    }
    
    @IBAction func onTapCard(gestureRecognizer: UITapGestureRecognizer) {
        performSegueWithIdentifier("tinderSegue", sender: self)
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if (isPresenting) {
            var tempView = UIImageView(frame: imageView.frame)
            tempView.layer.cornerRadius = 6
            tempView.clipsToBounds = true
            tempView.contentMode = imageView.contentMode
            tempView.image = imageView.image
            var window = UIApplication.sharedApplication().keyWindow
            window.addSubview(tempView)
            
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            
            if let vc = toViewController as? ProfileViewController {
                vc.imageView.hidden = true
            }
            
            //animate to final position, remove view from window
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                toViewController.view.alpha = 1
                tempView.frame = CGRect(x: 0, y: 53, width: 320, height: 342)
                
                }) { (finished: Bool) -> Void in
                    tempView.removeFromSuperview()
                    if let vc = toViewController as? ProfileViewController {
                        vc.imageView.hidden = false
                    }
                    transitionContext.completeTransition(true)
            }
        } else {
            let vc = fromViewController as ProfileViewController
            
            var tempView = UIImageView(frame: vc.imageView.frame)
            tempView.clipsToBounds = true
            tempView.contentMode = imageView.contentMode
            tempView.image = imageView.image
            var window = UIApplication.sharedApplication().keyWindow
            window.addSubview(tempView)
            vc.imageView.hidden = true
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                fromViewController.view.alpha = 0
                tempView.layer.cornerRadius = 6
                tempView.frame = self.imageView.frame
                }) { (finished: Bool) -> Void in
                    fromViewController.view.removeFromSuperview()
                    tempView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
