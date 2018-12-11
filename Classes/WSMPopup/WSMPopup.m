//
//  WSMPopup.m
//  WSM
//
//  Created by luo guilin on 2018/7/2.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMPopup.h"

@implementation WSMPopup

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES; // 默认隐藏
        self.alpha = 0.f;
        self.transparency = BACKGROUND_TRANSPARENCY;
    }
    return self;
}

- (void)setTransparency:(CGFloat)transparency {
    _transparency = transparency;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:_transparency];
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:WSMAnimationDuration animations:^{
        self.alpha = 1.f;
    }];
}

- (void)hide {
    [self hideWithHideCompletion:nil];
}

- (void)hideWithHideCompletion:(hideCompletionEcho)hideCompletion{
    [UIView animateWithDuration:WSMAnimationDuration animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (hideCompletion) {
            hideCompletion();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.enableAnyWhereCancel) {
        [self hide];
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
