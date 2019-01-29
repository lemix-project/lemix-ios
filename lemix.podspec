Pod::Spec.new do |s|
s.name = 'lemix'
s.version = '1.0.0'
s.ios.deployment_target = '8.0'
s.summary = 'lemix引擎'
s.homepage = 'https://code.lemonit.cn/lemix/lemix-ios-oc'
s.license = { :type => "MIT", :file => "LICENSE" }
s.authors = { 'wangweiguang' => '306822374@qq.com' }
s.source = { :git => "https://github.com/lemix-project/lemix-ios", :tag => "v1.0.0"}
s.source_files = "lemix/lemix/*.{h,m}","lemix/lemix/**/*.{h,m}"
s.requires_arc = true
s.dependency 'SSZipArchive'
s.dependency 'AFNetworking'
s.dependency 'lemage'
end