//
//  HYMaskView.h
//  HeeMoneySDKSource
//
//  Created by  huiyuan on 17/2/23.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYMaskView : UIView

-(instancetype)initWithFrame:(CGRect)frame withBlock:(void(^)(void))block;

@end
