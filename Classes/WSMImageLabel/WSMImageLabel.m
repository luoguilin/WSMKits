//
//  WSMImageLabel.m
//  WSM
//
//  Created by Mvoicer on 2018/10/11.
//  Copyright © 2018 mvoicer. All rights reserved.
//

#import "WSMImageLabel.h"

static const CGFloat SideMarginRate = 0.1;

@interface WSMImageLabel ()

@property (nonatomic, assign) WSMImageLabelType type;

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation WSMImageLabel

- (instancetype)initWithFrame:(CGRect)frame {
    return [[WSMImageLabel alloc] initWithFrame:frame type:WSMImageLabelTypeDefault];
}

- (instancetype)initWithFrame:(CGRect)frame type:(WSMImageLabelType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self initUI];
        
        self.iconSize = CGSizeMake(self.height*0.8, self.height*0.8);
        self.middleSpace = 6;
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor whiteColor];
        self.maxWidth = SCREEN_WIDTH;
    }
    return self;
}

- (void)initUI {
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_iconImage];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
    _textLabel.font = _font;
    _textLabel.textColor = _textColor;
    [self addSubview:_textLabel];
    
    if (_type == WSMImageLabelTypeBackground) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = self.height/2.f;
        
        _iconImage.x = self.height*SideMarginRate;
        _iconImage.layer.cornerRadius = _iconSize.width/2.f;
    }
}

- (void)setIconSource:(id)iconSource {
    _iconSource = iconSource;
    
    if ([_iconSource isKindOfClass:NSString.class]) {
        _iconImage.image = LOAD_IMAGE(_iconSource);
    } else if ([_iconSource isKindOfClass:UIImage.class]) {
        _iconImage.image = _iconSource;
    } else if ([_iconSource isKindOfClass:NSURL.class]) {
        [_iconImage sd_setImageWithURL:_iconSource];
    } else {
        _iconImage.image = nil;
    }
}

- (void)setIconSize:(CGSize)iconSize {
    _iconSize = iconSize;
    
    _iconImage.frame = CGRectMake(_iconImage.x, 0, _iconSize.width, _iconSize.height);
    _iconImage.centerY = self.height/2;
}

- (void)setMiddleSpace:(CGFloat)middleSpace {
    _middleSpace = middleSpace;
    _textLabel.x = _iconImage.right+_middleSpace;
    
    if (_type == WSMImageLabelTypeDefault) {
        _textLabel.width = self.width - _textLabel.x;
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _textLabel.font = _font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _textLabel.textColor = _textColor;
}

- (void)setText:(id)text {
    _text = text;
    
    NSString *pureText = _text;
    if ([_text isKindOfClass:NSAttributedString.class]) {
        _textLabel.attributedText = _text;
        pureText = [_text string];
    } else {
        _textLabel.text = _text;
    }
    
    if (_type == WSMImageLabelTypeBackground) {
        CGFloat otherSpace = self.height*(1+SideMarginRate*2)+_middleSpace;
        CGFloat maxWidth = _maxWidth - otherSpace;
        CGFloat textWidth = [WSMUtil textSize:pureText font:_font maxWidth:maxWidth].width;
        self.textLabel.width = textWidth;
        self.width = otherSpace + textWidth;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
