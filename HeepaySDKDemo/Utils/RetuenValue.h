//
//  RetuenValue.h
//  HeePaySDKDemo
//
//  Created by Jiangrx on 10/16/15.
//  Copyright © 2015 Jiangrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetuenValue : NSObject

@property (nonatomic, copy)NSString *hasError;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, copy)NSString *tokenId;
@property (nonatomic, copy)NSString *agentBillId;
@property (nonatomic, copy)NSString *billInfo;
@property (nonatomic, copy)NSString *methodName;
@property (nonatomic, copy)NSString *agentID;

@end
