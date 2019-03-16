//
//  UIView+Ext.swift
//  DotDemo
//
//  Created by ak on 2019/3/16.
//  Copyright © 2019 ak. All rights reserved.
//  
import UIKit

extension UIView {
  
  public var width: CGFloat {
    return self.frame.size.width
  }
  
  public var height: CGFloat {
    return self.frame.size.height
  }
  
  public var x: CGFloat {
    get {
      return self.frame.origin.x
    }
    set {
      self.frame.origin.x = newValue
    }
  }
  
  public var y: CGFloat {
    get {
      return self.frame.origin.y
    }
    set {
      self.frame.origin.y = newValue
    }
  }
  
}


extension CALayer {
  
  public var width: CGFloat {
    return self.frame.size.width
  }
  
  public var height: CGFloat {
    return self.frame.size.height
  }
  
  public var x: CGFloat {
    get {
      return self.frame.origin.x
    }
    set {
      self.frame.origin.x = newValue
    }
  }
  
  public var y: CGFloat {
    get {
      return self.frame.origin.y
    }
    set {
      self.frame.origin.y = newValue
    }
  }
  
}
