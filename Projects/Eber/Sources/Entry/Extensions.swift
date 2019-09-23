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
import RxSwift
import RxCocoa
import JGProgressHUD

extension AloeStackView {
  open func addRow(_ row: UIView, inset: UIEdgeInsets) {
    self.addRow(row)
    self.setInset(forRow: row, inset: inset)
  }
}

extension Reactive where Base: JGProgressHUD {
  func animate(in view: UIView) -> Binder<Bool> {
    return Binder(self.base) { [weak view] progress, isAnimating in
      guard let `view` = view else { return }
      isAnimating ? progress.show(in: view) : progress.dismiss(animated: true)
    }
  }
}
