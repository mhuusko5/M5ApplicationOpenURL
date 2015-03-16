Pod::Spec.new do |s|
  s.name = 'M5ApplicationOpenURL'
  s.version = '1.0.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'Respond to application open URL event on iOS *and* Mac *without owning/muddying the app delegate*. Easy. Decoupled.'
  s.homepage = 'https://github.com/mhuusko5/M5ApplicationOpenURL'
  s.social_media_url = 'https://twitter.com/mhuusko5'
  s.authors = { 'Mathew Huusko V' => 'mhuusko5@gmail.com' }
  s.source = { :git => 'https://github.com/mhuusko5/M5ApplicationOpenURL.git', :tag => s.version.to_s }
  s.source_files = '*.{h,m}'
  
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  
  s.frameworks = 'Foundation'
  s.ios.frameworks = 'UIKit'
  s.osx.frameworks = 'Cocoa'
end