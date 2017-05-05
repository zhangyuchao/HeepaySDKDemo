//
//  ViewController.m
//  HeepaySDKDemo
//
//  Created by Jiangrx on 2/24/16.
//  Copyright © 2016 汇元网. All rights reserved.
//

#import "ViewController.h"
#import "WebRequest.h"                  //Demo头文件,无需导入
#import "JNetManager.h"
#import "JNetResponse.h"
#import "JNetRequest.h"




@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *feeTF;

@end

@implementation ViewController

- (IBAction)onClickButtonWithType:(UIButton *)sender {
    
    [WebRequest sendWebRequestToSDKInitWithPaymentFee:self.feeTF.text paymentType:[NSString stringWithFormat:@"%@",@(sender.tag)] withCompleteBlock:^(NSDictionary* params, BOOL hasError) {
        
        if (hasError) {
            //发生报错
            [self alertMsg:params[@"error"]];
        }
        else {
            
            /***** 启动 HeepaySDK相关代码 ****/
            JNetRequest * payModel = [[JNetRequest alloc] init];
            payModel.token_id = params[@"token_id"];
            payModel.agent_id = params[@"agent_id"];
            payModel.agent_bill_id = params[@"agent_bill_id"];
            payModel.ptype = sender.tag;
            payModel.schemeStr = @"HeepaySDKDemo";
            payModel.rootViewController = self;
            
            [JNetManager sendRequest:payModel responseBlock:^(JNetResponse *response) {
                [self alertMsg:response.message ];
            }];
        }
    }];
}

- (void)alertMsg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
