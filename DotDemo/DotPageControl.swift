//
//  DotPageController.swift
//  DotDemo
//
//  Created by ak on 2019/3/16.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
public class Line: CALayer {
  var dotWidth: CGFloat = 10
  var lineWidth: CGFloat = 3
  var tintColor: UIColor? = .red
  
  fileprivate var gap: CGFloat = 0
  fileprivate var index: Int = 0
  
  @objc dynamic var distance: CGFloat = 0 {
    didSet {
      index = gap > 0 ? Int(distance / gap) : 0
    }
  }
  
  func move(to: CGFloat) {
    distance = to
    setNeedsDisplay()
  }
  
  public override func draw(in ctx: CGContext) {
    //draw a line
    let path = UIBezierPath()
    path.lineWidth = lineWidth
    path.lineCapStyle = .round
    let y = height / 2
    path.move(to: CGPoint(x: 0, y: y))
    path.addLine(to: CGPoint(x: distance, y: y))
    ctx.setStrokeColor(tintColor!.cgColor)
    ctx.addPath(path.cgPath)
    ctx.strokePath()
    
    do {//draw circles
      guard index >= 0 else { return }
      let path = UIBezierPath()
      let y = height / 2
      for i in 0...index {
        path.addArc(withCenter: CGPoint(x: dotWidth * 0.5 + CGFloat(i) * gap, y: y), radius: dotWidth * 0.5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
      }
      ctx.setLineWidth(dotWidth * 0.5)
      ctx.setFillColor(tintColor!.cgColor)
      ctx.addPath(path.cgPath)
      ctx.fillPath()
    }
  }
  
  public override class func needsDisplay(forKey: String) -> Bool {
    if forKey == "distance" {
      return true
    }
    return super.needsDisplay(forKey: forKey)
  }
  
}

public class Dot: CALayer {
//  @objc dynamic var strech: CGFloat = 0
  var dotWidth: CGFloat = 20
  var isForward: Bool = true
  @objc dynamic var strech: CGFloat = 0
  var innerFrame: CGRect = .zero
  var lastOffset: CGFloat = 0
  var offset: CGFloat = 0
  @objc dynamic var distance: CGFloat = 0 {
    didSet {
      strech = min(1, max(0, abs((offset - lastOffset) / UIScreen.main.bounds.size.width)))
      innerFrame = CGRect(x: distance , y: height * 0.5 - dotWidth * 0.5, width: dotWidth, height: dotWidth)
      isForward = oldValue < distance
    }
  }
  
  public override func draw(in ctx: CGContext) {
    let offset = innerFrame.size.width / 3.6
    let center = CGPoint(x: innerFrame.midX, y: innerFrame.midY)
    let extra = innerFrame.size.width * 2 / 5 * strech
    
    print("innerFrame:\(innerFrame) offset:\(offset) extra:\(extra) strech:\(strech)")
    let p1 = CGPoint(x: center.x, y: innerFrame.minY + extra)
    let p2 = CGPoint(x: isForward ? innerFrame.maxX : innerFrame.maxX + extra, y: center.y)
    
    let p3 = CGPoint(x: center.x, y: innerFrame.maxY - extra)
    let p4 = CGPoint(x: isForward ? innerFrame.minX - extra * 2 : innerFrame.minX, y: center.y)
    
    let d1 = CGPoint(x: p1.x + offset, y: p1.y)
    let d2 = CGPoint(x: p2.x, y: p2.y - offset)
    
    let d3 = CGPoint(x: p2.x, y: p2.y + offset)
    let d4 = CGPoint(x: p3.x + offset, y: p3.y)
    
    let d5 = CGPoint(x: p3.x - offset, y: p3.y)
    let d6 = CGPoint(x: p4.x, y: p4.y + offset)
    
    let d7 = CGPoint(x:p4.x, y: p4.y - offset )
    let d8 = CGPoint(x: p1.x - offset, y: p1.y)
    
    let path = UIBezierPath()
    path.move(to: p1)
    path.addCurve(to: p2, controlPoint1: d1, controlPoint2: d2)
    path.addCurve(to: p3, controlPoint1: d3, controlPoint2: d4)
    path.addCurve(to: p4, controlPoint1: d5, controlPoint2: d6)
    path.addCurve(to: p1, controlPoint1: d7, controlPoint2: d8)
    path.close()
    
    ctx.setLineWidth(dotWidth * 0.5)
    ctx.setFillColor(UIColor.green.cgColor)
    ctx.addPath(path.cgPath)
    ctx.fillPath()
  }
  
  func move(to: CGFloat, offset: CGFloat, lastOffset: CGFloat) {
    self.offset = offset
    self.lastOffset = lastOffset
    distance = to
    setNeedsDisplay()
  }
  
  public override class func needsDisplay(forKey: String) -> Bool {
    if forKey == "strech" || forKey == "distance" {
      return true
    }
    return super.needsDisplay(forKey: forKey)
  }
}

public class DotPageControl: UIView {
  let scrollView: UIScrollView!
  var numberOfPages: Int = 0 // default is
  var previousOffset: CGFloat = 0
  var currentPage: CGFloat = 0 {
    didSet {
      previousOffset = currentPage - oldValue
      previousPage = oldValue
      updateCurrentPageDisplay()
    }
  }
  
  var currentPageIndicatorTintColor: UIColor? = .red {
    didSet {
      line.tintColor = currentPageIndicatorTintColor
    }
  }
  var dotWidth: CGFloat = 10 {
    didSet {
      line.dotWidth = dotWidth
      dot.dotWidth = dotWidth
    }
  }
  
  private lazy var line = Line(layer: layer)
  private lazy var dot = Dot(layer: layer)
  private var previousPage: CGFloat = 0
  private var pageWidth: CGFloat = 0
  var lastOffset: CGFloat = 0
  
  public init(frame: CGRect, scrollView: UIScrollView) {
    self.scrollView = scrollView
    super.init(frame: frame)
    line.frame = bounds
    dot.frame = bounds
    line.contentsScale = UIScreen.main.scale
    dot.contentsScale = UIScreen.main.scale
    layer.addSublayer(line)
    layer.addSublayer(dot)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func willMove(toWindow newWindow: UIWindow?) {
    if newWindow != nil {
      line.move(to: 0)
      dot.move(to: 0, offset: 0, lastOffset: 0)
    }
  }
  
  func updateCurrentPageDisplay() {
    pageWidth = (width - line.dotWidth) / CGFloat(numberOfPages - 1)
    lineAnimate()
    let x = CGFloat(currentPage) * pageWidth
    dot.move(to: x, offset: currentPage * UIScreen.main.bounds.size.width, lastOffset: self.lastOffset)
//    dot.move(to: currentPage * UIScreen.main.bounds.size.width, offset: self.lastOffset)
//    dotAnimate()
  }
  
  func lineAnimate() {
    let preX = CGFloat(previousPage) * pageWidth
    let x = CGFloat(currentPage) * pageWidth
    let lineAni = CAKeyframeAnimation(keyPath: "distance")
    lineAni.duration = 0.01
    lineAni.fillMode = CAMediaTimingFillMode(rawValue: CAMediaTimingFunctionName.easeInEaseOut.rawValue)
    lineAni.values = [preX, x]
    lineAni.isRemovedOnCompletion = false
    line.gap = pageWidth
    line.distance = x
    line.add(lineAni, forKey: "lineAnimation")
  }
  
  func dotAnimate() {
//    let x = CGFloat(currentPage) * pageWidth
//    dot.move(to: x, offset: <#T##CGFloat#>)
    return;
//    guard numberOfPages > 0 else { return }
    let preX = CGFloat(previousPage) * pageWidth
    
//    let distance = CGFloat(currentPage) * pageWidth
//    dot.innerFrame = CGRect(x: distance - dotWidth * 0.5, y: height * 0.5 - dotWidth * 0.5, width: dotWidth, height: dotWidth)
    
//    let x = min(1, max(0, previousOffset))
    
    print("dotAnimate strech:\(x)")

    let ani = CAKeyframeAnimation(keyPath: "strech")
    ani.duration = 0.8
    ani.fillMode = CAMediaTimingFillMode(rawValue: CAMediaTimingFunctionName.easeInEaseOut.rawValue)
//    fromValue:@(0.5 + [howmanydistance floatValue] * 1.5)
//    toValue:@(0)];
//    ani.values = [ 0.5 + (1 / CGFloat(numberOfPages) ) * 1.5, 0]
//    ani.values = [0.691, 0]////    previousOffset
    ani.values = [0.1,-0.1,0]
//    ani.values = [preX, x]
    ani.isRemovedOnCompletion = false
    dot.strech = 0
    dot.add(ani, forKey: "dotAnimation")
  }
}

