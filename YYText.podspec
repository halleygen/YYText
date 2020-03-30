Pod::Spec.new do |s|
  s.name         = 'YYText'
  s.summary      = 'Powerful text framework for iOS to display and edit rich text.'
  s.version      = '1.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'ibireme' => 'ibireme@gmail.com' }
  s.social_media_url = 'http://blog.ibireme.com'
  s.homepage     = 'https://github.com/ibireme/YYText'
  s.platform     = :ios, '13.0'
  s.ios.deployment_target = '13.0'
  s.source       = { :git => 'https://github.com/halleygen/YYText.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'Sources/**/*.{h,m}'
  s.public_header_files = 'Sources/**/*.{h}'
  
  s.frameworks = 'UIKit', 'CoreFoundation','CoreText', 'QuartzCore', 'Accelerate', 'CoreServices'

end
