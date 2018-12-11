//
//  WSMAlert.h
//  WSM
//
//  Created by luo guilin on 2018/7/15.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMPopup.h"

@interface WSMAlert : WSMPopup

+ (instancetype)showWithTips:(NSString *)tips titles:(NSArray *)titles selectedItemAtIndex:(WSMIntegerBlock)selected;

+ (instancetype)showWithTips:(NSString *)tips titles:(NSArray *)titles changeBackground:(UIColor *)backgroundColor selectedItemAtIndex:(WSMIntegerBlock)selected;

+ (instancetype)showWithTitle:(NSString *)title tips:(NSString *)tips titles:(NSArray *)titles selectedItemAtIndex:(WSMIntegerBlock)selected;

+ (void)clear;

@end
