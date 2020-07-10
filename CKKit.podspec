#
# Be sure to run `pod lib lint CKKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  # 名称
  s.name             = 'CKKit'
  # 版本
  s.version          = '0.0.8'
  # 摘要
  s.summary          = '组件化，经常用到的输入框类型的控件，造一个好用的轮子，方便复用，以及快速开发。'
  # 详情
  s.description      = 'CKKit 组件化一些常用的工具，便于快速生成界面！常用的inputView控件,支持数字键盘、文字、时间选择、按钮，spinnerView控件，下拉选择等等'
  # 仓库主页
  s.homepage         = 'https://github.com/ThreeYearOld/CKKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # 许可证
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # 作者
  s.author           = { 'ThreeYearOld' => 'ThreeYearOld' }
  # 仓库源
  s.source           = { :git => 'https://github.com/ThreeYearOld/CKKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  #自己的逻辑代码
  #  s.source_files = 'CKKit/Classes/**/*'
  #依赖自己的或别人的Framework文件
  s.vendored_frameworks = 'CKKit/Classes/*.framework'
  #依赖资源
  s.resource = 'CKKit/Classes/Resources/Sources.bundle'
  #依赖第三方框架
  s.dependency 'Masonry'

  # s.resource_bundles = {
  #   'CKKit' => ['CKKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
