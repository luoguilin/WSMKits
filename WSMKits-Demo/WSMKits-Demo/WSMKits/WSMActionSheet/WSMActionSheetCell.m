//
//  WSMActionSheetCell.m
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import "WSMActionSheetCell.h"

@interface WSMActionSheetCell ()

@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *selectIcon;
@property (nonatomic, strong) CALayer *bottomLine;

@end

static NSString *const WSMActionSheetCellID = @"WSMActionSheetCell";

@implementation WSMActionSheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, SCREEN_WIDTH - 48, 44)];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = RGBA(51, 51, 51, 51);
        [self.contentView addSubview:_contentLab];
    }
    return _contentLab;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer wsm_addSplitLineWithFrame:CGRectMake(0, 44.f-SPLITLINE_HEIGHT, _contentLab.width, SPLITLINE_HEIGHT) onSuperLayer:_contentLab.layer];
    }
    return _bottomLine;
}

- (UIButton *)selectIcon {
    if (!_selectIcon) {
        _selectIcon = [[UIButton alloc] initWithFrame:CGRectMake(self.contentLab.right - 44, 0, 44, 44)];
        _selectIcon.userInteractionEnabled = NO;
        [_selectIcon setImage:LOAD_IMAGE(@"createhouse_none_icon") forState:UIControlStateNormal];
        [_selectIcon setImage:LOAD_IMAGE(@"createhouse_ok_icon") forState:UIControlStateSelected];
        [self.contentView addSubview:_selectIcon];
    }
    return _selectIcon;
}

#pragma mark - Setter

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLab.text = _content;
}

- (void)setNoRightIcon:(BOOL)noRightIcon {
    _noRightIcon = noRightIcon;
    self.selectIcon.hidden = _noRightIcon;
    self.bottomLine.hidden = _noRightIcon;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.selectIcon.selected = _isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
