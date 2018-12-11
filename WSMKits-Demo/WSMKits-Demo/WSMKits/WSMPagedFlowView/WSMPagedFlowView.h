//
//  WSMPagedFlowView.h
//  dianshang
//
//  Created by sskh on 16/7/13.
//  Copyright © 2016年 Mars. All rights reserved.


#import <UIKit/UIKit.h>
#import "WSMPagedFlowCell.h"

@protocol WSMPagedFlowViewDataSource;
@protocol WSMPagedFlowViewDelegate;

/******************************
 
 页面滚动的方向分为横向和纵向
 
 Version 1.0:
 目的:实现类似于选择电影票的效果,并且实现无限/自动轮播
 
 特点:1.无限轮播;2.自动轮播;3.电影票样式的层次感;4.非当前显示view具有缩放和透明的特效
 
 问题:考虑到轮播图的数量不会太大,暂时未做重用处理;对设备性能影响不明显,后期版本会考虑添加重用标识模仿tableview的重用
 
 ******************************/

typedef enum{
    WSMPagedFlowViewOrientationHorizontal = 0,
    WSMPagedFlowViewOrientationVertical
}WSMPagedFlowViewOrientation;

@interface WSMPagedFlowView : UIView<UIScrollViewDelegate>

/**
 *  默认为横向
 */
@property (nonatomic,assign) WSMPagedFlowViewOrientation orientation;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,assign) BOOL needsReload;
/**
 *  总页数
 */
@property (nonatomic,assign) NSInteger pageCount;

@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) NSRange visibleRange;
/**
 *  如果以后需要支持reuseIdentifier，这边就得使用字典类型了
 */
@property (nonatomic,strong) NSMutableArray *reusableCells;

@property (nonatomic,assign)   id <WSMPagedFlowViewDataSource> dataSource;
@property (nonatomic,assign)   id <WSMPagedFlowViewDelegate>   delegate;

/**
 *  指示器
 */
@property (nonatomic,retain)  UIPageControl *pageControl;

/**
 *  非当前页的透明比例
 */
@property (nonatomic, assign) CGFloat minimumPageAlpha;

/**
 左右间距,默认20
 */
@property (nonatomic, assign) CGFloat leftRightMargin;

/**
 上下间距,默认30
 */
@property (nonatomic, assign) CGFloat topBottomMargin;

/**
 *  是否开启自动滚动,默认为开启
 */
@property (nonatomic, assign) BOOL isOpenAutoScroll;

/**
 *  是否开启无限轮播,默认为开启
 */
@property (nonatomic, assign) BOOL isCarousel;

/**
 *  当前是第几页
 */
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

/**
 *  定时器
 */
@property (nonatomic, weak) NSTimer *timer;

/**
 *  自动切换视图的时间,默认是5.0
 */
@property (nonatomic, assign) CGFloat autoTime;

/**
 *  原始页数
 */
@property (nonatomic, assign) NSInteger orginPageCount;

/**
 *  刷新视图
 */
- (void)reloadData;

/**
 *  获取可重复使用的Cell
 *
 *  @return cell
 */
- (WSMPagedFlowCell *)dequeueReusableCell;

/**
 *  滚动到指定的页面
 *
 *  @param pageNumber 页码
 */
- (void)scrollToPage:(NSUInteger)pageNumber;

/**
 *  开启定时器,废弃
 */
//- (void)startTimer;

/**
 *  关闭定时器,关闭自动滚动
 */
- (void)stopTimer;

/**
 调整中间页居中，经常出现滚动卡住一半时调用
 */
- (void)adjustCenterSubview;

@end


@protocol  WSMPagedFlowViewDelegate<NSObject>

@optional
/**
 *  当前显示cell的Size(中间页显示大小)
 *
 *  @param flowView 当前WSMPagedFlowView对象
 *
 *  @return size
 */
- (CGSize)sizeForPageInFlowView:(WSMPagedFlowView *)flowView;

/**
 *  滚动到了某一列
 *
 *  @param pageNumber 页码
 *  @param flowView   当前WSMPagedFlowView对象
 */
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSMPagedFlowView *)flowView;

/**
 *  点击了第几个cell
 *
 *  @param subView 点击的控件
 *  @param subIndex    点击控件的index
 *
 */
- (void)didSelectCell:(WSMPagedFlowCell *)subView withSubViewIndex:(NSInteger)subIndex;

@end


@protocol WSMPagedFlowViewDataSource <NSObject>

/**
 *  返回显示View的个数
 *
 *  @param flowView 当前WSMPagedFlowView对象
 *
 *  @return 个数
 */
- (NSInteger)numberOfPagesInFlowView:(WSMPagedFlowView *)flowView;

/**
 *  给某一列设置属性
 *
 *  @param flowView 当前WSMPagedFlowView对象
 *  @param index    序号
 *
 *  @return cell
 */
- (WSMPagedFlowCell *)flowView:(WSMPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end
