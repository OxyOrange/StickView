//
//  StickView.m
//  StickView
//
//  Created by Orange on 2018/8/06.
//  Copyright © 2018年 Orange. All rights reserved.
//

#import "StickView.h"

@interface StickView ()
{
    CGPoint mCenter;
    float _sinX;
    float _sinY;
}

@property(nonatomic,strong)UIView* stickViewBase;       // 底部背景
@property(nonatomic,strong)UIView* stickView;           // 上面的圆点
@property(nonatomic,strong)dispatch_source_t timer;     // gcd timer 按住状态下启动timer发送角度

@end

@implementation StickView

#pragma mark -- 接口
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        [self initView];
        [self initTimer];
    }
    return self;
}

#pragma mark -- 内部方法

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = self.frame.size.height/2;
    mCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self initBaseView];
    [self initCircleView];
}

- (void)initBaseView {
    self.stickViewBase = [[UIView alloc]initWithFrame:self.bounds];
    self.stickViewBase.backgroundColor = [UIColor clearColor];
    self.stickViewBase.layer.borderColor = [UIColor blackColor].CGColor;
    self.stickViewBase.layer.borderWidth = 2;
    self.stickViewBase.layer.cornerRadius = self.frame.size.height/2;
    self.stickViewBase.userInteractionEnabled = NO;
    [self addSubview:self.stickViewBase];
}

- (void)initCircleView {
    float width = self.frame.size.width/5.0;
    self.stickView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-width)/2, (self.frame.size.height-width)/2, width, width)];
    self.stickView.backgroundColor = [UIColor blackColor];
    self.stickView.layer.borderColor = [UIColor blackColor].CGColor;
    self.stickView.layer.borderWidth = 2;
    self.stickView.layer.cornerRadius = width/2;
    self.stickView.userInteractionEnabled = NO;
    [self addSubview:self.stickView];
}

- (void)initTimer {
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.01*NSEC_PER_SEC);   // 10毫秒一次
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    __weak typeof(self)ws = self;
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        if (ws.angleBlock){
            ws.angleBlock(_sinX,_sinY);
        }
    });
}

- (void)startTimer {
    if (!self.timer){
        [self initTimer];
    }
    dispatch_resume(self.timer);
}

- (void)stopTimer {
    if (self.timer){
        dispatch_cancel(self.timer);
    }
    self.timer = nil;
}

#pragma mark -- touch 方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startTimer];
    [self touchEvent:touches needMove:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchEvent:touches needMove:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopTimer];
    [self stickMoveTo:mCenter];
}

- (void)touchEvent:(NSSet *)touches needMove:(BOOL)needMove
{
    if([touches count] != 1)
        return ;
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self)
        return ;
    
    CGPoint touchPoint = [touch locationInView:view];
    CGPoint dtarget, dir;
    
    // 计算圆点坐标
    dir.x = touchPoint.x - mCenter.x;
    dir.y = touchPoint.y - mCenter.y;
    double len = sqrt(dir.x * dir.x + dir.y * dir.y);
    float radius = self.frame.size.height/2;
    if (len <= radius){
        [self stickMoveTo:touchPoint];
    }
    else {
        dtarget.x = radius*dir.x/len+radius;
        dtarget.y = radius*dir.y/len+radius;
        [self stickMoveTo:dtarget];
    }
    
    // 回传角度
    float sinX = dir.x/len;
    float sinY = dir.y/len;
    _sinX = sinX;
    _sinY = sinY;
    if (self.angleBlock && needMove){
        self.angleBlock(sinX,sinY);
    }
}

- (void)stickMoveTo:(CGPoint)deltaToCenter
{
    self.stickView.frame = CGRectMake(deltaToCenter.x-self.stickView.frame.size.width/2, deltaToCenter.y-self.stickView.frame.size.height/2, self.stickView.frame.size.width, self.stickView.frame.size.height);
}

- (void)dealloc {
    if (self.timer){
        dispatch_cancel(self.timer);
    }
    self.timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
