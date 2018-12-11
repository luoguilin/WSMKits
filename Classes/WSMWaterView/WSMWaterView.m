//
//  WSMWaterView.m
//  WSM
//
//  Created by Mvoicer on 2018/11/12.
//  Copyright © 2018 mvoicer. All rights reserved.
//

#import "WSMWaterView.h"

static const CGFloat AnimationScale = 1.39;

@interface WSMWaterView () {
    NSArray *_waves;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger waveCount;
@property (nonatomic, assign) BOOL shouldStop;
@property (nonatomic, assign) BOOL isMuted;

@end

@implementation WSMWaterView

- (void)newWave {
    __block UIView *wave = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [self addSubview:wave];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:wave.center radius:self.width/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *circle = [CAShapeLayer new];
    circle.path = path.CGPath;
    circle.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    circle.fillColor = [UIColor clearColor].CGColor;
    [wave.layer addSublayer:circle];
    
    self.waveCount += 1;
    [UIView animateWithDuration:1.2 animations:^{
        wave.transform = CGAffineTransformScale(wave.transform, AnimationScale, AnimationScale);
        wave.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.shouldStop) {
            [self pauseTimer];
        }
        [wave removeFromSuperview];
    }];
}

- (void)startAnimation {
    if (self.subviews.count > 0) {
        return;
    }
    
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.4 target:self selector:@selector(newWave) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } else {
       [_timer setFireDate:[NSDate date]];
    }
}

- (void)stopAnimationWithMute:(BOOL)mute {
    self.shouldStop = YES;
    self.isMuted = mute;
    [self pauseTimer];
}

- (void)pauseTimer {
    // self.waveCount >= 3：表示至少显示3条波纹
    if (self.isMuted || self.waveCount >= 3) {
        self.waveCount = 0;
        self.shouldStop = NO;
        [_timer setFireDate:[NSDate distantFuture]]; // 暂停
        
        if (self.isMuted) {
            // 禁麦时波纹立即消失
            for (UIView *subview in self.subviews) {
                [subview removeFromSuperview];
            }
        }
    }
}

- (void)dealloc {
    [_timer invalidate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
