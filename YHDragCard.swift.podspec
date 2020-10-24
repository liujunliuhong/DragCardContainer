
Pod::Spec.new do |s|
  s.name             = 'YHDragCard.swift'
  s.version          = '1.0.1'
  s.summary          = '仿探探滑牌左右滑动，可以自由配置各种属性，支持OC'
  s.description      = '仿探探滑牌左右滑动，可以自由配置各种属性，支持OC'
  s.homepage         = 'https://github.com/liujunliuhong/YHDragContainer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liujunliuhong' => '1035841713@qq.com' }
  s.source           = { :git => 'https://github.com/liujunliuhong/YHDragContainer.git', :tag => s.version.to_s }

  s.module_name = 'YHDragCardSwift'
  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'Sources/*.swift'
end
