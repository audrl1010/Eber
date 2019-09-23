//
//  SplashViewController.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Pure

final class SplashViewController: BaseViewController, View, FactoryModule {
  
  typealias Reactor = SplashViewReactor
  
  struct Payload {
    let reactor: Reactor
  }
  
  let splashImageView = UIImageView(image: R.image.splash())
  
  required init(dependency: Void, payload: Payload) {
    defer { self.reactor = payload.reactor }
    super.init()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .shamrock
    self.view.addSubview(self.splashImageView)
    
    self.splashImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  func bind(reactor: Reactor) {
    self.rx.viewDidAppear
      .map { _ in Reactor.Action.checkIfAuthenticated }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
}
