//
//  NetworkingAlert.swift
//  Eber
//
//  Created by myung gi son on 22/09/2019.
//

import UIKit

struct NetworkingAlert: AlertType {
  let clientError: EberClientError
  
  var title: String? {
    return "에러"
  }
  
  var style: UIAlertAction.Style {
    return .default
  }
  
  var message: String? {
    return clientError.message
  }
  
  var actions: [NetworkingAlertAction] {
    return [.leave]
  }
  
  var preferredStyle: UIAlertController.Style {
    return .alert
  }
}

enum NetworkingAlertAction: AlertActionType {
  case leave
  
  var title: String? {
    switch self {
    case .leave:
      return "확인"
    }
  }
  
  var style: UIAlertAction.Style {
    switch self {
    case .leave:
      return .default
    }
  }
}

