//
//  HYBaseViewController.m
//  HeepaySDKDemo
//
//  Created by  huiyuan on 2017/4/25.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import "HYHomeViewController.h"
#import "ViewController.h"
#import "HYH5PayViewController.h"

@interface HYHomeViewController ()

@end

@implementation HYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self buildUI];
}

-(void)buildUI{
    
    UIButton *wapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wapBtn setFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 44.0f)];
    [wapBtn setTitle:@"App包装WAP" forState:UIControlStateNormal];
    [wapBtn setBackgroundColor:[UIColor colorWithRed:1/255.0f green:170/255.0f blue:238/255.0f alpha:1]];
    [wapBtn addTarget:self action:@selector(doPayType:) forControlEvents:UIControlEventTouchUpInside];
    wapBtn.tag = 1;
    wapBtn.layer.cornerRadius = 4;
    wapBtn.layer.masksToBounds = YES;
    [self.view addSubview:wapBtn];
    
    
    UIButton *sdkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sdkBtn setFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 44.0f)];
    [sdkBtn setTitle:@"原生SDK支付" forState:UIControlStateNormal];
    [sdkBtn setBackgroundColor:[UIColor colorWithRed:1/255.0f green:170/255.0f blue:238/255.0f alpha:1]];
    [sdkBtn addTarget:self action:@selector(doPayType:) forControlEvents:UIControlEventTouchUpInside];
    sdkBtn.tag = 2;
    sdkBtn.layer.cornerRadius = 4;
    sdkBtn.layer.masksToBounds = YES;
    [self.view addSubview:sdkBtn];
    
}

-(void)doPayType:(UIButton *)sender{
    if (sender.tag == 1) {
        HYH5PayViewController *controller = [[HYH5PayViewController alloc] init];
        controller.title = @"App包装WAP";
        [self showViewController:controller sender:nil];
        
    }else if (sender.tag == 2){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.title = @"原生SDK支付";
        [self showViewController:vc sender:nil];
    }
}

@end
