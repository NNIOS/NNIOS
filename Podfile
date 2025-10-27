platform :ios, '13.0'   

target 'Neighbrsnooks' do
  use_frameworks!
  pod 'SVProgressHUD'
 
  pod 'Kingfisher'
  pod 'iOSDropDown'
  pod 'GoogleMaps', '~> 7.0.0'
  pod 'IQKeyboardManagerSwift'
  pod 'TPKeyboardAvoidingSwift'
  pod 'GooglePlaces', '< 9.0'
  pod 'CropViewController'
  pod 'AlamofireImage'
  pod 'Material', '~> 3.1.0'
  pod 'Toaster'
  pod 'DropDown'
  pod 'SwiftyJSON'
  pod 'SwiftKeychainWrapper'
pod 'NVActivityIndicatorView/Presenter'

  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
