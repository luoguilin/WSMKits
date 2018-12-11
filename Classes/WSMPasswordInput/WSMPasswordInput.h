//
//  WSMPasswordInput.h
//  WSM
//
//  Created by luo guilin on 2018/7/16.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMPasswordInput : UIView

@property (nonatomic, assign) NSInteger count; // 默认4
@property (nonatomic, copy) NSString *text;

+ (instancetype)inputAtPosition:(CGPoint)position;
+ (instancetype)inputAtPosition:(CGPoint)position count:(NSInteger)count;

- (void)becomeFirstResponder;
- (void)textDidChanged:(WSMStringBlock)changed;

@end
