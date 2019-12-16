#
# Be sure to run `pod lib lint Debugo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Debugo'
  s.version          = '0.2.8'
  s.summary          = '☄️ 一个可能有点用的 iOS 调试工具~'
  s.homepage         = 'https://github.com/ripperhe/Debugo'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ripperhe' => '453942056@qq.com' }
  s.source           = { :git => 'https://github.com/ripperhe/Debugo.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |sb|
    sb.source_files = 'Debugo/Classes/**/*'
    sb.resources = 'Debugo/Assets/Debugo.bundle'
    sb.dependency 'FMDB', '>= 2.7.2'
  end
end
