//
//  WSMSearchBar.m
//  WSM
//
//  Created by Mvoicer on 2018/11/6.
//  Copyright © 2018 mvoicer. All rights reserved.
//

#import "WSMSearchBar.h"

@interface WSMSearchBar ()

@end

@implementation WSMSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = BACKGROUND_COLOR;
    self.font = [UIFont wsm_font:15];
    self.returnKeyType = UIReturnKeySearch;
    [self.layer addCornerRadius:10];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    icon.center = CGPointMake(leftView.width/2, leftView.height/2);
    icon.image = LOAD_IMAGE(@"meassage_search_picture");
    [leftView addSubview:icon];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
