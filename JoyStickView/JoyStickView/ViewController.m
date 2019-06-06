//
//  ViewController.m
//  StickView
//
//  Created by Orange on 2018/8/06.
//  Copyright © 2018年 Orange. All rights reserved.
//

#import "ViewController.h"

#import "StickView.h"

@interface ViewController ()
@property(nonatomic,strong)UIView* moveView;
@property(nonatomic,assign)float moveViewSpeed;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self)ws = self;
    // 控制器
    float width = 120;
    StickView* v = [[StickView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-width-10, width, width)];
    v.angleBlock = ^(float sinX, float sinY) {
        [ws moveViewWithSinX:sinX sinY:sinY];
    };
    [self.view addSubview:v];
    
    // 被控制的view
    float viewWidth = 100;
    self.moveViewSpeed = 1;
    self.moveView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-viewWidth)/2, (self.view.frame.size.height-viewWidth)/2, viewWidth, viewWidth)];
    self.moveView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.moveView];
}

- (void)moveViewWithSinX:(float)sinX sinY:(float)sinY {
    float x = self.moveView.frame.origin.x+self.moveViewSpeed*sinf(sinX);
    float y = self.moveView.frame.origin.y+self.moveViewSpeed*sinf(sinY);
    NSLog(@"x=%f\ny=%f\n",sinX,sinY);
    self.moveView.frame = CGRectMake(x, y, self.moveView.frame.size.width, self.moveView.frame.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
