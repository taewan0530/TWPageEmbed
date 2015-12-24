
Pod::Spec.new do |s|
  s.name         = 'TWPageEmbed'
  s.version      = "0.0.1"
  s.summary      = 'TWPageEmbed'
  s.homepage     = 'https://github.com/taewan0530'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'taewan' => 'taewan0530@daum.net' }
  s.source       = { :git => "https://github.com/taewan0530/TWPageEmbed.git", :tag => s.version.to_s }
  s.source_files = 'Pod/*.{swift}',
  
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  
end
