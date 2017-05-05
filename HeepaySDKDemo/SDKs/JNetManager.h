//
//  JNetManager.h
//  HeepaySourceDemo
//
//  Created by 降瑞雪 on 2017/4/5.
//  Copyright © 2017年 HuiYuan.NET. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JNetRequest.h"
#import "JNetResponse.h"


@interface JNetManager : NSObject

//唤起支付钱包关键方法，
+ (void)sendRequest:(JNetRequest *)requset responseBlock:(void(^)(JNetResponse *response))resultBlock;

//获取当前SDK版本号。
+(NSString *)getApiVersion;

//支付宝APP和商户应用间通讯方法。
+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url;

@end
