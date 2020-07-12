#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_language_identification.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_language_identification'
  s.version          = '0.0.1'
  s.summary          = 'A flutter language identification plugin.'
  s.description      = <<-DESC
A flutter language identification plugin using Google's ML Kit.
                       DESC
  s.homepage         = 'http://github.com/dlutton/flutton_language_id'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tundralabs' => 'eyedea32@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'GoogleMLKit/LanguageID'
  s.platform = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
  s.static_framework = true
end
