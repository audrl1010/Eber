//
//  VehicleFavoriteButtonViewReactorSpec.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import Nimble
import Quick
import Stubber

@testable import Eber

final class VehicleFavoriteButtonViewReactorSpec: QuickSpec {
  
  override func spec() {
    
    func sendActionSetIdPassword(to reactor: SignInViewReactor) {
      reactor.action.onNext(.setId(AuthFixture.auth.id))
      reactor.action.onNext(.setPassword(AuthFixture.auth.password))
    }
    
    var vehicleService: VehicleServiceStub!
    var reactor: VehicleFavoriteButtonViewReactor!
    
    beforeEach {
      vehicleService = VehicleServiceStub()
      let factory = VehicleFavoriteButtonViewReactor.Factory.stub(
        vehicleService: vehicleService,
        alertService: AlertServiceStub()
      )
      reactor = factory.create(payload: .init(vehicle: VehicleFixture.vehicle1))
    }
    
    describe("an initial state") {
      it("is not loading") {
        expect(reactor.currentState.isLoading) == false
      }
    }
    
    describe("state.isFavorite") {
      it("is same with the initialized parameter value") {
        expect(reactor.currentState.isFavorite) == VehicleFixture.vehicle1.favorite
      }
    }
    
    context("when receives an action.toggleFavorite") {
      it("tries to toggle favorite") {
        Stubber.register(vehicleService.favorite) { _ in .just(()) }
        Stubber.register(vehicleService.unfavorite) { _ in .just(()) }
        reactor.action.onNext(.toggleFavorite)
        expect(Stubber.executions(vehicleService.favorite).count) == 1
      }
    }
    
    context("when receives Vehicle.event.updateFavorite") {
      it("set favorite") {
        Vehicle.event.onNext(.updateFavorite(vehicleIdx: VehicleFixture.vehicle1.vehicleIdx, isFavorite: true))
        expect(reactor.currentState.isFavorite) == true
      }
      it("set unfavorite") {
        Vehicle.event.onNext(.updateFavorite(vehicleIdx: VehicleFixture.vehicle1.vehicleIdx, isFavorite: false))
        expect(reactor.currentState.isFavorite) == false
      }
    }
    
    describe("state.isLoading") {
      context("while toggling") {
        it("is loading") {
          Stubber.register(vehicleService.favorite) { _ in .never() }
          Stubber.register(vehicleService.unfavorite) { _ in .never() }
          reactor.action.onNext(.toggleFavorite)
          expect(reactor.currentState.isLoading) == true
        }
      }
      
      context("when finished toggling") {
        it("is not loading") {
          Stubber.register(vehicleService.favorite) { _ in .just(()) }
          Stubber.register(vehicleService.unfavorite) { _ in .just(()) }
          reactor.action.onNext(.toggleFavorite)
          expect(reactor.currentState.isLoading) == false
        }
      }
    }
  }
}
