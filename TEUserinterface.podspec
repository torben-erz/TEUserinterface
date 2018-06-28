#
#  Be sure to run `pod spec lint TEUserinterface.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "TEUserinterface"
  s.version      = "1.0.4"
  s.summary 	 = "A Swift-Library for iOS Usercontrols"
  s.description  = <<-DESC
	A Swift-Library for iOS Usercontrols.
	Main use case is iOS-Applications.
                   DESC
  s.homepage      = "https://www.github.com/torben-erz/TEUserinterface"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "Torben Erz" => "torben.erz@gmail.com" }
  s.platform      = :ios, '9.0'
  s.source        = { :git => "https://github.com/torben-erz/TEUserinterface.git", :tag => s.version.to_s }
s.source_files  = 'TEUserinterface/Source/**/*.{swift}'
  s.frameworks    = 'Foundation', 'UIKit'
  s.swift_version = '4.0'
end
