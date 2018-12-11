//
//  WSMAvatar.m
//  WSM
//
//  Created by luo guilin on 2018/8/7.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMAvatar.h"
#import <SVGAPlayer/SVGAParser.h>
#import <SVGAPlayer/SVGAPlayer.h>

static const CGFloat BorderAvatarRate = 1.43;

@interface WSMAvatar ()

@property (nonatomic, strong) UIImageView *borderImage;
@property (nonatomic, strong) UIImageView *cornerIcon;
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;

@property (nonatomic, copy) WSMBlock clickedAvatar;

@end

@implementation WSMAvatar

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cornerWidth = 16 * SCREEN_RATE;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _avatarImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _avatarImage.backgroundColor = BACKGROUND_COLOR;
    [_avatarImage.layer addCornerRadius:self.width/2.f*SCREEN_RATE_REVERSE];
    [self addSubview:_avatarImage];
}

- (UIImageView *)borderImage {
    if (!_borderImage) {
        CGFloat width = self.width*BorderAvatarRate;
        CGFloat margin = (self.width - width)/2;
        _borderImage = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, width, width)];
        [self addSubview:_borderImage];
    }
    return _borderImage;
}

- (UIImageView *)cornerIcon {
    if (!_cornerIcon) {
        _cornerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-_cornerWidth*1.2, self.height-_cornerWidth*1.2, _cornerWidth, _cornerWidth)];
        [self addSubview:_cornerIcon];
    }
    return _cornerIcon;
}

- (SVGAPlayer *)svgaPlayer {
    if (!_svgaPlayer) {
        CGFloat width = self.width*BorderAvatarRate;
        CGFloat margin = (self.width - width)/2;
        _svgaPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(margin, margin, width, width)];
        _svgaPlayer.userInteractionEnabled = NO;
        [self addSubview:_svgaPlayer];
    }
    return _svgaPlayer;
}

- (void)layoutSubviews{
    _avatarImage.frame = self.bounds;
    [_avatarImage.layer addCornerRadius:self.width/2.f*SCREEN_RATE_REVERSE];
    CGFloat width = self.width*BorderAvatarRate;
    CGFloat margin = (self.width - width)/2;
    _borderImage.frame = CGRectMake(margin, margin, width, width);
}

- (void)onClickedAvatar:(WSMBlock)handler {
    _clickedAvatar = handler;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    if (_clickedAvatar) {
        _clickedAvatar();
    }
}

#pragma mark - Setter

- (void)setWidth:(CGFloat)width {
    [super setWidth:width];
    
    self.height = width;
    _avatarImage.frame = CGRectMake(0, 0, width, width);
    CGFloat borderWidth = self.width*BorderAvatarRate;
    CGFloat margin = (self.width - borderWidth)/2;
    _borderImage.frame = CGRectMake(margin, margin, borderWidth, borderWidth);
    [self refreshBorderWithWidth:_borderWidth];
}

- (void)setAvatarSource:(id)avatarSource {
    _avatarSource = avatarSource;
    
    if ([_avatarSource isKindOfClass:NSURL.class]) {
        [_avatarImage sd_setImageWithURL:_avatarSource];
    } else {
        _avatarImage.layer.wsm_image = _avatarSource;
    }
}

- (void)setPhotoFrameSource:(id)photoFrameSource {
    _photoFrameSource = photoFrameSource;
    
    NSString *url = nil;
    if ([_photoFrameSource isKindOfClass:NSURL.class]) {
        NSURL *URL = (NSURL *)_photoFrameSource;
        url = URL.absoluteString;
    } else if ([_photoFrameSource isKindOfClass:NSString.class]) {
        url = _photoFrameSource;
    }
    [self refreshBorderWithWidth:[url notNull] ? 0.f : _borderWidth];

    if ([url notNull]) {
        BOOL isSVGA = [url hasSuffix:@".svga"];
        _borderImage.hidden = isSVGA;
        _svgaPlayer.hidden = !isSVGA;
        
        // 停止之前 svga 动画
        if (_svgaPlayer) {
            [_svgaPlayer stopAnimation];
            [_svgaPlayer clear];
        }
        
        if (isSVGA) {
            // SVGA 格式动态图片
            SVGAParser *parser = [SVGAParser new];
            [parser parseWithURL:[NSURL URLWithString:url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                if (videoItem != nil) {
                    self.svgaPlayer.videoItem = videoItem;
                    [self.svgaPlayer startAnimation];
                }
            } failureBlock:^(NSError * _Nullable error) {
                NSLog(@"SVGA 动画加载失败：%@", error.description);
            }];
        } else {
            // 普通静态图片
            if ([_photoFrameSource isKindOfClass:NSURL.class]) {
                [self.borderImage sd_setImageWithURL:_photoFrameSource];
            } else {
                self.borderImage.layer.wsm_image = _photoFrameSource;
            }
        }
    } else {
        _borderImage.hidden = YES;
        _svgaPlayer.hidden = YES;
    }
}

- (void)setCornerType:(WSMAvatarCornerType)cornerType {
    _cornerType = cornerType;
    
    switch (_cornerType) {
        case WSMAvatarCornerTypeVIP: {
            self.cornerIcon.hidden = NO;
            _cornerIcon.image = LOAD_IMAGE(@"message_vip_picture");
        }
            break;
            
        default:
            _cornerIcon.hidden = YES;
            break;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth * SCREEN_RATE;
    [self refreshBorderWithWidth:_borderWidth];
}

- (void)setCornerWidth:(CGFloat)cornerWidth {
    _cornerWidth = cornerWidth * SCREEN_RATE;
    self.cornerIcon.frame = CGRectMake(self.width-_cornerWidth, self.height-_cornerWidth, _cornerWidth, _cornerWidth);
}

#pragma mark - Action

- (void)refreshBorderWithWidth:(CGFloat)borderWidth  {
    UIColor *color = borderWidth > 0.f ? [UIColor whiteColor] : [UIColor clearColor];
    [_avatarImage.layer addCornerRadius:self.width/2.f*SCREEN_RATE_REVERSE borderWidth:borderWidth borderColor:color];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
