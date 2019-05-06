#
# Be sure to run `pod lib lint ARModelGenerator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ARModelGenerator'
    s.version          = '1.0.2'
    s.summary          = 'Augmented Reality model generator'
    s.description      = 'This pod is used to generate 3d models on top of a given marker'
    s.homepage         = 'https://github.com/RapsusMTN'
    s.swift_version    = '4.2'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Jorge Martin' => 'jmartin@fiveflamesmobile.com' }
    s.source           = { :git => 'https://github.com/RapsusMTN/ARModelGenerator.git', :tag => '1.0.2' }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '9.0'
    
    s.source_files = 'ARModelGenerator/Classes/**/*'
    s.public_header_files = 'ARModelGenerator/Classes/**/*.h'
    s.frameworks = 'UIKit', 'ARKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
