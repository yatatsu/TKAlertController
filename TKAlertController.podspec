Pod::Spec.new do |s|
  s.name         = "TKAlertController"
  s.version      = "0.0.1"
  s.summary      = "UIAlertController for and under iOS8"
  s.homepage     = "http://github.com/yatatsu/TKAlertController"

  s.license      = "MIT"

  s.author             = { "kitagawa" => "yatatsukitagawa@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "6.0"

  s.source       = { :git => "http://EXAMPLE/TKAlertController.git", :tag => "0.0.1" }

  s.source_files  = "TKAlertController/*.{h,m}"
  s.exclude_files = "TKAlertControllerSample", "TKAlertControllerTests"
  s.require_arc   = true
end
