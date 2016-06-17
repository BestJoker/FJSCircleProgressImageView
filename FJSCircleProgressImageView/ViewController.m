//
//  ViewController.m
//  FJSCircleProgressImageView
//
//  Created by 付金诗 on 16/6/16.
//  Copyright © 2016年 www.fujinshi.com. All rights reserved.
//

#import "ViewController.h"
#import "FJSCircleProgressImageView.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()
@property (nonatomic,strong)FJSCircleProgressImageView * imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"圆形加载ImageView";
    
    self.imageView = [[FJSCircleProgressImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 200) * 0.5, 100, 200, 100)];
    self.imageView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.imageView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.bounds.size.width - 200) * 0.5, CGRectGetMaxY(self.imageView.frame) + 50, 200, 30);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadingImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)loadingImageAction
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
    [self.imageView setImageWithImageUrl:@"http://img5.duitang.com/uploads/item/201508/13/20150813084652_AEKh5.jpeg"];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
