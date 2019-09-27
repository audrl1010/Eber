//
//  VehicleFavoriteButtonViewSpec.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import Nimble
import Quick
@testable import Eber

final class VehicleFavoriteButtonViewSpec: QuickSpec {
  override func spec() {
    var reactor: VehicleFavoriteButtonViewReactor!
    var view: VehicleFavoriteButtonView!
    
    beforeEach {
      let factory = VehicleFavoriteButtonViewReactor.Factory.stub(
        vehicleService: VehicleServiceStub(),
        alertService: AlertServiceStub()
      )
      reactor = factory.create(payload: .init(vehicle: VehicleFixture.vehicle1))
      reactor.isStubEnabled = true
      view = VehicleFavoriteButtonView()
      view.reactor = reactor
    }
    
    describe("a button") {
      context("when taps") {
        it("sends action.toggleFavorite") {
          view.button.sendActions(for: .touchUpInside)
          expect(reactor.stub.actions.last).to(match) {
            if case .toggleFavorite = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }
      
      context("when favorite") {
        it("has favorite background image") {
          reactor.stub.state.value.isFavorite = true
          expect(view.button.backgroundImage(for: .normal)) == R.image.favorite()
        }
      }
      
      context("when unfavorite") {
        it("has unfavorite background image") {
          reactor.stub.state.value.isFavorite = false
          expect(view.button.backgroundImage(for: .normal)) == R.image.unfavorite()
        }
      }
      
      context("when is loading") {
        it("is not enabled") {
          reactor.stub.state.value.isLoading = true
          expect(view.button.isEnabled) == false
        }
      }
      
      context("when not loading") {
        it("is enabled") {
          reactor.stub.state.value.isLoading = false
          expect(view.button.isEnabled) == true
        }
      }
    }
  }
}
