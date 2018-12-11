//
//  WSMActionSheet.m
//  WSM
//
//  Created by luo guilin on 2017/9/23.
//  Copyright © 2017年 mvoicer. All rights reserved.
//

#import "WSMActionSheet.h"
#import "WSMActionSheetCell.h"
#import "WSMTextView.h"

@interface WSMActionSheet () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    NSInteger selectIndex;
}
@property (nonatomic, strong) UITableView *itemList;
@property (nonatomic, strong) UIView *footerBar;
@property (nonatomic, strong) WSMTextView *textView;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

static NSString *const WSMActionSheetCellID = @"WSMActionSheetCell";

@implementation WSMActionSheet

+ (instancetype)sheet {
    static WSMActionSheet *sheet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sheet = [[WSMActionSheet alloc] initWithFrame:[AppDelegate ad].window.frame];
        [[AppDelegate ad].window addSubview:sheet];
    });
    return sheet;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.itemList.tableFooterView = self.footerBar;
        selectIndex = -1;
        Add_Observer(UIKeyboardDidChangeFrameNotification, @selector(keyboardDidChangeFrame:), nil);
    }
    return self;
}

- (void)keyboardDidChangeFrame:(NSNotification *)noti {
    NSDictionary *info = [noti userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (endKeyboardRect.origin.y >= SCREEN_HEIGHT) {
        // 键盘收起时
        self.height = SCREEN_HEIGHT;
        self.itemList.height = self.itemList.rowHeight * _itemContents.count + self.footerBar.height;
        self.itemList.y = self.height - self.itemList.height;
        self.itemList.contentOffset = CGPointZero;
    } else {
        // 键盘展开时
        self.height = SCREEN_HEIGHT- endKeyboardRect.size.height;
        if (self.itemList.height > self.height - 64) {
            self.itemList.y = 64;
            self.itemList.height = self.height - 64;
            self.itemList.contentOffset = CGPointMake(0, self.itemList.rowHeight * _itemContents.count + self.footerBar.height - self.itemList.height);
        } else {
            self.itemList.height = self.itemList.rowHeight * _itemContents.count + self.footerBar.height;
            self.itemList.y = self.height - self.itemList.height;
        }
    }
}

- (UITableView *)itemList {
    if (!_itemList) {
        _itemList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 0)];
        _itemList.backgroundColor = [UIColor whiteColor];
        _itemList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _itemList.dataSource = self;
        _itemList.delegate = self;
        _itemList.scrollEnabled = NO;
        _itemList.showsVerticalScrollIndicator = NO;
        _itemList.showsHorizontalScrollIndicator = NO;
        _itemList.bounces = NO;
        _itemList.rowHeight = 44;
        [_itemList registerClass:[WSMActionSheetCell class] forCellReuseIdentifier:WSMActionSheetCellID];
        [self addSubview:_itemList];
    }
    return _itemList;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSMActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:WSMActionSheetCellID];
    cell.content = [_itemContents itemAtIndex:indexPath.row];
    cell.noRightIcon = indexPath.row == _itemContents.count - 1;
    cell.isSelected = selectIndex == indexPath.row;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _itemContents.count - 1) {
        return;
    }
    NSIndexPath *preSel = [NSIndexPath indexPathForRow:selectIndex >= 0 ? selectIndex : 0 inSection:0];
    if (indexPath.row == selectIndex) {
        selectIndex = -1;// 还原
    } else {
        selectIndex = indexPath.row;
    }
    [tableView reloadRowsAtIndexPaths:@[preSel, indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UIView *)footerBar {
    if (!_footerBar) {
        _footerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 112)];
        _footerBar.backgroundColor = [UIColor whiteColor];
        
        [_footerBar addSubview:self.textView];
        [_footerBar addSubview:self.confirmBtn];
    }
    return _footerBar;
}

- (WSMTextView *)textView {
    if (!_textView) {
        _textView = [[WSMTextView alloc] initWithFrame:CGRectMake(24, 0, _footerBar.width - 48, 60)];
        _textView.delegate = self;
        _textView.placeholderColor = [UIColor lightGrayColor];
        _textView.placeholderString = @"请在此输入举报内容";
        [_textView.layer addCornerRadius:4 borderWidth:0.6 borderColor:BACKGROUND_COLOR];
    }
    return _textView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _footerBar.height - 44, _footerBar.width, 44)];
        _confirmBtn.backgroundColor = [UIColor whiteColor];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        // 顶部分割线
        [CALayer wsm_addSplitLineWithFrame:CGRectMake(0, 0, _confirmBtn.width, SPLITLINE_HEIGHT) onSuperLayer:_confirmBtn.layer];
    }
    return _confirmBtn;
}

- (void)confirm {
    if ([self.delegate respondsToSelector:@selector(WSMActionSheet:reportType:content:)]) {
        
        NSString *text = @"";
        if (_textView.text.length) {
            text = _textView.text;
        } else if (selectIndex >= 0) {
            text = [_itemContents itemAtIndex:selectIndex];
        }
        if (text.length == 0) {
            [[AppDelegate ad].window showTips:@"请选择或输入举报内容"];
            return;
        }
        [self hide];
        
        [self.delegate WSMActionSheet:self reportType:[self reportType:text] content:text];
    }
}

- (NSInteger)reportType:(NSString *)content {
    NSInteger type = 0;
    if ([content isEqualToString:@"恶意挂机"]) {
        type = 1;
    } else if ([content isEqualToString:@"言语谩骂"]) {
        type = 2;
    } else if ([content isEqualToString:@"他是演员"]) {
        type = 3;
    } else if ([content isEqualToString:@"涉黄"]) {
        type = 4;
    } else if ([content isEqualToString:@"举报游戏房间"]) {
        type = 5;
    } else if ([content isEqualToString:@"举报用户"]) {
        type = 6;
    } else if ([content isEqualToString:@"举报语聊房间"]) {
        type = 7;
    }
    return type;
}

- (void)setItemContents:(NSArray *)itemContents {
    _itemContents = itemContents;
    
    selectIndex = -1;// 还原
    self.itemList.y = self.height;
    self.itemList.height = self.itemList.rowHeight * _itemContents.count + self.footerBar.height + TABBAR_DIFF;
    [self.itemList reloadData];
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:WSMAnimationDuration animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:BACKGROUND_TRANSPARENCY];
        self.itemList.y = self.height - self.itemList.height;
        self.itemList.hidden = NO;
        self.confirmBtn.hidden = NO;
    }];
}

- (void)hide {
    [_textView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
        self.itemList.y = self.height;
    } completion:^(BOOL finished) {
        self.textView.text = @"";
        self->selectIndex = -1;
        self.itemList.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.hidden = YES;
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)dealloc {
    Remove_Observer(self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
