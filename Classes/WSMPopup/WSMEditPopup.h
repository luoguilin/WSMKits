//
//  WSMEditPopup.h
//  wsm
//
//  Created by luo guilin on 2018/6/4.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMPopup.h"

@interface WSMEditPopup : WSMPopup

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *fieldContainer;
@property (nonatomic, assign) CGFloat containerWidth;
@property (nonatomic, assign) CGFloat containerHeight;
@property (nonatomic, assign) BOOL showBackgroundImage;

@end
