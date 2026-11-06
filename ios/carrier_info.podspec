#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint carrier_info.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'carrier_info'
  s.version          = '4.0.0'
  s.summary          = 'Carrier info for Flutter: network type, generation, and SIM details.'
  s.description      = <<-DESC
Carrier Info gets network type, network generation, mobile country and network codes, and more from iOS and Android devices.
                       DESC
  s.homepage         = 'https://github.com/Zfinix/carrier_info'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Zfinix'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
