//
//  VehicleService.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift

protocol VehicleServiceProtocol {
  func vehicles() -> Single<[Vehicle]>
}
