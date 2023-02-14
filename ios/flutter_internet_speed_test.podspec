#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_internet_speed_test.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_internet_speed_test'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin to test internet download and upload speed.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/shaz-tech/flutter_internet_speed_test'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Shaz Tech' => 'meshahbaz.akhtar@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end