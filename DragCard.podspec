
Pod::Spec.new do |s|
  s.name             = 'DragCard'
  s.version          = '1.1.0'
  s.summary          = '卡牌滑动控件'
  s.description      = '高仿探探、默默卡牌滑动'
  s.homepage         = 'https://github.com/liujunliuhong/DragCardContainer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liujunliuhong' => '1035841713@qq.com' }
  s.source           = { :git => 'https://github.com/liujunliuhong/DragCardContainer.git', :tag => s.version.to_s }

  s.module_name = 'DragCard'
  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'Sources/*.swift'
end
