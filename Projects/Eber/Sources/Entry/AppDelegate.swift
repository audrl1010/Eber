//
//  AppDelegate.swift
//  asdfasdfasfasdfasdf
//
//  Created by myung gi son on 18/09/2019.
//  Copyright © 2019 Myung Gi Son. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  private let dependency: AppDependency
  
  var window: UIWindow?
  
  private override init() {
    self.dependency = AppDependency.resolve()
  }
  
  init(dependency: AppDependency) {
    self.dependency = dependency
  }
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = UIViewController()
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
