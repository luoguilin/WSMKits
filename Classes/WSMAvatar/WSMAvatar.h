//
//  WSMAvatar.h
//  WSM
//
//  Created by luo guilin on 2018/8/7.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>

// 角标样式
typedef NS_ENUM(NSUInteger, WSMAvatarCornerType) {
    WSMAvatarCornerTypeNone,
    WSMAvatarCornerTypeVIP, // VIP
};

@interface WSMAvatar : UIView

@property (nonatomic, strong) id avatarSource;                  // 头像资源，支持UIImage、NSString、NSURL
@property (nonatomic, strong) id photoFrameSource;              // 相框资源，支持UIImage、NSString、NSURL，为NSString或URL时如果以.svga结束则显示动态
@property (nonatomic, assign) WSMAvatarCornerType cornerType;
@property (nonatomic, assign) CGFloat borderWidth;              // 默认0.f
@property (nonatomic, assign) CGFloat cornerWidth;              // 默认16.f;

@property (nonatomic, strong) UIImageView *avatarImage;

- (void)onClickedAvatar:(WSMBlock)handler;

@end
