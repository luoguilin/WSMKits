//
//  UITextView+M_yWSMTextView.h
//  ASD
//
//  Created by yangyang on 15/12/4.
//  Copyright © 2015年  http://www.ehoo100.com/. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMTextView : UITextView

//占位符文字
@property (nonatomic, copy) NSString *placeholderString;
//占位符文字颜色
@property (nonatomic, strong) UIColor *placeholderColor;
//占位符文字大小
@property (nonatomic, strong) UIFont *placeholderFont;

- (instancetype)initWithFrame:(CGRect)frame;

@end
