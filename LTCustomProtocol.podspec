#
#  Be sure to run `pod spec lint LTCustomProtocol.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LTCustomProtocol"
  s.version      = "0.0.2"
  s.summary      = "Some custom protocols that speed development."

  s.description  = <<-DESC
  Some custom protocols that speed development.
                   DESC

  s.homepage     = "https://github.com/TopSkySir/LTCustomProtocol.git"
 
  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "TopSkySir" => "TopSkyComeOn@163.com" }
  s.platform     = :ios, '8.0'


  s.source       = { :git => "https://github.com/TopSkySir/LTCustomProtocol.git", :tag => "#{s.version}" }
  s.swift_version = "4.0"


  s.subspec 'ScrollViewRefresh' do |scrollViewRefresh|
    scrollViewRefresh.ios.deployment_target = '8.0'
    scrollViewRefresh.source_files = 'Sources/ScrollViewRefresh/*.swift'
    scrollViewRefresh.dependency 'MJRefresh', '~> 3.1.15.3'
  end

  s.subspec 'RequestStatus' do |requestStatus|
  	requestStatus.ios.deployment_target = '8.0'
    requestStatus.source_files = 'Sources/RequestStatus/*.swift'
  end


end
