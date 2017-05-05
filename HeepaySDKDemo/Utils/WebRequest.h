//
//  WebRequest.h
//  HeePaySDKDemo
//
//  Created by Jiangrx on 6/30/14.
//  Copyright (c) 2014 Jiangrx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WebRequestCompleteBlock)(NSDictionary* returnValue,BOOL hasError);


@interface WebRequest : NSObject
//SDK
+ (void)sendWebRequestToSDKInitWithPaymentFee:(NSString *)fee paymentType:(NSString *)type withCompleteBlock:(WebRequestCompleteBlock)block;

//H5
+ (void)sendWebRequestToPaymentIndexWithPaymentFee:(NSString *)fee paymentType:(NSString *)type withCompleteBlock:(WebRequestCompleteBlock)block;

+(void)queryPaymentResultwithCompleteBlock:(WebRequestCompleteBlock)block;

@end
