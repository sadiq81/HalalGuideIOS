source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

# ignore all warnings from all pods
inhibit_all_warnings!

# Code
pod 'LinqToObjectiveC', '2.0.0'
pod 'DCKeyValueObjectMapping', '1.4'
pod 'ALActionBlocks', '1.0.3'
pod 'UIAlertController+Blocks', '0.8'
pod 'ReactiveCocoa', '2.4.7'

#Networking
pod 'AFNetworking', '2.5.0'
pod 'AFNetworking-RACExtensions', '0.1.6'
pod 'AsyncImageView', '1.5.1'

# UI
pod 'MZFormSheetController', '2.3.6'
pod 'IQKeyboardManager', '3.2.0.2'
pod 'ClusterPrePermissions', '~> 0.1'
pod 'HTAutocompleteTextField', '1.3.1'
pod 'EDStarRating', '1.1'
pod 'SVProgressHUD', '1.1.3'
pod 'iCarousel', '1.8.1'
pod 'CTAssetsPickerController', '~> 2.9.3'
pod 'KASlideShow', :git => 'https://github.com/sadiq81/KASlideShow.git'
pod 'JSBadgeView', '1.3.2'
pod 'SevenSwitch', '1.4.0'
pod 'SZTextView', '1.2.0'
pod "ZLPromptUserReview", "~>1.0.0"
pod 'Masonry', '0.6.1'
pod 'pop', '~> 1.0'

#Parse
pod 'Facebook-iOS-SDK', '4.0.1'
pod 'Parse','1.7.1'
pod 'ParseUI','1.1.3'
pod 'ParseFacebookUtilsV4', '1.7.1'

# In App
pod 'RMStore', '~> 0.7'

pod 'HTMLReader'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'HalalGuide/Supporting Files/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

