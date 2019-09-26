//
//  Int+toDecimal.swift
//  Eber
//
//  Created by myung gi son on 26/09/2019.
//

import Foundation

extension Int {
  func toDecimal() -> String {
    return NumberFormatter().then {
      $0.numberStyle = .decimal
    }.string(from: NSNumber(integerLiteral: self)) ?? ""
  }
}
