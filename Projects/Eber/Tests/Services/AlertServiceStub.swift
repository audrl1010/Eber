//
//  AlertServiceStub.swift
//  Eber
//
//  Created by myung gi son on 23/09/2019.
//

import UIKit
import RxSwift
import Stubber

@testable import Eber

final class AlertServiceStub: AlertServiceProtocol {
  
  func show<Alert: AlertType, Action>(alert: Alert) -> Observable<Action> where Alert.Action == Action {
    return Stubber.invoke(show, args: alert, default: .never())
  }
  
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action> {
    return Stubber.invoke(show, args: (title, message, preferredStyle, actions), default: .never())
  }
}
