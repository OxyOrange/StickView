# JoyStickView

原生实现iOS摇杆

调用实例
// 控制器
float width = 120;
XXJoyStickView* v = [[XXJoyStickView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-width-10, width, width)];
v.angleBlock = ^(float sinX, float sinY) {
	[ws moveViewWithSinX:sinX sinY:sinY];
};
[self.view addSubview:v];

block中的sinX和sinY是当前方向的角度,x以top为0度,y以right为0度

视图配合方向角度的移动入下
- (void)moveViewWithSinX:(float)sinX sinY:(float)sinY {
    float x = self.moveView.frame.origin.x+self.moveViewSpeed*sinf(sinX);
    float y = self.moveView.frame.origin.y+self.moveViewSpeed*sinf(sinY);
    self.moveView.frame = CGRectMake(x, y, self.moveView.frame.size.width, self.moveView.frame.size.height);
}

详细请参考demo# StickView
