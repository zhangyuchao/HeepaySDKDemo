

Pod::Spec.new do |s|


  s.name         = "JNetSDK"
  s.version      = "1.0.0"
  s.summary      = "汇付宝,让移动支付更简单快捷."
  s.homepage     = "https://github.com/zhangyuchao/HeepaySDKDemo.git"
  s.license      = "MIT"
  s.author             = { "zhangyuchao" => "zhangyuchaofight@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zhangyuchao/HeepaySDKDemo.git", :tag => "1.0.0" }
  s.requires_arc = true

  s.default_subspec = "Core", "Wx", "Alipay"

  s.subspec 'Core' do |core|
    core.source_files = 'HeepaySDKDemo/SDKs/*.h'
    core.vendored_libraries = 'HeepaySDKDemo/SDKs/*.a'
    core.requires_arc = true
    core.ios.library = 'c++', 'z'
    core.frameworks = 'UIKit', 'CoreGraphics', 'CoreTelephony', 'JavaScriptCore', 'SystemConfiguration', 'CFNetwork', 'CoreMotion'
    core.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  end

  s.subspec 'Wx' do |wx|
    wx.frameworks = 'CoreTelephony'
    wx.vendored_libraries = 'HeepaySDKDemo/SDKs/Librarys/WXSDK/libWeChatSDK.a', 'HeepaySDKDemo/HeepaySDK/Librarys/WXSDK/*.a'
    wx.source_files = 'HeepaySDKDemo/SDKs/Librarys/WXSDK/*.h'
    wx.ios.library = 'sqlite3.0'
    wx.dependency 'JNetSDK/Core'
  end

  s.subspec 'Alipay' do |alipay|
    alipay.frameworks = 'CoreMotion' , 'CoreTelephony'
    alipay.vendored_frameworks = 'HeepaySDKDemo/SDKs/Librarys/AliPaySDK/AlipaySDK.framework'
    alipay.vendored_libraries = 'HeepaySDKDemo/SDKs/Librarys/AliPaySDK/*.a'
    alipay.resource = 'HeepaySDKDemo/SDKs/Librarys/AliPaySDK/AlipaySDK.bundle'
    alipay.dependency 'JNetSDK/Core'
  end



end
