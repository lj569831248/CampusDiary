# DroiCoreSDK 
A library provides you to use powerful DroiBaaS cloud service from your iOS app. DroiCore SDK is foundation library of DroiBaaS. For more information, see [DroiBaaS](https://github.com/DroiBaaS/DroiBaaS-Core-iOS).

# Using DroiCoreSDK

## Installation
The easiest way to use DroiCoreSDK is with [CocoaPods](http://cocoapods.org). Add the following lines to your `Podfile`.

```ruby
pod 'DroiCoreSDK'

post_install do |installer|
	require './Pods/DroiCoreSDK/scripts/postInstall.rb'
	DroiCoreParser.installParser()
end
```

## Using DroiCoreSDK in your iOS code

1. Add `App Transport Security Settings/Allow Arbitary Loads` into `Info.plist` and set the property value to `YES`  
2. Add your `DROI_APP_ID` property with Application ID from DroiBaaS website into `Info.plist`.
3. Add `[DroiCore initializeCore];` in `application:didFinishLaunchingWithOption` method.
4. For more information, please see [DroiBaaS](https://github.com/DroiBaaS/DroiBaaS-Core-iOS).

# Example Project
