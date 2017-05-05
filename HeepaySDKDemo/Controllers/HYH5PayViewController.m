//
//  HYH5PayViewController.m
//  HeepaySDKDemo
//
//  Created by  huiyuan on 2017/4/25.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import "HYH5PayViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "HYWebViewController.h"
#import "WebRequest.h"

@interface HYH5PayViewController ()

@property (nonatomic, weak) UITextField *textF;

@end


@implementation HYH5PayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 44.0f)];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf];
    tf.text = @"0.01";
    self.textF = tf;
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(10, 200, self.view.frame.size.width - 20, 44.0f);
    [payBtn setTitle:@"WAP支付" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:[UIColor colorWithRed:1/255.0f green:170/255.0f blue:238/255.0f alpha:1]];
    [payBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.layer.cornerRadius = 4;
    payBtn.layer.masksToBounds = YES;
    [self.view addSubview:payBtn];
    
}

-(void)onClick:(UIButton *)sender{
    
    if ([self isNullOrEmpty:self.textF.text]) {
        [self showAlertMsg:@"请输入正确的金额"];
        return;
    }
    
    //调用下单接口
    [WebRequest sendWebRequestToPaymentIndexWithPaymentFee:self.textF.text paymentType:@"30" withCompleteBlock:^(NSDictionary *returnValue, BOOL hasError) {
        //下单接口返回的是一个拼接的支付请求串
        HYWebViewController *controller = [[HYWebViewController alloc] init];
        NSString *string = returnValue[@"params"];
        controller.loadUrlStr = string;
        [self showViewController:controller sender:nil];
        
    } ];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textF resignFirstResponder];
}


-(void)showAlertMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)isNullOrEmpty:(NSString *)str
{
    if (!str) {
        return YES;
    }
    else if ([str isEqual:[NSNull null]]){
        
        return YES;
    }
    else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
}


@end
