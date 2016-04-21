Pod::Spec.new do |spec|
  #项目名称
  spec.name         = 'FenzoFilters'
  #版本号
  spec.version      = '0.1.1'
  #开源协议
  spec.license      = 'MIT'
  #对开源项目的描述
  spec.summary      = 'FenzoFilters is a image filter.'
  #开源项目的首页
  spec.homepage     = 'https://github.com/Lockerios/FenzoFilters'
  #作者信息
  spec.author       = {'lockerios' => 'locklockzhang@gmail.com'}
  #项目的源和版本号
  spec.source       = { :git => 'git@github.com:Lockerios/FenzoFilters.git', :tag => '0.1.1' }
  #源文件，这个就是供第三方使用的源文件
  spec.source_files = "FenzoFilters/*"
  #适用于ios7及以上版本
  spec.platform     = :ios, '7.0'
  #使用的是ARC
  spec.requires_arc = true
  #无依赖
  #spec.dependency ''
end
