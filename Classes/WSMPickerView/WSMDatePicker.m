//
//  WSMDatePicker.m
//  WSM
//
//  Created by luo guilin on 2017/8/24.
//  Copyright © 2017年 WSM. All rights reserved.
//

#import "WSMDatePicker.h"

static const NSInteger CancelButtonTag = 100000;
static const CGFloat PickerFullHeight = 300;
static const CGFloat ToolBarHeight = 44;
static const NSInteger YearTimeSpan = 50;
static const NSInteger YearOffset = 20;

@interface WSMDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSInteger _minYear;
    NSInteger _maxYear;
    NSInteger _currentYear;
    NSInteger _currentMonth;
    NSInteger _currentDay;
}
@property (nonatomic, strong) UIView *btnContainer;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, copy) WSMStringBlock selectedDate;
@end

@implementation WSMDatePicker

- (instancetype)initWithFrame:(CGRect)frame selectedDate:(WSMStringBlock)block {
    if (self = [super initWithFrame:frame]) {
        _selectedDate = block;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        NSDateComponents *dcs = [[NSDate date] wsm_components];
        _maxYear = dcs.year;
        _minYear = _maxYear - YearTimeSpan;     // 最早年份为当前年份减YearTimeSpan
        _currentYear = _maxYear - YearOffset;   // 初始年份为当前年份减YearOffset
        _currentMonth = dcs.month;
        _currentDay = dcs.day;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self.picker selectRow:YearTimeSpan-YearOffset inComponent:0 animated:NO];
        [self.picker selectRow:_currentMonth-1 inComponent:1 animated:NO];
        [self.picker selectRow:_currentDay-1 inComponent:2 animated:NO];
    }
    return self;
}

- (NSInteger)getCurrentYear {
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    return comp.year;
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
        _picker.dataSource = self;
        _picker.delegate = self;
        [self addSubview:_picker];
    }
    return _picker;
}

- (void)onClick:(UIButton *)sender {
    if (sender.tag == CancelButtonTag) {
        if (_selectedDate) {
            _selectedDate(nil);
        }
        return;
    }
    if (_currentYear == 0) {
        [[AppDelegate currentVC].view showTips:@"请选择年份"];
        return;
    }
    if (_currentMonth == 0) {
        [[AppDelegate currentVC].view showTips:@"请选择月份"];
        return;
    }
    if (_currentDay == 0) {
        [[AppDelegate currentVC].view showTips:@"请选择日期"];
        return;
    }
    if (_selectedDate) {
        NSString *date = [NSString stringWithFormat:@"%ld-%02d-%02d", _currentYear, _currentMonth, _currentDay];
        _selectedDate(date);
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 1;
    switch (component) {
        case 0:
            count = _maxYear - _minYear + 1;
            break;
            
        case 1:
            count = 12;
            break;
            
        case 2:
            count = 31;
            break;
    }
    return count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSInteger count = 0;
    NSString *suffix = @"";
    switch (component) {
        case 0:
            count = _minYear + row;
            suffix = @"年";
            break;
            
        case 1:
            count = row + 1;
            suffix = @"月";
            break;
            
        case 2:
            count = row + 1;
            suffix = @"日";
            break;
    }
    return [[NSString stringFromNumber:@(count)] stringByAppendingString:suffix];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            _currentYear = _minYear + row;
            break;
            
        case 1:
            _currentMonth = row+1;
            break;
            
        case 2:
            _currentDay = row+1;
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
