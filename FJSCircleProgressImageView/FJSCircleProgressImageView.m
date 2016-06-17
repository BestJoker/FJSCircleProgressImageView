//
//  FJSCircleProgressImageView.m
//  FJSCircleProgressImageView
//
//  Created by 付金诗 on 16/6/16.
//  Copyright © 2016年 www.fujinshi.com. All rights reserved.
//

#import "FJSCircleProgressImageView.h"
#import "FJSProgressView.h"
#import "UIImageView+WebCache.h"

@interface FJSCircleProgressImageView ()
@property (nonatomic,strong)FJSProgressView * progressView;
@end
@implementation FJSCircleProgressImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        self.progressView = [[FJSProgressView alloc] initWithFrame:self.bounds];
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)setImageWithImageUrl:(NSString *)imageUrl
{
    //如果地址为空,则直接返回
    if (!imageUrl.length) return;
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = (float)receivedSize / (float)expectedSize;
        NSLog(@"%ld / %ld = %f",(long)receivedSize,(long)expectedSize,progress);
        self.progressView.progress = progress;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
