//
//  WSMEditPopup.m
//  wsm
//
//  Created by luo guilin on 2018/6/4.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMEditPopup.h"

@interface WSMEditPopup ()

@property (nonatomic, strong) UIImageView *backgroundImage;

@end

@implementation WSMEditPopup

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _container = [[UIView alloc] initWithFrame:WSMRect(0, 0, 320, 0)];
        [self addSubview:_container];
        [self refreshContainerCenter];
        
        Add_Observer(UIKeyboardWillShowNotification, @selector(receivedNotification:), nil);
        Add_Observer(UIKeyboardWillHideNotification, @selector(receivedNotification:), nil);
    }
    return self;
}

- (void)receivedNotification:(NSNotification *)noti {
    if (self.hidden) {
        return;
    }
    /* 获取键盘的高度 */
    NSDictionary *userInfo = noti.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    
    if ([noti.name isEqualToString:UIKeyboardWillShowNotification]) {
        [UIView animateWithDuration:WSMAnimationDuration animations:^{
            self.container.y = self.height - self.container.height - keyboardRect.size.height;
        }];
    }
    
    if ([noti.name isEqualToString:UIKeyboardWillHideNotification]) {
        [UIView animateWithDuration:WSMAnimationDuration animations:^{
            self.container.centerY = self.height/2;
        }];
    }
}

- (UIView *)fieldContainer {
    if (!_fieldContainer) {
        _fieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.container.width, 0)];
        _fieldContainer.backgroundColor = [UIColor whiteColor];
        [_fieldContainer.layer addCornerRadius:6.6];
        [self.container addSubview:_fieldContainer];
    }
    return _fieldContainer;
}

- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.fieldContainer.width, self.fieldContainer.width*0.37)];
        _backgroundImage.image = LOAD_IMAGE(@"setbg");
        [self.fieldContainer addSubview:_backgroundImage];
    }
    return _backgroundImage;
}

- (void)setContainerWidth:(CGFloat)containerWidth {
    _containerWidth = containerWidth*SCREEN_RATE;
    
    self.container.width = _containerWidth;
    [self refreshContainerCenter];
}

- (void)setContainerHeight:(CGFloat)containerHeight {
    _containerHeight = containerHeight*SCREEN_RATE;
    
    self.container.height = _containerHeight;
    [self refreshContainerCenter];
}

- (void)setShowBackgroundImage:(BOOL)showBackgroundImage {
    _showBackgroundImage = showBackgroundImage;
    if (_showBackgroundImage) {
        self.backgroundImage.hidden = NO;
    }
}

- (void)refreshContainerCenter {
    _container.center = CGPointMake(self.width/2, self.height/2);
}

- (void)show {
    [super show];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)hide {
    [self endEditing:YES];
    _container.centerY = self.height/2;
    [super hide];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)dealloc {
    Remove_Observer(self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
