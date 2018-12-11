//
//  WSMImageLabel.h
//  WSM
//
//  Created by Mvoicer on 2018/10/11.
//  Copyright © 2018 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMImageLabel : UIView

typedef NS_ENUM(NSUInteger, WSMImageLabelType) {
    WSMImageLabelTypeDefault,
    WSMImageLabelTypeBackground
};

/* 以下字段默认值皆为非自适应 */
@property (nonatomic, strong) id iconSource;            // 支持图片名称、UIImage、NSURL
@property (nonatomic, assign) CGSize iconSize;          // 图片尺寸，默认宽高为高度的0.8
@property (nonatomic, assign) CGFloat middleSpace;      // 图片和文字之间的间距，默认为6
@property (nonatomic, strong) UIFont *font;             // 默认为15常规体
@property (nonatomic, strong) UIColor *textColor;       // 默认白色
@property (nonatomic, copy) id text;
@property (nonatomic, assign) CGFloat maxWidth;         // 默认为屏幕宽度

- (instancetype)initWithFrame:(CGRect)frame type:(WSMImageLabelType)type;

@end
