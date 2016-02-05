//
//  ViewController.m
//  01-图片轮播器
//
//  Created by joe on 15/7/23.
//  Copyright (c) 2015年 joe. All rights reserved.
//

#import "ViewController.h"

#define kImageCount  5
@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * scrollview;
@property (nonatomic,strong) UIPageControl * pagecontrol;
@property (nonatomic,strong) NSTimer * timer;
@end

@implementation ViewController

- (UIScrollView *)scrollview
{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, 130)];
        _scrollview.backgroundColor = [UIColor redColor];
        [self.view addSubview:_scrollview];
        //取消弹簧效果
        _scrollview.bounces = NO;
        //取消滚动条
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        // 分页
        _scrollview.pagingEnabled = YES;
        // contentSize
        
        _scrollview.contentSize = CGSizeMake(kImageCount * _scrollview.bounds.size.width, 0);
        
        _scrollview.delegate = self;
    }
        return _scrollview;

}
- (UIPageControl *)pagecontrol
{

     if (_pagecontrol == nil) {
        
        
        //添加分页控件，本质上跟scrollView没有如何关系，是两个独立的控件
        _pagecontrol = [[UIPageControl alloc] init];
        //总页数
        _pagecontrol.numberOfPages = kImageCount;
        //控件尺寸
        CGSize size = [_pagecontrol sizeForNumberOfPages:kImageCount];
        _pagecontrol.bounds = CGRectMake(0, 0, size.width, size.height);
        _pagecontrol.center = CGPointMake(self.view.center.x, 130);
         
        /**_pagecontrol.frame = CGRectMake(self.view.center.x, 130, size.width, size.height);  用这一句代码代替上面两句，运行，分页控件位置偏右下一些。*/
        
         //设置颜色
        _pagecontrol.pageIndicatorTintColor = [UIColor redColor];
        _pagecontrol.currentPageIndicatorTintColor = [UIColor blackColor];
        
        [self.view addSubview:_pagecontrol];
        //添加监听方法（进入到pagecontrol的头文件看，它继承自UIControl，所以也可以添加监听方法）
        /** 在OC中，绝大多数控件（继承自UIControl）都能够监听UIControlEventValueChanged事件，btn除外*/
        
         [_pagecontrol addTarget:self action:@selector(pagechanged:) forControlEvents:UIControlEventValueChanged];
         
    }
        return _pagecontrol;
}
//分页控件监听方法
- (void)pagechanged:(UIPageControl*)page
{
        // NSLog(@"%d",page.currentPage);
        // 根据页数，调整滚动视图中的图片位置 contentOffent
        CGFloat x = page.currentPage * self.scrollview.bounds.size.width;
        [self.scrollview setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)viewDidLoad
{
        [super viewDidLoad];
    
    //设置图片
    
    for (int i = 0; i < kImageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_%02d",i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollview.bounds];
        imageView.image = image;
        
        [self.scrollview addSubview:imageView];
        
    }
    //计算imageview的位置
    
        [self.scrollview.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        //调整x => origin =>frame
        CGRect frame = imageView.frame;
        frame.origin.x = idx * frame.size.width;
        imageView.frame = frame;
    }];
        // NSLog(@"%@",self.scrollview.subviews);
    
    
        //分页初始页数为0
        self.pagecontrol.currentPage = 0;
    
        //启动时钟
        [self startTimer];
}

- (void)startTimer
{
        /** self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updatetimer) userInfo:nil repeats:YES]; */
    
        self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updatetimer) userInfo:nil repeats:YES];
        // 添加到运行循环
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updatetimer
{
        //页数发生变化
        //当前页数 + 1 % 总页数
        int page = (self.pagecontrol.currentPage + 1 ) % kImageCount;
        self.pagecontrol.currentPage = page;
    
        //调用监听方法，让滚动视图滚动
        [self pagechanged:self.pagecontrol];


}



#pragma mark - ScrollView的代理方法

//滚动视图停止，改变分页控件的页数（小点）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        //停下的当前页数
        // NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
        //计算页数
        int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        self.pagecontrol.currentPage = page;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        [self.timer invalidate];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        [self startTimer];

}


@end
