//
//  VehicleListViewControllerSpec.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift
import Stubber
import Nimble
import Quick

@testable import Eber

final class VehicleListViewControllerSpec: QuickSpec {
  override func spec() {
    func createReactor(
      vehicleService: VehicleServiceStub = .init(),
      alertService: AlertServiceStub = .init()
    ) -> VehicleListViewReactor {
      let cellReactorFactory = VehicleCellReactor.Factory(
        dependency: .init()
      )
      let factory = VehicleListViewReactor.Factory.init(
        dependency: .init(
          vehicleService: vehicleService,
          alertService: alertService,
          cellReactorFactory: cellReactorFactory
        )
      )
      return factory.create()
    }
    
    var reactor: VehicleListViewReactor!
    var viewController: VehicleListViewController!
    
    beforeEach {
      reactor = createReactor()
      reactor.isStubEnabled = true
      let vehicleListViewControllerFactory = VehicleListViewController.Factory(dependency: ())
      viewController = vehicleListViewControllerFactory.create(payload: .init(reactor: reactor))
      _ = viewController.view
    }
    
    describe("a view") {
      context("when loaded") {
        it("sends a refresh action") {
          expect(reactor.stub.actions.last).to(match) {
            if case .refresh = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }
    }
  }
}
