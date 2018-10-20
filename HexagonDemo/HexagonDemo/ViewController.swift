//
//  ViewController.swift
//  HexagonDemo
//
//  Created by mac on 20/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainViewWCons: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var mainView: UIView!
    var currentObjPos: HexagonPosition = .middle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addView.tag = 1
        let path = roundedPolygonPath(rect: CGRect(x: 0.0, y: 0.0, width: addView.frame.width, height: addView.frame.height), lineWidth: 1, sides: 6, cornerRadius: 5, rotationOffset: 11)
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = 1
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.white.cgColor
        addView.layer.addSublayer(borderLayer)
        let button = UIButton(frame: CGRect(x: -5, y: 0, width: addView.frame.width, height: addView.frame.height))
        button.setImage(#imageLiteral(resourceName: "addIcon"), for: .normal)
        button.addTarget(self, action: #selector(addNewView), for: .touchUpInside)
        addView.addSubview(button)
    }

    @objc func addNewView() {
//
        let subViews = mainView.subviews
        print(subViews.count)
        if let lastView = subViews.filter({$0.tag == subViews.count}).first {
        removeAddBtnFromLastView(lastView: lastView)
            print(lastView.tag)
            print(lastView.frame)
            var frame = CGRect()
            switch currentObjPos {
            case .middle:
                 frame = CGRect(x: (lastView.frame.origin.x + lastView.frame.size.width) - 45, y: (lastView.frame.height - lastView.frame.origin.y) - 10 , width: 100, height: 100)
                currentObjPos = .top
            case .top:
                frame = CGRect(x: lastView.frame.origin.x, y: ((lastView.frame.height * 2) + lastView.frame.origin.y)  - 35  , width: 100, height: 100)
                currentObjPos = .bottom
            case .bottom:
                frame =  CGRect(x: ((lastView.frame.origin.x + lastView.frame.size.width) - 45)   , y: (lastView.frame.origin.y - lastView.frame.height) + 20, width: 100, height: 100)
                currentObjPos = .middle
            }
        let newView = UIView(frame: frame)
        let path = roundedPolygonPath(rect: CGRect(x: 0.0, y: 0.0, width: newView.frame.width, height: newView.frame.height), lineWidth: 1, sides: 6, cornerRadius: 5, rotationOffset: 11)
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = 1
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.white.cgColor
        newView.layer.addSublayer(borderLayer)
        let button = UIButton(frame: CGRect(x: -5, y: 0, width: newView.frame.width, height: newView.frame.height))
        button.setImage(#imageLiteral(resourceName: "addIcon"), for: .normal)
        button.addTarget(self, action: #selector(addNewView), for: .touchUpInside)
        newView.addSubview(button)
        newView.tag = mainView.subviews.count + 1
        mainView.addSubview(newView)
        print(newView.frame)
        mainViewWCons.constant = newView.frame.origin.x + newView.frame.width + 10
        viewDidLayoutSubviews()
        }
    }
    
    func removeAddBtnFromLastView(lastView: UIView) {
        let subViews = lastView.subviews
        for view in subViews {
            if view.isKind(of: UIButton.self) {
                let button = view as! UIButton
                button.isUserInteractionEnabled = false
                button.setImage(nil, for: .normal)
                button.setTitle("Hi", for: .normal)
                button.setTitleColor(.green, for: .normal)
            }
        }
    }
    
    
    public func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides) // How much to turn at every corner
        let _: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)

        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
    
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint.init(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint.init(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0..<sides {
            angle += theta
            
            let corner = CGPoint.init(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint.init(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint.init(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint.init(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        
        path.close()
        
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
    
}

enum HexagonPosition {
    case middle
    case top
    case bottom
}

