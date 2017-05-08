# JNetSDK iOS
## 简介
本项目的官方Github的地址是 https://github.com/zhangyuchao/HeepaySDKDemo

这是一个完整的汇付宝SDK的官方demo，集成包含了原生SDK的支付，包括了微信、支付宝、骏卡、游戏卡、快捷支付、电话卡支付等汇付宝相关的支付方式；也包含了App包装WAP支付的集成方式。

SDKs 文件夹下是 iOS SDK文件。

## 版本要求
iOS SDK要求iOS8.0及以上版本

## 接入方法
### 安装
#### 使用CocoaPods
1.在Podfile添加

    pod 'JNetSDK', '~> 1.0.1'
    
可自行选择需要的支付渠道添加相应的模块
目前支持的模块有：
    
    Alipay (支付宝移动支付)
    Wx (微信app支付)
    骏卡
    快捷支付
    电话卡支付
    游戏卡支付
    
    App包装WAP支付方式
    
例如：

    pod 'JNetSDK/Alipay', '~> 1.0.1'
    pod 'JNetSDK/Wx', '~> 1.0.1'
    
2.运行

    pod install
    
3.从现在开始使用 .xcwoekspace 打开项目，而不是 .xcodeproj

4.添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 "TARGETS" 一栏，在 "Info" 标签栏的 "URL Types" 添加 "URL Schemes"，如果使用微信，填入所注册的微信应用程序 id，如果不使用微信，则自定义，允许英文字母和数字，首字母必须是英文字母，建议起名稍复杂一些，尽量避免与其他程序冲突。

#### 手动导入
1.获取SDK
  
  下载demo，里面包含有SDKs文件夹目录。
  
2.依赖 Frameworks:

必须：

    JavaScriptCore.framework
    CoreMotion.framework
    CoreTelephony.framework
    CoreGraphics.framework
    SystemConfiguration.framework
    CFNetwork.framework
    libc++.1.tbd
    libz.1.2.5.tbd
    libsqlite3.0.tbd
    
 3.如果不需要相关支付方式，删除对应下的目录文件即可。
 
 4.添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 "TARGETS" 一栏，在 "Info" 标签栏的 "URL Types" 添加 "URL Schemes"，如果使用微信，填入所注册的微信应用程序 id，如果不使用微信，则自定义，允许英文字母和数字，首字母必须是英文字母，建议起名稍复杂一些，尽量避免与其他程序冲突。
 
 5.添加 Other Linker Flags：在 Build Settings 搜索 Other Linker Flags ，添加 -ObjC。
 注意：如果使用 -ObjC 导致和其他类库出现冲突，请使用 -force_load（静态库路径）
 
### 额外配置
1.iOS 9 以上版本如果需要使用支付宝和微信渠道，需要在 Info.plist 添加以下代码：

    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>weixin</string>
        <string>wechat</string>
        <string>alipay</string>
        <string>alipays</string>
        <string>alipayqr</string>
        <string>alipayshare</string>
    </array>
    
2.iOS 9 限制了http协议的访问，如果app需要访问 http://  ,需要在info.plist中添加如下代码：

    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    
关于如何使用 SDK 请具体参考官方的demo及文档说明中的具体注意事项。
    
### 注意事项
请勿直接使用客户端支付结果作为最终判定订单状态的依据，支付状态以服务端为准!!!在收到客户端同步返回结果时，请向自己的服务端请求来查询订单状态。
