#
# Be sure to run `pod lib lint WHLCategory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WHLCategory'
  s.version          = '0.1.0'
  s.summary          = 'this is command used category'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/WCMYCML'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WCMYCML' => '443803599@qq.com' }
  s.source           = { :git => 'https://github.com/WCMYCML/WHLCategory.git', :tag => "0.1.0" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WHLCategory/Classes/WHLCategory/*.{h,m}'
  
  # s.resource_bundles = {
  #   'WHLCategory' => ['WHLCategory/Assets/*.png']
  # }

  s.public_header_files = 'WHLCategory/Classes/WHLCategory/WHLCateger.h'
  s.frameworks = 'UIKit'
  s.dependency 'MJRefresh', '~> 3.4.3'
end
