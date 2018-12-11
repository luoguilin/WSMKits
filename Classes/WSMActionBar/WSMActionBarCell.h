//
//  WSMActionBarCell.h
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSMActionBarItemInfo;

/* WSMActionBar item 对象 */
@interface WSMActionBarItemInfo : NSObject

typedef NS_ENUM(NSUInteger, WSMActionBarItemType) {
    /* 分享 */
    WSMActionBarItemTypeShareWeChat,                // 微信好友
    WSMActionBarItemTypeShareTimeline,              // 微信朋友圈
    WSMActionBarItemTypeShareQQ,                    // QQ好友
    WSMActionBarItemTypeShareQZone,                 // QQ空间
    /* 操作 */
    WSMActionBarItemTypeInviteFriend,      // 邀请好友
    WSMActionBarItemTypeSaveImage,         // 保存图片
    WSMActionBarItemTypeReport,            // 举报
    WSMActionBarItemTypeDefriend,          // 拉黑
    WSMActionBarItemTypeCancelDefriend,    // 取消拉黑
};

@property (nonatomic, assign) WSMActionBarItemType type;
@property (nonatomic, copy) NSString *iconName;             // 不设置表示使用默认的
@property (nonatomic, copy) NSString *title;                // 不设置不是默认的
@property (nonatomic, strong) UIColor *titleColor;          // 不设置显示默认的

+ (instancetype)infoWithType:(WSMActionBarItemType)type;
- (instancetype)initWithType:(WSMActionBarItemType)type;

@end

@interface WSMActionBarCell : UICollectionViewCell

@property (nonatomic, strong) WSMActionBarItemInfo *info;

@end
