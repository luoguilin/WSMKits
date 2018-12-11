//
//  WSMSexLabel.h
//  WSM
//
//  Created by luo guilin on 2018/7/16.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMSexLabel : UIView

@property (nonatomic, assign) NSInteger sex; // 1：男，2：女
@property (nonatomic, assign) NSInteger age;

+ (instancetype)labelAtPosition:(CGPoint)position;
+ (instancetype)labelAtPosition:(CGPoint)position sex:(NSInteger )sex age:(NSInteger)age;

@end
