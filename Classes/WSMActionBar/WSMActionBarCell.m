//
//  WSMActionBarCell.m
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import "WSMActionBarCell.h"

@implementation WSMActionBarItemInfo

+ (instancetype)infoWithType:(WSMActionBarItemType)type {
    return [[WSMActionBarItemInfo alloc] initWithType:type];
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithType:(WSMActionBarItemType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

@end

@interface WSMActionBarCell ()

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation WSMActionBarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12*SCREEN_RATE, self.width, 66*SCREEN_RATE)];
        _iconImg.contentMode = UIViewContentModeCenter;
        [self addSubview:_iconImg];
    }
    return _iconImg;
}

- (UILabel *)titleLab  {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImg.bottom + 1*SCREEN_RATE, self.width, 14)];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = RGBA(51, 51, 51, 1);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

- (void)setInfo:(WSMActionBarItemInfo *)info {
    _info = info;
    [self opareteInfo:_info];
    self.iconImg.image = LOAD_IMAGE(_info.iconName);
    self.titleLab.text = _info.title;
    self.titleLab.textColor = _info.titleColor;
}

- (void)opareteInfo:(WSMActionBarItemInfo *)item {
    NSString *customIconName = item.iconName;
    NSString *customTitle = item.title;
    UIColor *customTitleColor = item.titleColor;
    NSString *defaultIconName = @"";
    NSString *defaultTitle = @"";
    UIColor *defaultTitleColor = RGBA(51, 51, 51, 1);
    switch (item.type) {
        case WSMActionBarItemTypeShareWeChat:
            defaultIconName = @"gameing_sharewechat_button_nor";
            defaultTitle = @"微信好友";
            break;
            
        case WSMActionBarItemTypeShareTimeline:
            defaultIconName = @"gameing_pengyouquan_button_nor";
            defaultTitle = @"朋友圈";
            break;
            
        case WSMActionBarItemTypeShareQQ:
            defaultIconName = @"gameing_shareqq_button_nor";
            defaultTitle = @"QQ好友";
            break;
            
        case WSMActionBarItemTypeShareQZone:
            defaultIconName = @"gameing_shareqzone_button_nor";
            defaultTitle = @"QQ空间";
            break;
            
        case WSMActionBarItemTypeSaveImage:
            defaultIconName = @"";
            defaultTitle = @"保存";
            break;
            
        case WSMActionBarItemTypeInviteFriend:
            defaultIconName = @"invite_wsm_icon";
            defaultTitle = @"我是谜";
            break;
            
        case WSMActionBarItemTypeReport:
            defaultIconName = @"";
            defaultTitle = @"举报";
            break;
            
    }
    item.iconName = customIconName ? : defaultIconName;
    item.title = customTitle ? : defaultTitle;
    item.titleColor = customTitleColor ? : defaultTitleColor;
}

@end
