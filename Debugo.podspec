#
# Be sure to run `pod lib lint Debugo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Debugo'
  s.version          = '0.4.0'
  s.summary          = 'iOS 应用内调试工具，支持 AFNetworking / Alamofire 请求、业务日志、文件浏览与自定义指令。'
  s.description      = <<-DESC
    Debugo 提供悬浮调试入口，集成 AFNetworking / Alamofire 请求查看、业务日志、沙盒与数据库预览、
    App 信息、快速登录、触摸监听及视图背景色调试，支持自定义指令与插件。
    AFNetworking 监听接入业务持有的 AFURLSessionManager。
    Alamofire 监听接入业务持有的 Session，Debugo 不把 Alamofire 作为硬依赖。
  DESC
  s.homepage         = 'https://github.com/ripperhe/Debugo'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ripperhe' => '453942056@qq.com' }
  s.source           = { :git => 'https://github.com/ripperhe/Debugo.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.requires_arc = true
  s.default_subspec = 'Core'
  s.preserve_paths = 'Debugo/Optional/Alamofire/DGAlamofireSessionHook.swift'

  s.subspec 'Core' do |sb|
    sb.source_files = 'Debugo/Classes/**/*.{h,m}'
    sb.frameworks = 'Foundation', 'UIKit', 'QuickLook', 'WebKit'
    sb.resources = 'Debugo/Assets/Debugo.bundle'
    sb.dependency 'FMDB', '>= 2.7.2'
    sb.dependency 'AFNetworking', '>= 4.0.1'
  end
end
