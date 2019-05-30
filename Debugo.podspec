#
# Be sure to run `pod lib lint Debugo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Debugo'
  s.version          = '0.1.0'
  s.summary          = '☄️ A simple and practical iOS debugging tool. '
  s.homepage         = 'https://github.com/ripperhe/Debugo'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'ripperhe' => '453942056@qq.com' }
  s.source           = { git: 'https://github.com/ripperhe/Debugo.git', tag: s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |sb|
    sb.source_files = 'Debugo/Core/**/*'
    sb.dependency 'Debugo/Base'
    sb.dependency 'Debugo/Plugin'
  end

  s.subspec 'Base' do |sb|
    sb.source_files = 'Debugo/Base/Classes/**/*'
    sb.resources = 'Debugo/Base/Assets/**'
  end

  s.subspec 'Plugin' do |pg|
    pg.subspec 'DGDebuggingOverlay' do |sb|
      sb.source_files = 'Debugo/Plugin/DGDebuggingOverlay/**'
      sb.dependency 'Debugo/Base'
    end
    pg.subspec 'DGSuspensionView' do |sb|
      sb.source_files = 'Debugo/Plugin/DGSuspensionView/**'
      sb.dependency 'Debugo/Base'
    end
    pg.subspec 'DGFileBrowser' do |sb|
      sb.source_files = 'Debugo/Plugin/DGFileBrowser/**/*'
      sb.frameworks = 'QuickLook', 'WebKit'
      sb.dependency 'Debugo/Base'
      sb.dependency 'FMDB', '>= 2.7.2'
    end
    pg.subspec 'DGTouchMonitor' do |sb|
      sb.source_files = 'Debugo/Plugin/DGTouchMonitor/**'
      sb.dependency 'Debugo/Base'
    end
    pg.subspec 'DGFPSLabel' do |sb|
      sb.source_files = 'Debugo/Plugin/DGFPSLabel/**'
      sb.dependency 'Debugo/Base'
    end
  end
end
