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
    var cellReactorFactory: VehicleCellReactor.Factory!
    var reactor: VehicleListViewReactor!
    var viewController: VehicleListViewController!
    
    beforeEach {
      let vehicleService = VehicleServiceStub()
      let alertService = AlertServiceStub()
      
      cellReactorFactory = VehicleCellReactor.Factory()
      let factory = VehicleListViewReactor.Factory(
        dependency: .init(
          vehicleService: vehicleService,
          alertService: alertService,
          cellReactorFactory: cellReactorFactory
        )
      )
      reactor = factory.create()
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
    
    describe("a searchBarView") {
      context("when inputting") {
        it("sends a updateQuery action") {
          let query = "vehicle"
          viewController.searchBarView.textField.text = query
          viewController.searchBarView.textField.sendActions(for: .editingChanged)
          expect(reactor.stub.actions.last).to(match) {
            if case let .updateQuery(queryToUpdate) = $0 {
              return query == queryToUpdate
            } else {
              return false
            }
          }
        }
      }
    }
    
    describe("a activityIndicatorView") {
      context("when loading state") {
        it("is animating") {
          reactor.stub.state.value.isLoading = true
          expect(viewController.activityIndicatorView.isAnimating) == true
        }
      }
      context("when not loading state") {
        it("is not animating") {
          reactor.stub.state.value.isLoading = false
          expect(viewController.activityIndicatorView.isAnimating) == false
        }
      }
    }
    
    context("when cell`favorite button taps") {
      it("sends toggleFavorite action to reactor") {
        let sectionItems = [VehicleFixture.vehicle1, VehicleFixture.vehicle2]
          .map(cellReactorFactory.create)
          .map(VehicleListViewSection.Item.init)
        
        reactor.stub.state.value.sectionItems = sectionItems
        viewController.collectionView.cell(VehicleCell.self, at: 0, 0)?.favoriteButton.sendActions(for: .touchUpInside)
        expect(reactor.stub.actions.last).to(match) {
          if case .toggleFavorite = $0 {
            return true
          } else {
            return false
          }
        }
      }
    }
    
    context("when sections have vehicles") {
      it("has vehicle cells") {
        let sectionItems = [VehicleFixture.vehicle1, VehicleFixture.vehicle2]
          .map(cellReactorFactory.create)
          .map(VehicleListViewSection.Item.init)
        
        reactor.stub.state.value.sectionItems = sectionItems
        expect(viewController.collectionView.cell(VehicleCell.self, at: 0, 0)?.reactor) === sectionItems[0].cellReactor
        expect(viewController.collectionView.cell(VehicleCell.self, at: 0, 1)?.reactor) === sectionItems[1].cellReactor
      }
    }
  }
}
