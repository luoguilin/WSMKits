//
//  WSMSexLabel.m
//  WSM
//
//  Created by luo guilin on 2018/7/16.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMSexLabel.h"

@interface WSMSexLabel ()

@property (nonatomic, strong) CATextLayer *ageTxt;

@end

@implementation WSMSexLabel

+ (instancetype)labelAtPosition:(CGPoint)position {
    return [self labelAtPosition:position sex:1 age:0];
}

+ (instancetype)labelAtPosition:(CGPoint)position sex:(NSInteger)sex age:(NSInteger)age {
    WSMSexLabel *label = [[WSMSexLabel alloc] initWithFrame:CGRectMake(position.x*SCREEN_RATE, position.y*SCREEN_RATE, 40*SCREEN_RATE, 18*SCREEN_RATE)];
    label.sex = sex;
    label.age = age;
    return label;
}

- (CATextLayer *)ageTxt {
    if (!_ageTxt) {
        _ageTxt = [CATextLayer layer];
        _ageTxt.frame = CGRectMake(MARGIN_UNIT*4*SCREEN_RATE, SCREEN_RATE, MARGIN_UNIT*9*SCREEN_RATE, 18*SCREEN_RATE);
        _ageTxt.font = (CFTypeRef)@"PingFangSC-Semibold";
        _ageTxt.fontSize = 12*SCREEN_RATE;
        _ageTxt.alignmentMode = kCAAlignmentCenter;
        _ageTxt.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_ageTxt];
    }
    return _ageTxt;
}

- (void)setSex:(NSInteger)sex {
    _sex = sex;
    self.layer.wsm_image = sex == 1 ? @"list_boy_icon" : @"list_girl_icon";
}

- (void)setAge:(NSInteger)age {
    _age = age;
    self.ageTxt.string = [NSString stringFromNumber:@(_age)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
