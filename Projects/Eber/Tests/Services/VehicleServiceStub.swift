//
//  VehicleServiceStub.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import RxSwift
import Stubber

@testable import Eber

final class VehicleServiceStub: VehicleServiceProtocol {
  func vehicles() -> Single<[Vehicle]> {
    return Stubber.invoke(vehicles, args: (), default: .never())
  }
}
