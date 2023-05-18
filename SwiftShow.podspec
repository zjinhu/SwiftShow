
Pod::Spec.new do |s|
  s.name             = 'SwiftShow'
  s.version          = '0.7.6'
  s.summary          = '弹窗组件.'
 
  s.description      = <<-DESC
							工具.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HU' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/SwiftShow.git', :tag => s.version.to_s }

  s.ios.deployment_target = "11.0" 
  s.swift_versions     = ['5.5','5.4','5.3','5.2','5.1','5.0','4.2']
  s.requires_arc = true

  s.subspec 'Show' do |ss|
      ss.source_files = 'Sources/SwiftShow/Show/**/*'
      ss.dependency 'SnapKit'
    end

  s.subspec 'Presentation' do |ss|
      ss.source_files = 'Sources/SwiftShow/Presentation/**/*'
      ss.dependency 'SwiftShow/Show'
    end
    
  s.default_subspec = 'Show'
end
