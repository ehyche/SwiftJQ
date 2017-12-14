#
# Be sure to run `pod lib lint SwiftJQ.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftJQ'
  s.version          = '0.0.1'
  s.summary          = 'SwiftJQ is a Swift wrapper around jq, the JSON processor.'

  s.description      = <<-DESC
  SwiftJQ is a Swift wrapper around jq, the JSON processor.
                       DESC

  s.homepage         = 'https://github.com/ehyche/SwiftJQ'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ehyche' => 'ehyche@gmail.com' }
  s.source           = { :git => 'https://github.com/ehyche/SwiftJQ.git', :tag => s.version.to_s }

  s.platform = :ios, '9.0'

  s.source_files = 'SwiftJQ/Classes/jq/*.{h,c}', 'SwiftJQ/Classes/Extensions/*.swift'
  s.exclude_files = 'SwiftJQ/Classes/jq/inject_errors.c', 'SwiftJQ/Classes/jq/main.c'
  s.pod_target_xcconfig = { 'OTHER_CFLAGS' => '-DIEEE_8087=1 -DHAVE___THREAD=1 -DHAVE_REMAINDER=1 -DHAVE_HYPOT=1 -DHAVE_ATAN2=1 -DHAVE_POW=1 -DHAVE_Y1=1 -DHAVE_Y0=1 -DHAVE_TGAMMA=1 -DHAVE_TANH=1 -DHAVE_TAN=1 -DHAVE_SQRT=1 -DHAVE_SINH=1 -DHAVE_SIN=1 -DHAVE_LOG=1 -DHAVE_LOG2=1 -DHAVE_LOG10=1 -DHAVE_J1=1 -DHAVE_J0=1 -DHAVE_FLOOR=1 -DHAVE_EXP=1 -DHAVE_EXP2=1 -DHAVE_COSH=1 -DHAVE_COS=1 -DHAVE_CBRT=1 -DHAVE_ATANH=1 -DHAVE_ATAN=1 -DHAVE_ASINH=1 -DHAVE_ASIN=1 -DHAVE_ACOSH=1 -DHAVE_ACOS=1 -DHAVE_TM_TM_GMT_OFF=1 -DHAVE_GETTIMEOFDAY=1 -DHAVE_GMTIME=1 -DHAVE_GMTIME_R=1 -DHAVE_TIMEGM=1 -DHAVE_STRFTIME=1 -DHAVE_STRPTIME=1 -DHAVE_ISATTY=1 -DHAVE_ALLOCA=1 -DHAVE_ALLOCA_H=1 -DHAVE_MKSTEMP=1 -DHAVE_MEMMEM=1' }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
