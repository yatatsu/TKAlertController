Pod::Spec.new do |s|
  s.name         = "TKAlertController"
  s.version      = "0.0.4"
  s.summary      = "UIAlertController for and under iOS8"
  s.homepage     = "https://github.com/yatatsu/TKAlertController"

  s.license      = "MIT"

  s.author             = { "kitagawa" => "yatatsukitagawa@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "6.0"

  s.source       = { :git => "https://github.com/yatatsu/TKAlertController.git", :tag => "0.0.4" }

  s.source_files  = "TKAlertController/*.{h,m}"
  s.exclude_files = "TKAlertControllerSample", "TKAlertControllerTests"
  s.requires_arc  = true
end
