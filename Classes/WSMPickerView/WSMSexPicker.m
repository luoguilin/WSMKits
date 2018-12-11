//
//  WSMSexPicker.m
//  WSM
//
//  Created by luo guilin on 2017/8/24.
//  Copyright © 2017年 WSM. All rights reserved.
//

#import "WSMSexPicker.h"

static const NSInteger CancelButtonTag = 100001;
static const CGFloat PickerFullHeight = 260.f;
static const CGFloat ToolBarHeight = 44.f;

@interface WSMSexPicker () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSInteger _sex;
}
@property (nonatomic, strong) UIView *btnContainer;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, copy) WSMIntegerBlock selectedSex;

@end

@implementation WSMSexPicker

- (instancetype)initWithFrame:(CGRect)frame selectedSex:(WSMIntegerBlock)block {
    if (self = [super initWithFrame:frame]) {
        _selectedSex = block;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _sex = 1;
        self.picker.dataSource = self;
        self.picker.delegate = self;
    }
    return self;
}

- (UIView *)btnContainer {
    if (!_btnContainer) {
        _btnContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - PickerFullHeight*SCREEN_RATE, self.width, ToolBarHeight)];
        _btnContainer.backgroundColor = [UIColor whiteColor];
        [self addSubview:_btnContainer];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, _btnContainer.height)];
        cancelBtn.tag = CancelButtonTag;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:MIDDLE_GRAY forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainer addSubview:cancelBtn];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 60, 0, 60, _btnContainer.height)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainer addSubview:confirmBtn];
        
        // 上下分割线
        [CALayer wsm_addSplitLineWithFrame:CGRectMake(0, 0, _btnContainer.width, SPLITLINE_HEIGHT) onSuperLayer:_btnContainer.layer];
        [CALayer wsm_addSplitLineWithFrame:CGRectMake(0, ToolBarHeight-SPLITLINE_HEIGHT, _btnContainer.width, SPLITLINE_HEIGHT) onSuperLayer:_btnContainer.layer];
    }
    return _btnContainer;
}

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.btnContainer.bottom, self.width, self.height - self.btnContainer.bottom)];
        _picker.backgroundColor = [UIColor whiteColor];
        [self addSubview:_picker];
    }
    return _picker;
}

- (void)onClick:(UIButton *)sender {
    if (sender.tag == CancelButtonTag) {
        if (_selectedSex) {
            _selectedSex(0);
        }
        return;
    }
    if (_sex == 0) {
        [[AppDelegate currentVC].view showTips:@"请选择性别"];
        return;
    }
    if (_selectedSex) {
        _selectedSex(_sex);
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row == 0 ? @"男" : @"女";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _sex = row+1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
