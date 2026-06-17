#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tm_wifi_connect.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tm_wifi_connect'
  s.version          = '0.0.1'
  s.summary          = 'Techmagic WiFi connect plugin.'
  s.description      = <<-DESC
A low dependency Flutter plugin to connect to WiFi networks, with cross-platform
isEnabled / activateWifi / deactivateWifi support.
                       DESC
  s.homepage         = 'https://techmagic.co'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Techmagic' => 'info@techmagic.co' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.frameworks = 'NetworkExtension', 'SystemConfiguration'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
