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

  s.subspec 'Core' do |cr|
    cr.source_files = 'Debugo/Core/**/*'
    cr.dependency 'Debugo/Plugin'
  end

  s.subspec 'Plugin' do |pg|
    pg.subspec 'DGBase' do |ba|
      ba.source_files = 'Debugo/Plugin/DGBase/Classes/**/*'
      ba.resources = 'Debugo/Plugin/DGBase/Assets/**'
    end
    pg.subspec 'DGDebuggingOverlay' do |de|
      de.source_files = 'Debugo/Plugin/DGDebuggingOverlay/**'
    end
    pg.subspec 'DGSuspensionView' do |su|
      su.source_files = 'Debugo/Plugin/DGSuspensionView/**'
      su.dependency 'Debugo/Plugin/DGBase'
    end
    pg.subspec 'DGFileBrowser' do |fb|
      fb.source_files = 'Debugo/Plugin/DGFileBrowser/**/*'
      fb.frameworks = 'QuickLook', 'WebKit'
      fb.dependency 'Debugo/Plugin/DGBase'
      fb.dependency 'FMDB'
    end
    pg.subspec 'DGTouchMonitor' do |tm|
      tm.source_files = 'Debugo/Plugin/DGTouchMonitor/**'
      tm.dependency 'Debugo/Plugin/DGBase'
    end
    pg.subspec 'DGFPSLabel' do |fp|
      fp.source_files = 'Debugo/Plugin/DGFPSLabel/**'
    end
  end
end
