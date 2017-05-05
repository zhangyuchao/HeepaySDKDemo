//
//  HYWebViewController.m
//  HeepaySDKDemo
//
//  Created by  huiyuan on 2017/4/25.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import "HYWebViewController.h"
#import "HYMaskView.h"
#import "WebRequest.h"

@interface HYWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic,weak) HYMaskView * maskView;

@end

@implementation HYWebViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        
        __weak typeof(self)weakSelf = self;
        //添加一个遮盖页面遮盖唤起微信支付过程中的空白页
        HYMaskView * maskView = [[HYMaskView alloc] initWithFrame:self.view.bounds withBlock:^{
            [weakSelf removeLoadingMaskView];
        }];
        [self.view addSubview:maskView];
        self.maskView = maskView;

    }
    return self;
}

- (void)setLoadUrlStr:(NSString *)loadUrlStr
{
    //在web view开始加载URL，唤起微信支付之前，需要给app添加一个监听事件，判断app再次进入到前台时候的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundAction) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadUrlStr]]];
    self.webView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = self.view.bounds;
    [self.webView sizeToFit];
    [self.view addSubview:self.webView];
}

- (void)enterForegroundAction{
    
    //移除监听事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //支付完成或取消再次进入到前台,开始调用查单接口
    [WebRequest queryPaymentResultwithCompleteBlock:^(NSDictionary *returnValue, BOOL hasError) {
        
        //
        NSString *returnStr = returnValue[@"params"];
        NSArray *queryArr = [returnStr componentsSeparatedByString:@"|"];
        NSLog(@"\nreturnValue:%@\nqueryArr:%@",returnValue,queryArr);
        
        if ([queryArr count] > 4) {
            
            NSString *result = [queryArr objectAtIndex:4];
            NSString *payMessage = [queryArr objectAtIndex:6];
            NSLog(@"\nresult:%@\npayMessage:%@",result,payMessage);
            
            if ([result isEqualToString:@"result=0"]) {
                [self alertMsg:@"支付取消"];
            }else{
                [self alertMsg:@"支付成功"];
            }
            
        }else{
            
            [self alertMsg:returnStr];
        }
        
        [self dismissViewController];
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeLoadingMaskView];
    NSLog(@"error:: %@",[error debugDescription]);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad:%@,",webView.request.URL.scheme);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad:%@,",webView.request.URL.scheme);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"shouldStartLoadWithRequest:%@,",webView.request.URL.scheme);
    NSLog(@"URLString::: %@",webView.request.URL.absoluteString);
    return YES;
}

-(void)dismissViewController{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeLoadingMaskView
{
    [self.maskView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)alertMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
