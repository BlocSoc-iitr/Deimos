#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mopro_flutter.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'mopro_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  
  # Vendor both frameworks
  s.vendored_frameworks = 'Frameworks/MoproCircomBindings.xcframework', 'Frameworks/MoproNoirBindings.xcframework'
  s.preserve_paths = 'Frameworks/MoproCircomBindings.xcframework/**/*', 'Frameworks/MoproNoirBindings.xcframework/**/*'
  
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64',
    'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/Frameworks/MoproCircomBindings.xcframework/ios-arm64/Headers/deimos_circom" "$(PODS_TARGET_SRCROOT)/Frameworks/MoproNoirBindings.xcframework/ios-arm64/Headers/deimos_noir"',
    'OTHER_SWIFT_FLAGS' => '-Xcc -fmodule-map-file="$(PODS_TARGET_SRCROOT)/Frameworks/MoproCircomBindings.xcframework/ios-arm64/Headers/deimos_circom/module.modulemap" -Xcc -fmodule-map-file="$(PODS_TARGET_SRCROOT)/Frameworks/MoproNoirBindings.xcframework/ios-arm64/Headers/deimos_noir/module.modulemap"'
  }
  s.swift_version = '5.0'
end
