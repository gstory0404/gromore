#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gromore.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gromore'
  s.version          = '0.0.1'
  s.summary          = '穿山甲gromore聚合广告插件flutter版'
  s.description      = <<-DESC
穿山甲gromore聚合广告插件flutter版
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.static_framework = true
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'
  # 穿山甲sdk
  s.dependency 'Ads-CN','~> 5.3.0.4'
  s.dependency 'MJExtension','~> 3.4.0'
  #gromore sdk
  s.vendored_frameworks = 'sdk/ABUAdSDK.framework','sdk/ABUAdCsjAdapter.framework'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
