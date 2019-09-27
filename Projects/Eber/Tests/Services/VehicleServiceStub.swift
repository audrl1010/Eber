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
  
  func favorite(vehicleIdx: Int) -> Single<Void> {
    return Stubber.invoke(favorite, args: vehicleIdx, default: .never())
  }
  
  func unfavorite(vehicleIdx: Int) -> Single<Void> {
    return Stubber.invoke(unfavorite, args: vehicleIdx, default: .never())
  }
}
