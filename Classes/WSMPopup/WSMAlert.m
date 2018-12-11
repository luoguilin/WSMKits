//
//  WSMAlert.m
//  WSM
//
//  Created by luo guilin on 2018/7/15.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMAlert.h"

static const CGFloat WSMAlertHeight = 181.f;
static const CGFloat WSMAlertTopHeight = 61.f;
static const CGFloat WSMAlertTipsMargin = 15;

static const NSInteger WSMAlertButtonBaseTag = 1100;

@interface WSMAlert () {
    NSMutableArray *_buttons;
}

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) WSMIntegerBlock selectedItem;

@end

@implementation WSMAlert

+ (instancetype)showWithTips:(NSString *)tips
                      titles:(NSArray *)titles
            changeBackground:(UIColor *)backgroundColor
         selectedItemAtIndex:(WSMIntegerBlock)selected{
    WSMAlert *alert = [WSMAlert showWithTitle:nil tips:tips titles:titles selectedItemAtIndex:selected];
    UIButton *btn = [alert viewWithTag:WSMAlertButtonBaseTag+1];
    btn.backgroundColor = backgroundColor;
    return alert;
}

+ (instancetype)showWithTips:(NSString *)tips titles:(NSArray *)titles selectedItemAtIndex:(WSMIntegerBlock)selected {
    return [WSMAlert showWithTitle:nil tips:tips titles:titles selectedItemAtIndex:selected];
}

+ (instancetype)showWithTitle:(NSString *)title tips:(NSString *)tips titles:(NSArray *)titles selectedItemAtIndex:(WSMIntegerBlock)selected {
    [WSMAlert clear];
    
    WSMAlert *alert = [[WSMAlert alloc] initWithFrame:[AppDelegate ad].window.bounds];
    alert.title = title;
    alert.selectedItem = selected;
    alert.tips = tips;
    alert.titles = titles;
    [[AppDelegate ad].window addSubview:alert];
    
    [alert show];
    return alert;
}

+ (void)clear {
    for (UIView *view in [AppDelegate ad].window.subviews) {
        if ([view isKindOfClass:WSMAlert.class]) {
            [view removeFromSuperview];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _buttons = [NSMutableArray array];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255*SCREEN_RATE, 0)];
    _container.centerX = self.width/2;
    [self addSubview:_container];
    
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _container.width, WSMAlertHeight*SCREEN_RATE)];
    // 拉伸图片 参数1 代表从左侧到指定像素禁止拉伸，该像素之后拉伸，参数2 代表从上面到指定像素禁止拉伸，该像素以下就拉伸
    UIImage *image = LOAD_IMAGE(@"all_message_bg");
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/3*2];
    _backgroundImage.image = image;
    [_container addSubview:_backgroundImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:WSMRect(0, 20, 96, 22)];
    titleLabel.centerX = _backgroundImage.width/2;
    titleLabel.font = [UIFont wsm_font:18 bold:YES];
    titleLabel.text = @"提示";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_backgroundImage addSubview:titleLabel];
    
    CGFloat top = WSMAlertTopHeight*SCREEN_RATE;
    CGFloat margin = WSMAlertTipsMargin*SCREEN_RATE;
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, top+margin, _backgroundImage.width-margin*2, _backgroundImage.height-top-margin*2)];
    _contentLabel.font = [UIFont wsm_font:13];
    _contentLabel.textColor = DARK_COLOR;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_backgroundImage addSubview:_contentLabel];
}

#pragma mark - Setter

- (void)setTips:(NSString *)tips {
    _tips = tips;
    
    NSString *full = _tips ? : @" ";
    NSMutableAttributedString *attr = [NSAttributedString make:full];
    if ([_title notNull]) {
        full = [NSString stringWithFormat:@"%@\n%@", _title, full];
        attr = [NSAttributedString make:full keyWords:@[_title] colors:@[DARK_COLOR] repeat:NO];
        attr = [NSAttributedString make:attr keyWords:@[_title] fonts:@[[UIFont wsm_font:16 bold:YES]] repeat:NO];
        
        NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
        para.alignment = NSTextAlignmentCenter;
        [attr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, _title.length)];
        para.lineSpacing = 6*SCREEN_RATE;
        [attr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, _title.length)];
    }
    
    if (attr) {
        NSRange range = NSMakeRange(_title.length, attr.length-_title.length);
        NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
        para.lineSpacing = 3*SCREEN_RATE;
        [attr addAttribute:NSParagraphStyleAttributeName value:para range:range];
        
        CGFloat oneHeight = 17*SCREEN_RATE;
        CGFloat height = [WSMUtil textSize:_tips font:[UIFont wsm_font:13] maxWidth:_contentLabel.width].height;
        if (height <= oneHeight) {
            para.alignment = NSTextAlignmentCenter;
            [attr addAttribute:NSParagraphStyleAttributeName value:para range:range];
        }
        _contentLabel.attributedText = [attr copy];
    }
    [self refreshTipsUI];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    NSInteger btnCount = _titles.count;
    CGFloat space = 6*SCREEN_RATE;
    CGFloat width = (_container.width-(btnCount-1)*space)/btnCount;
    CGFloat height = 48*SCREEN_RATE;
    for (NSInteger i = 0; i < btnCount; i ++) {
        UIButton *btn = [_buttons itemAtIndex:i];
        if (!btn) {
            btn = [UIButton new];
            btn.backgroundColor = i == 0 ? [[UIColor whiteColor] colorWithAlphaComponent:0.85] : [UIColor whiteColor];
            btn.titleLabel.font = [UIFont wsm_font:15 bold:YES];
            [btn setTitleColor:DARK_COLOR forState:UIControlStateNormal];
            [btn.layer addCornerRadius:6];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [_container addSubview:btn];
            
            [_buttons addObject:btn];
        }
        btn.tag = WSMAlertButtonBaseTag + i;
        btn.frame = CGRectMake((width+space)*i, _backgroundImage.bottom+space, width, height);
        if([[_titles itemAtIndex:i] isKindOfClass:NSAttributedString.class]){
            [btn setAttributedTitle:[_titles itemAtIndex:i] forState:UIControlStateNormal];
        }else{
            [btn setTitle:[_titles itemAtIndex:i] forState:UIControlStateNormal];
        }
    }
    [self refreshButtonsUI];
}

#pragma mark - Action

- (void)hide {
    [UIView animateWithDuration:WSMAnimationDuration animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onClick:(UIButton *)sender {
    [self hide];
    if (_selectedItem) {
        _selectedItem(sender.tag - WSMAlertButtonBaseTag);
    }
}

- (void)refreshTipsUI {
    [_contentLabel sizeToFit];
    CGFloat margin = WSMAlertTipsMargin*SCREEN_RATE;
    CGFloat maxWidth = _backgroundImage.width-margin*2;
//    _contentLabel.height = [WSMUtil textSize:_contentLabel.attributedText font:[UIFont wsm_font:13] maxWidth:maxWidth].width;
    _contentLabel.width = maxWidth;
    CGFloat minHeight = (WSMAlertHeight-WSMAlertTopHeight)*SCREEN_RATE-margin*2;
    _contentLabel.height = MAX(minHeight, _contentLabel.height*1.15);
    _contentLabel.height = MIN(self.height*0.75, _contentLabel.height);
    _backgroundImage.height = WSMAlertTopHeight*SCREEN_RATE+margin*2+_contentLabel.height;
}

- (void)refreshButtonsUI {
    if ([_titles notNull]) {
        NSInteger btnCount = _titles.count;
        for (NSInteger i = 0; i < btnCount; i ++) {
            UIButton *btn = [self viewWithTag:WSMAlertButtonBaseTag+i];
            btn.y = _backgroundImage.bottom + 6*SCREEN_RATE;
        }
        UIButton *btn = [self viewWithTag:WSMAlertButtonBaseTag];
        _container.height = btn.bottom;
    } else {
        _container.height = _backgroundImage.bottom;
    }
    _container.centerY = self.height/2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
