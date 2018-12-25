#
# Be sure to run `pod lib lint Earth.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Earth'
  s.version          = '0.1.7'
  s.summary          = 'A custmizable and easy to use framework contains Country Picker and awesome vector flags. Support both iOS and MacOS'
  s.description      = <<-DESC
It offers different kind of pickers for picking infomations about countries etc. You can access vector images of flags. It support 12 kinds of languages.
                       DESC

  s.homepage         = 'https://github.com/leacode/Earth'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leacode' => 'lichunyu@vip.qq.com' }
  s.source           = { :git => 'https://github.com/leacode/Earth.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target  = '10.10'
  
  s.source_files       = 'Sources/Earth/*.swift'
  s.ios.source_files   = 'Sources/ios/*.swift'
  # s.osx.source_files   = 'Earth/Classes/osx/*.swift'

  # s.ios.source_files = 'Earth/Classes/**/*'
  # s.osx.source_files = 'Earth/Classes/**/*'
  
  s.resource_bundles = {
    'Earth' => ['Resources/*', 'Resources/*.lproj/*.strings', 'Resources/*.xcassets',]
  }
  
  s.ios.framework  = 'UIKit'
  s.osx.framework  = 'AppKit'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
