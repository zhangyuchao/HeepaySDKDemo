//
//  HYMaskView.m
//  HeeMoneySDKSource
//
//  Created by  huiyuan on 17/2/23.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import "HYMaskView.h"
//#import "HYPayConstant.h"


typedef void(^CloseBlock)(void);
@interface HYMaskView ()

@property (nonatomic,weak) UIButton * rightButton;
@property (nonatomic,copy) CloseBlock block;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) NSUInteger count;

@end

@implementation HYMaskView


-(instancetype)initWithFrame:(CGRect)frame withBlock:(void(^)(void))block
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.block = block;
        self.count = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTiemerAction) userInfo:nil repeats:YES];

        [self initViews];
    }
    return self;
}

- (void)initViews
{
    UIView * maskView = [[UIView alloc]init];
    maskView.backgroundColor = [UIColor colorWithRed:76.0f/255.0f green:145.0f/255.0f blue:209.0f/255.0f alpha:1];
    maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:maskView];
    
    UIButton * rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(self.frame.size.width - 90, 30, 60, 30);
    [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.layer.cornerRadius = 5.0f;
    rightButton.layer.borderColor = [UIColor whiteColor].CGColor;
    rightButton.layer.borderWidth = 1.0f;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:rightButton];
    self.rightButton = rightButton;
    self.rightButton.hidden = YES;
    
    UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingView.center = maskView.center;
    [maskView addSubview:loadingView];
    [loadingView startAnimating];
    
    UILabel * versionLabel = [[UILabel alloc]init];
    versionLabel.frame = CGRectMake(0, self.frame.size.height - 80, self.frame.size.width, 30);
    versionLabel.text = @"1.0.0" ;
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [maskView addSubview:versionLabel];
    
    UILabel * dsecLabel = [[UILabel alloc]init];
    dsecLabel.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 30);
    dsecLabel.text = @"© 版权归汇付宝所有";
    dsecLabel.textColor = [UIColor whiteColor];
    dsecLabel.textAlignment = NSTextAlignmentCenter;
    [maskView addSubview:dsecLabel];
    
//    maskView.hy_layout
//    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
//    loadingView.hy_layout
//    .centerXEqualToView(maskView)
//    .centerYEqualToView(maskView);
    
//    versionLabel.hy_layout
//    .leftSpaceToView(maskView,0)
//    .rightSpaceToView(maskView,0)
//    .bottomSpaceToView(maskView,80.0f)
//    .heightIs(30);
//    
//    dsecLabel.hy_layout
//    .leftSpaceToView(maskView,0)
//    .rightSpaceToView(maskView,0)
//    .bottomSpaceToView(maskView,50.0f)
//    .heightIs(30);

//    rightButton.hy_layout
//    .topSpaceToView(maskView,30.0f)
//    .rightSpaceToView(maskView,20)
//    .heightIs(30.0f)
//    .widthIs(60.0f);
    
}

- (void)onClick
{
    if (self.block) {
        self.block();
    }
}

- (void)startTiemerAction
{
    if (_count >= 10) {
        self.rightButton.hidden = NO;
        [_timer invalidate];
        _timer = nil;
    }
    _count ++;
}

@end
