//
//  WSMActionBar.h
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

#import "WSMActionBarCell.h"
@class WSMActionBar;

@interface WSShareInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSArray *images;

+ (instancetype)infoWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url images:(NSArray *)images;

@end


@protocol WSMActionBarDelegate <NSObject>

@optional
- (void)WSMActionBar:(WSMActionBar *)actionBar selectedItemAtIndex:(NSInteger)index;
- (void)WSMActionBar:(WSMActionBar *)actionBar selectedItemWithType:(WSMActionBarItemType)type;

@end

@interface WSMActionBar : UIView

@property (nonatomic, weak) id<WSMActionBarDelegate> delegate;
@property (nonatomic, copy) NSArray *itemInfos;                 // 每个元素为ActionBarItem对象
@property (nonatomic, strong) WSShareInfo *shareInfo;

+ (instancetype)bar;

- (void)show;

- (void)showWithShareInfo:(WSShareInfo *)info;

- (void)showWithShareInfo:(WSShareInfo *)info hasWSMInvite:(BOOL)hasWSMInvite;

- (void)shareWithType:(WSMActionBarItemType)type;

- (void)hide;

@end
