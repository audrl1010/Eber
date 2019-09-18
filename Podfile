platform :ios, '12.0'

use_frameworks!
inhibit_all_warnings!

target 'Eber' do

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxRelay'

  # DI
  pod 'Pure'
  pod 'Pure/Stub'

  # Networking
  pod 'Moya'
  pod 'RxDataSources'
  pod 'RxViewController'
  pod 'RxCodable'
  pod 'RxOptional'
  
  # Misc.
  pod 'Then'

  target 'EberTests' do
    inherit! :search_paths
    pod 'Nimble'
    pod 'Quick'
  end

end
