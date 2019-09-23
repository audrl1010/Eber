//
//  AlertService.swift
//  Eber
//
//  Created by myung gi son on 22/09/2019.
//

import UIKit
import RxSwift
import URLNavigator

protocol AlertType {
  associatedtype Action: AlertActionType
  
  var title: String? { get }
  var message: String? { get }
  var actions: [Action] { get }
  var preferredStyle: UIAlertController.Style { get }
}

protocol AlertActionType {
  var title: String? { get }
  var style: UIAlertAction.Style { get }
}

extension AlertActionType {
  var style: UIAlertAction.Style {
    return .default
  }
}

protocol AlertServiceProtocol: class {
  func show<Alert: AlertType, Action>(alert: Alert) -> Observable<Action> where Alert.Action == Action
  func show<Action: AlertActionType>(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [Action]) -> Observable<Action>
}

final class AlertService: AlertServiceProtocol {
  func show<Alert: AlertType, Action>(alert: Alert) -> Observable<Action> where Alert.Action == Action {
    return Observable.create { observer in
      let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.preferredStyle)
      for action in alert.actions {
        let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
          observer.onNext(action)
          observer.onCompleted()
        }
        alertController.addAction(alertAction)
      }
      Navigator().present(alertController)
      return Disposables.create {
        alertController.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action> {
    return Observable.create { observer in
      let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
      for action in actions {
        let alertAction = UIAlertAction(title: action.title ?? "", style: action.style) { _ in
          observer.onNext(action)
          observer.onCompleted()
        }
        alertController.addAction(alertAction)
      }
      Navigator().present(alertController)
      return Disposables.create {
        alertController.dismiss(animated: true, completion: nil)
      }
    }
  }
}
