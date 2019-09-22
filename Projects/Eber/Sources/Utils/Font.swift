//
//  Font.swift
//  Eber
//
//  Created by myung gi son on 22/09/2019.
//

import UIKit

extension CGFloat {
  var appleSDGothicNeoFont: AppleSDGothicNeoFont {
    return AppleSDGothicNeoFont(size: self)
  }
  var notoSansCJKKR: NotoSansCJKKR {
    return NotoSansCJKKR(size: self)
  }
}

struct NotoSansCJKKR {
  let size: CGFloat
  var regular: UIFont { return UIFont(name: "NotoSansChakma-Regular", size: self.size)! }
}

struct AppleSDGothicNeoFont {
  let size: CGFloat
  var thin: UIFont { return UIFont(name: "AppleSDGothicNeo-Thin", size: self.size)! }
  var light: UIFont { return UIFont(name: "AppleSDGothicNeo-Light", size: self.size)! }
  var regular: UIFont { return UIFont(name: "AppleSDGothicNeo-Regular", size: self.size)! }
  var bold: UIFont { return UIFont(name: "AppleSDGothicNeo-Bold", size: self.size)! }
  var semibold: UIFont { return UIFont(name: "AppleSDGothicNeo-SemiBold", size: self.size)! }
  var ultraLight: UIFont { return UIFont(name: "AppleSDGothicNeo-UltraLight", size: self.size)! }
  var medium: UIFont { return UIFont(name: "AppleSDGothicNeo-Medium", size: self.size)! }
}
