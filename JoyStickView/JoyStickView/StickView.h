//
//  StickView.h
//  StickView
//
//  Created by Orange on 2018/8/06.
//  Copyright © 2018年 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AngleBlock)(float sinX, float sinY);

@interface StickView : UIView

#pragma mark -- 属性
@property(nonatomic,strong)AngleBlock angleBlock;       // 控制器回传角度

#pragma mark -- 方法
- (instancetype)initWithFrame:(CGRect)frame;

@end
