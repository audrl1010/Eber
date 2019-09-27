//
//  String+Extension.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import Foundation

extension String {
  func removeWhitespace() -> String {
    return self.replacingOccurrences(of: " ", with: "")
  }
  
  func isMatch(of query: String) -> Bool {
    return self.range(of: query) != nil
  }
}
