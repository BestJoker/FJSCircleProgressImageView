//
//  FJSProgressView.m
//  FJSCircleProgressImageView
//
//  Created by 付金诗 on 16/6/16.
//  Copyright © 2016年 www.fujinshi.com. All rights reserved.
//

#import "FJSProgressView.h"
#define kLineWidth 3.0
#define kDuration 1.0
@interface FJSProgressView ()
@property (nonatomic,strong)CAShapeLayer * circleShapeLayer;
@property (nonatomic,strong)CAShapeLayer * speardShapeLayer;
@end
@implementation FJSProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCircleShapeLayer];
    }
    return self;
}


- (void)setupCircleShapeLayer
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.circleShapeLayer = [CAShapeLayer layer];
    self.circleShapeLayer.lineWidth = kLineWidth;
    self.circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleShapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:self.circleShapeLayer];
    
    //获取宽度和高度中最小的一个 乘以 一定的比例来设置环形的直径.
    CGFloat width = MIN(self.layer.bounds.size.width, self.layer.bounds.size.height) * 0.5;
    //设置位置居中,宽度和高度相同.保持正方形.
    self.circleShapeLayer.bounds = CGRectMake(0, 0, width, width);
    self.circleShapeLayer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    //建立path
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path addArcWithCenter: CGPointMake(CGRectGetMidX(self.circleShapeLayer.bounds), CGRectGetMidY(self.circleShapeLayer.bounds)) radius:width * 0.5 startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
    self.circleShapeLayer.strokeStart = 0.f;
    self.circleShapeLayer.strokeEnd = 0.f;
    self.circleShapeLayer.path = path.CGPath;
}

-(void)setProgress:(CGFloat)progress
{
    //progress取值范围为0到1
    progress = MIN(progress, 1);
    progress = MAX(progress, 0);
    _progress = progress;
    self.circleShapeLayer.strokeEnd = progress;
    if (progress == 1) {
        NSLog(@"完成了加载图片");
//        [self spreadAnimation];
        //增加一个延时,可以增加更好的体验效果,对于图片加载过快的时候.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self spreadAnimation];
        });
    }
}

- (void)spreadAnimation
{
    self.backgroundColor = [UIColor clearColor];
//    //  移除已有的layer
    for (CALayer * layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    //添加小圆的动画,记得半径不能够设置成0,否则会发生形变
    [self spreadToCircleFromRadius:self.circleShapeLayer.bounds.size.width * 0.5 ToRadius:0.1 Type:0];
    //计算出能够包含整个图片的圆的半径.
    CGFloat widthPow = pow(self.superview.bounds.size.width * 0.5, 2);
    CGFloat heightPow = pow(self.superview.bounds.size.height * 0.5, 2);
    CGFloat bigCircleRadius = sqrt(widthPow + heightPow);
    [self spreadToCircleFromRadius:self.circleShapeLayer.bounds.size.width * 0.5 ToRadius:bigCircleRadius Type:1];
}



#pragma mark -- fromRadius: 其实半径 toRadius:目标半径 type:0小圆,1大圆
- (void)spreadToCircleFromRadius:(CGFloat)fromRadius ToRadius:(CGFloat)toRadius Type:(NSInteger)type
{
    //这两个圆形path是同心圆
    UIBezierPath * FromPath = [UIBezierPath bezierPath];
    [FromPath addArcWithCenter:CGPointMake(CGRectGetMidX(self.circleShapeLayer.bounds), CGRectGetMidY(self.circleShapeLayer.bounds)) radius:fromRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    UIBezierPath * ToPath = [UIBezierPath bezierPath];
    [ToPath addArcWithCenter:CGPointMake(CGRectGetMidX(self.circleShapeLayer.bounds), CGRectGetMidY(self.circleShapeLayer.bounds)) radius:toRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.circleShapeLayer.frame;
    layer.path = ToPath.CGPath;
    if (type) {
        self.superview.layer.mask = layer;
    }else
    {
        layer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:layer];
    }
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = ((__bridge id)FromPath.CGPath);
    animation.toValue = ((__bridge id)ToPath.CGPath);
    animation.duration = kDuration;
    animation.delegate = self;
    [layer addAnimation:animation forKey:@"path"];
}








//  动画执行完时，移除 mask （否则，根据以上计算的 外圆 rect ，四个角不能完全填充）
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"%@",anim);
    self.superview.layer.mask = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
