//
//  WSMActionSheet.h
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSMActionSheet;

@protocol WSMActionSheetDelegate <NSObject>

- (void)WSMActionSheet:(WSMActionSheet *)actionSheet reportType:(NSInteger)type content:(NSString *)content;

@end

@interface WSMActionSheet : UIView

@property (nonatomic, weak) id<WSMActionSheetDelegate> delegate;
@property (nonatomic, copy) NSArray *itemContents;

+ (instancetype)sheet;

- (void)show;
- (void)hide;

@end
