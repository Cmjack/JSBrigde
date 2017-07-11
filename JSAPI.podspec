#
#  Be sure to run `pod spec lint JSAPI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|

  s.name         = "JSAPI"
  s.version      = "0.0.1"
  s.summary      = "JSBrigdeFramework"
  s.description  = <<-DESC
                    WKWebView 与 JS 交互 API
                   DESC
  s.homepage     = "https://kakatrip.cn/"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "CaiMing" => "ming.cai@kakatrip.cn" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://git.oschina.net/kakaBTravel/JSAPI.git", :tag => "#{s.version}" }
  s.source_files  = "Pod/Classes/*.{h,m}"
  s.requires_arc = true

  s.dependency "KKProgressHUD"
  s.dependency "KKRouter" 

end
