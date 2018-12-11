//
//  WSMActionSheetCell.h
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMActionSheetCell : UITableViewCell

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL noRightIcon;
@property (nonatomic, assign) BOOL isSelected;

@end
