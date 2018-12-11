//
//  WSMPopup.h
//  WSM
//
//  Created by luo guilin on 2018/7/2.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hideCompletionEcho)(void);

@interface WSMPopup : UIView

// 是否允许点击任意位置隐藏控件（除有响应事件的子控件）
@property (nonatomic, assign) BOOL enableAnyWhereCancel;
// 背景透明度
@property (nonatomic, assign) CGFloat transparency; // 默认为0.6，即BACKGROUND_TRANSPARENCY

- (void)show;
- (void)hide;

/**
 * 隐藏弹窗
 * @parma hideCompletion  隐藏动画结束回调
 */
- (void)hideWithHideCompletion:(hideCompletionEcho)hideCompletion;

@end
