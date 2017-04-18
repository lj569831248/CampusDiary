# Uncomment this line to define a global platform for your project
# platform:ios,'8.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'CampusDiary' do

pod 'Masonry'
pod 'FMDB'
pod 'SDWebImage'
pod 'MJRefresh'
pod 'MBProgressHUD'
pod 'DroiFeedbackSDK'
pod 'DroiPushSDK'
pod 'DroiAnalyticsSDK'
pod 'DroiOAuthSDK'
pod 'DroiSelfupdateSDK'
pod 'DroiCoreSDK'
post_install do |installer|
require './Pods/DroiCoreSDK/scripts/postInstall.rb'
DroiCoreParser.installParser()
end
end
