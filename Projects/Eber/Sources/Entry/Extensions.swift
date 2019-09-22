//
//  Extensions.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Then
import SwiftyColor
import CGFloatLiteral
import ManualLayout
import SwiftyImage
import RxViewController
import RxOptional
import AloeStackView

extension AloeStackView {
  open func addRow(_ row: UIView, inset: UIEdgeInsets) {
    self.addRow(row)
    self.setInset(forRow: row, inset: inset)
  }
}
