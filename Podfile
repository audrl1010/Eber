platform :ios, '12.0'

use_frameworks!
inhibit_all_warnings!

target 'Eber' do
  # UI
  pod 'SnapKit'
  pod 'ManualLayout'
  pod 'AloeStackView'
  pod 'TouchAreaInsets'

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
  
  # Architecture
  pod 'ReactorKit'

  # Logger
  pod 'CocoaLumberjack/Swift'

  # Misc
  pod 'Then'

  target 'EberTests' do
    inherit! :search_paths
    pod 'Nimble'
    pod 'Quick'
  end

end
