//
//  VehicleListViewSectionItemBackgroundView.swift
//  Eber
//
//  Created by myung gi son on 26/09/2019.
//

import UIKit

class VehicleListViewSectionItemBackgroundView: CollectionBackgroundView {
  var foregroundLayer = CALayer()
  var backgroundLayer = CALayer()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.addSublayer(self.backgroundLayer)
    self.layer.addSublayer(self.foregroundLayer)
    
    self.foregroundLayer.masksToBounds = true
    self.foregroundLayer.cornerRadius = 4
    self.foregroundLayer.backgroundColor = UIColor.white.cgColor
    
    self.backgroundLayer.masksToBounds = false
    self.backgroundLayer.shadowColor = UIColor.black.cgColor
    self.backgroundLayer.shadowOffset = CGSize(width: 0, height: 1)
    self.backgroundLayer.shadowOpacity = 0.5
    self.backgroundLayer.shadowRadius = 1.3
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundLayer.frame = self.bounds
    self.foregroundLayer.frame = self.bounds
    
    self.backgroundLayer.shadowPath = UIBezierPath(
      roundedRect: self.bounds,
      cornerRadius: self.foregroundLayer.cornerRadius
    ).cgPath
  }
}
