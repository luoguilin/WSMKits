//
//  PagedFlowViewController.m
//  WSMKits-Demo
//
//  Created by Mvoicer on 2018/12/11.
//  Copyright © 2018 luoguilin. All rights reserved.
//

#import "PagedFlowViewController.h"

#import "WSMPagedFlowView.h"
#import "CustomPagedFlowCell.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface PagedFlowViewController () <WSMPagedFlowViewDataSource, WSMPagedFlowViewDelegate>

// 图片数组
@property (nonatomic, strong) NSArray *imageArray;

// 轮播图
@property (weak, nonatomic) IBOutlet WSMPagedFlowView *pageFlowView;

// 指示label
@property (weak, nonatomic) IBOutlet UILabel *indicateLabel;

@end

@implementation PagedFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int index = 0; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
        [tempArray addObject:image];
    }
    _imageArray = [tempArray copy];
    
    [self buildUI];
}

- (void)buildUI {
    _pageFlowView.backgroundColor = [UIColor whiteColor];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.4;
    _pageFlowView.leftRightMargin = 30;
    _pageFlowView.topBottomMargin = 0;
    _pageFlowView.orginPageCount = self.imageArray.count;
    _pageFlowView.isOpenAutoScroll = YES;
    // 初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 24, Width, 8)];
    _pageFlowView.pageControl = pageControl;
    [_pageFlowView addSubview:pageControl];
    [_pageFlowView reloadData];
}

#pragma mark - WSMPagedFlowViewDataSource

- (NSInteger)numberOfPagesInFlowView:(WSMPagedFlowView *)flowView {
    return _imageArray.count;
}

- (CGSize)sizeForPageInFlowView:(WSMPagedFlowView *)flowView {
    return CGSizeMake(Width - 50, (Width - 50) * 9 / 16);
}

- (CustomPagedFlowCell *)flowView:(WSMPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    CustomPagedFlowCell *bannerView = (CustomPagedFlowCell *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[CustomPagedFlowCell alloc] init];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    bannerView.mainImageView.image = _imageArray[index];
    bannerView.indexLabel.text = [NSString stringWithFormat:@"第%ld张图",(long)index + 1];
    return bannerView;
}

#pragma mark - WSMPagedFlowViewDelegate

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSMPagedFlowView *)flowView {
    NSLog(@"CustomViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark - 旋转屏幕改变newPageFlowView大小之后实现该方法

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [coordinator animateAlongsideTransition:^(id context) {
            [self.pageFlowView reloadData];
        } completion:NULL];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
