//
//  WSMPagedFlowCell.h
//  WSMPagedFlowView
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.


/******************************
 
 可以根据自己的需要继承WSMPagedFlowCell
 
 ******************************/

#import <UIKit/UIKit.h>

@interface WSMPagedFlowCell : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, copy) void (^didSelectCellBlock)(NSInteger tag, WSMPagedFlowCell *cell);

/**
 设置子控件frame,继承后要重写

 @param superViewBounds 子控件frame
 */
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;

@end
