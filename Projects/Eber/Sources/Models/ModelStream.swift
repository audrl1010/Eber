//
//  ModelStream.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import RxSwift

private var streams: [String: Any] = [:]

extension ModelType {
  static var event: PublishSubject<Event> {
    let key = String(describing: self)
    if let stream = streams[key] as? PublishSubject<Event> {
      return stream
    }
    let stream = PublishSubject<Event>()
    streams[key] = stream
    return stream
  }
}
