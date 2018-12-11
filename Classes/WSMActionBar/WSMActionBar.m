//
//  WSMActionBar.m
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import "WSMActionBar.h"
#import "WSMShareRewardPopup.h"

@implementation WSShareInfo

+ (instancetype)infoWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url images:(NSArray *)images {
    WSShareInfo *info = [WSShareInfo new];
    info.title = title;
    info.content = content;
    info.url = url;
    info.images = images;
    return info;
}

- (void)setImages:(NSArray *)images {
    if (!images || images.count == 0) {
        images = @[LOAD_IMAGE(@"login_logo_icon_nor")];
    }
    _images = images;
}

@end


static const NSInteger LineItemMaxCount = 5;// 一行最大cell个数
static const CGFloat CellHeight = 110.f;
static const CGFloat CancelButonHeight = 49.f;
static NSString *const WSMActionBarCellID = @"WSMActionBarCell";

@interface WSMActionBar () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UICollectionView *itemList;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation WSMActionBar

+ (instancetype)bar {
    static WSMActionBar *bar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bar = [[WSMActionBar alloc] initWithFrame:[AppDelegate ad].window.frame];
        [[AppDelegate ad].window addSubview:bar];
    });
    return bar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
    }
    return self;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 0)];
        _container.backgroundColor = [UIColor whiteColor];
        [self addSubview:_container];
    }
    return _container;
}

- (UICollectionView *)itemList {
    if (!_itemList) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(self.width/LineItemMaxCount, CellHeight*SCREEN_RATE);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _itemList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.container.width, 0) collectionViewLayout:layout];
        _itemList.backgroundColor = [UIColor whiteColor];
        _itemList.dataSource = self;
        _itemList.delegate = self;
        _itemList.scrollEnabled = NO;
        _itemList.showsVerticalScrollIndicator = NO;
        _itemList.showsHorizontalScrollIndicator = NO;
        _itemList.bounces = NO;
        [_itemList registerClass:[WSMActionBarCell class] forCellWithReuseIdentifier:WSMActionBarCellID];
        [self.container addSubview:_itemList];
    }
    return _itemList;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger section = _itemInfos.count/LineItemMaxCount + MIN(1, _itemInfos.count%LineItemMaxCount);
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_itemInfos.count/LineItemMaxCount >= 1) {
        return LineItemMaxCount;
    }
    return _itemInfos.count%LineItemMaxCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSMActionBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WSMActionBarCellID forIndexPath:indexPath];
    NSInteger index = indexPath.section*LineItemMaxCount + indexPath.row;
    cell.info = [_itemInfos itemAtIndex:index];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section*LineItemMaxCount + indexPath.row;
    WSMActionBarItemInfo *item = [_itemInfos itemAtIndex:index];
    
    if (item.type != WSMActionBarItemTypeReport && _shareInfo) {
        [self shareWithType:item.type];
    }
    
    if ([self.delegate respondsToSelector:@selector(WSMActionBar:selectedItemAtIndex:)]) {
        [self.delegate WSMActionBar:self selectedItemAtIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(WSMActionBar:selectedItemWithType:)]) {
        [self.delegate WSMActionBar:self selectedItemWithType:item.type];
    }
    
    [self hide];
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.itemList.bottom, self.container.width, CancelButonHeight)];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.hidden = YES;
        [self.container addSubview:_cancelBtn];
        
        // 顶部分割线
        [CALayer wsm_addSplitLineWithFrame:CGRectMake(0, 0, _cancelBtn.width, SPLITLINE_HEIGHT) onSuperLayer:_cancelBtn.layer];
    }
    return _cancelBtn;
}

- (void)setItemInfos:(NSArray *)itemInfos {
    _itemInfos = itemInfos;
    NSInteger section = _itemInfos.count/LineItemMaxCount + MIN(1, _itemInfos.count%LineItemMaxCount);
    self.itemList.height = CellHeight*SCREEN_RATE*section;
    [self.itemList reloadData];
    self.cancelBtn.y = self.itemList.bottom;
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:WSMAnimationDuration animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:BACKGROUND_TRANSPARENCY];
        CGFloat containerHeight = self.itemList.height + CancelButonHeight + TABBAR_DIFF;
        self.container.y = self.height - containerHeight;
        self.container.height = containerHeight;
        self.itemList.hidden = NO;
        self.cancelBtn.hidden = NO;
    }];
}

- (void)showWithShareInfo:(WSShareInfo *)info {
    [self showWithShareInfo:info hasWSMInvite:NO];
}

- (void)showWithShareInfo:(WSShareInfo *)info hasWSMInvite:(BOOL)hasWSMInvite {
    _shareInfo = info;
    [self settingShareInfosWithWSMInvite:hasWSMInvite];
    [self show];
}

- (void)settingShareInfosWithWSMInvite:(BOOL)hasWSMInvite {
    NSMutableArray *shareTypeArray = [NSMutableArray array];
    if (hasWSMInvite) {
        [shareTypeArray addObject:[WSMActionBarItemInfo infoWithType:WSMActionBarItemTypeInviteFriend]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [shareTypeArray addObject:[WSMActionBarItemInfo infoWithType:WSMActionBarItemTypeShareWeChat]];
        [shareTypeArray addObject:[WSMActionBarItemInfo infoWithType:WSMActionBarItemTypeShareTimeline]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [shareTypeArray addObject:[WSMActionBarItemInfo infoWithType:WSMActionBarItemTypeShareQQ]];
        [shareTypeArray addObject:[WSMActionBarItemInfo infoWithType:WSMActionBarItemTypeShareQZone]];
    }
    self.itemInfos = shareTypeArray;
}

- (void)shareWithType:(WSMActionBarItemType)type {
    // 分享
    SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
    switch (type) {
        case WSMActionBarItemTypeShareWeChat:
            platformType = SSDKPlatformSubTypeWechatSession;
            break;
            
        case WSMActionBarItemTypeShareTimeline:
            platformType = SSDKPlatformSubTypeWechatTimeline;
            break;
            
        case WSMActionBarItemTypeShareQQ:
            platformType = SSDKPlatformSubTypeQQFriend;
            break;
            
        case WSMActionBarItemTypeShareQZone:
            platformType = SSDKPlatformSubTypeQZone;
            break;
            
        default:
            return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_shareInfo.content
                                     images:_shareInfo.images
                                        url:[NSURL URLWithString:_shareInfo.url]
                                      title:_shareInfo.title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:platformType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理
         switch (state) {
             case SSDKResponseStateSuccess: {
                 [[AppDelegate ad].window showTips:@"分享成功"];
                 [WSMShareRewardPopup showWithType:WSMShareTypeDefault];
             }
                 break;
             case SSDKResponseStateFail:
                 [[AppDelegate ad].window showTips:@"分享失败"];
                 break;
             default:
                 break;
         }
     }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
        self.container.y = self.height;
        self.container.height = 0;
    } completion:^(BOOL finished) {
        self.itemList.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.hidden = YES;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

