platform :ios, '12.0'

use_frameworks!
inhibit_all_warnings!

target 'Eber' do
  # UI
  pod 'SnapKit'
  pod 'ManualLayout'
  pod 'AloeStackView'
  pod 'TouchAreaInsets'
  pod 'SwiftyColor'
  pod 'SwiftyImage'
  pod 'ReusableKit'
  pod 'URLNavigator'

  # DI
  pod 'Pure'
  pod 'Pure/Stub'

  # Networking
  pod 'Moya', '14.0.0-beta.2'
  pod 'Moya/RxSwift'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxViewController'
  pod 'RxCodable'
  pod 'RxOptional'
  pod 'RxKeyboard'
  
  # Architecture
  pod 'ReactorKit'

  # Logger
  pod 'CocoaLumberjack/Swift'

  # Misc
  pod 'R.swift'
  pod 'Then'
  pod 'KeychainAccess'
  pod 'CGFloatLiteral'
  
  target 'EberTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'Stubber'
    pod 'Nimble'
    pod 'Quick'
  end

end
