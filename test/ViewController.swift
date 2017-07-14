//
//  ViewController.swift
//  test
//
//  Created by 敬庭超 on 2017/7/14.
//  Copyright © 2017年 敬庭超. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CAAnimationDelegate {
    enum PanDirection: Int {
        case Right
        case Left
        case Bottom
        case Top
        case TopLeftToBottomRight
        case TopRightToBottomLeft
        case BottomLeftToTopRight
        case BottomRightToTopLeft
    }

    var gradientLayer: CAGradientLayer!
    //数组当中有数组
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!
    var panDirection: PanDirection!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createColorSets()
        //需要在view的layer层上展示CAGradientLayer
        createGradientLayer()
    }
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        //设置用于产生渐变效果的颜色
        gradientLayer.colors = colorSets[currentColorSet]
        //将 gradientLayer 作为 sublayer 添加至视图 layer 中。
        self.view.layer.addSublayer(gradientLayer)
        //添加手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTapGesture(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        //添加了双指点击
        let twoFingerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTwoFingerTapGesture(gestureRecognizer:)))
        self.view.addGestureRecognizer(twoFingerTapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePanGestureRecognizer(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    func createColorSets(){
        colorSets.append([UIColor.red.cgColor,UIColor.yellow.cgColor,]);
        colorSets.append([UIColor.green.cgColor,UIColor.magenta.cgColor]);
        colorSets.append([UIColor.gray.cgColor,UIColor.lightGray.cgColor])
        currentColorSet = 0
    }
    func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if currentColorSet < colorSets.count - 1 {
            currentColorSet = 1 + currentColorSet
        }else{
            currentColorSet = 0
        }
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.toValue = colorSets[currentColorSet]
        colorChangeAnimation.fillMode = kCAFillModeForwards
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorRange")
    }
    
    func handleTwoFingerTapGesture(gestureRecognizer: UITapGestureRecognizer)  {
        let secondColorLocation = arc4random_uniform(100)
        let firstColorLocation = arc4random_uniform(secondColorLocation - 1)
        
        gradientLayer.locations = [NSNumber(floatLiteral: Double(firstColorLocation)/100.0), NSNumber(floatLiteral: Double(secondColorLocation)/100.0)]
        print(gradientLayer.locations!)

    }
    func handlePanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer)  {
        let velocity = gestureRecognizer.velocity(in: self.view)
        if gestureRecognizer.state == UIGestureRecognizerState.changed {
            if velocity.x > 300.0 {
                if velocity.y > 300.0 {
                    panDirection = PanDirection.TopLeftToBottomRight
                }
                else if velocity.y < -300.0{
                    panDirection = PanDirection.BottomLeftToTopRight
                }
                else{
                    panDirection = PanDirection.Right
                }
            }else if velocity.x < -300.0{
                if velocity.y > 300.0 {
                    panDirection = PanDirection.TopRightToBottomLeft
                }
                else if(velocity.y < -300.0){
                    panDirection = PanDirection.BottomRightToTopLeft
                }
                else{
                    panDirection = PanDirection.Left
                }
                
            }else{
                if velocity.y > 300.0 {
                    panDirection = PanDirection.Bottom
                }
                else if velocity.y < -300.0{
                    panDirection = PanDirection.Top
                }
                else{
                    panDirection = nil
                }
            }
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            changeGradientDirection()
        }
    }
    func changeGradientDirection() {
        if panDirection != nil {
            switch panDirection.rawValue {
            case PanDirection.Right.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0 )
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                
            case PanDirection.Left.rawValue:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                
            case PanDirection.Bottom.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                
            case PanDirection.Top.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0 )
                
            case PanDirection.TopLeftToBottomRight.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                
            case PanDirection.TopRightToBottomLeft.rawValue:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
                
            case PanDirection.BottomLeftToTopRight.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                
            default:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradientLayer.colors = colorSets[currentColorSet]
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

