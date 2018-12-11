//
//  WSMPasswordInput.m
//  WSM
//
//  Created by luo guilin on 2018/7/16.
//  Copyright © 2018年 mvoicer. All rights reserved.
//

#import "WSMPasswordInput.h"

static const NSInteger WSMPasswordInputBaseTag = 1300;

@interface WSMPasswordInput () <UITextFieldDelegate>

@property (nonatomic, copy) WSMStringBlock textChanged;

@end

@implementation WSMPasswordInput

+ (instancetype)inputAtPosition:(CGPoint)position {
    return [WSMPasswordInput inputAtPosition:position count:4];
}

+ (instancetype)inputAtPosition:(CGPoint)position count:(NSInteger)count {
    WSMPasswordInput *input = [[WSMPasswordInput alloc] initWithFrame:WSMRect(position.x, position.y, 129, 30)];
    input.count = count;
    return input;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _count = 4;
        _text = @"";
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat space = 3*SCREEN_RATE;
    CGFloat width = (self.width-space*(_count-1))/_count;
    for (NSInteger i = 0; i < _count; i ++) {
        UITextField *number = [[UITextField alloc] initWithFrame:CGRectMake((space+width)*i, 0, width, self.height)];
        number.tag = WSMPasswordInputBaseTag + i;
        number.delegate = self;
        number.bottomHeight = SCREEN_RATE;
        number.keyboardType = UIKeyboardTypeNumberPad;
        number.font = [UIFont wsm_font:15 bold:YES];
        number.textColor = BLACK_COLOR;
        number.textAlignment = NSTextAlignmentCenter;
        [number addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:number];
    }
}

- (void)resetNumbers {
    NSMutableArray *numbers = [NSMutableArray array];
    for (NSInteger i = 0; i < _text.length; i ++) {
        NSString *num = [_text substringWithRange:NSMakeRange(i, 1)];
        if ([num notNull]) {
            [numbers addObject:num];
        }
    }
    
    for (NSInteger i = 0; i < _count; i ++) {
        UILabel *number = [self viewWithTag:WSMPasswordInputBaseTag+i];
        number.text = [numbers itemAtIndex:i];
    }
    
    if (_textChanged) {
        _textChanged(_text);
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    
    NSInteger editingIndex = -1;
    for (NSInteger i = 0; i < _count; i ++) {
        UITextField *field = [self viewWithTag:WSMPasswordInputBaseTag+i];
        if (field.isEditing) {
            editingIndex = i;
            break;
        }
    }
    if (editingIndex > 0) {
        UITextField *firstField = [self viewWithTag:WSMPasswordInputBaseTag];
        [firstField becomeFirstResponder];
    }
    
    [self resetNumbers];
}

- (void)becomeFirstResponder {
    UITextField *firstField = [self viewWithTag:WSMPasswordInputBaseTag];
    [firstField becomeFirstResponder];
}

- (void)textDidChanged:(WSMStringBlock)changed {
    _textChanged = changed;
}

// 禁止可被粘贴复制
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

#pragma mark - UITextFieldDelegate

- (void)textChanged:(UITextField *)textField {
    NSInteger idx = textField.tag - WSMPasswordInputBaseTag;
    if (idx >= 0 && idx < _count) {
        UITextField *intentField = nil;
        if ([textField.text notNull]) {
            intentField = [self viewWithTag:textField.tag+1];
            _text = [_text stringByAppendingString:textField.text];
        } else {
            intentField = [self viewWithTag:textField.tag-1];
            NSString *txt = @"";
            for (NSInteger i = WSMPasswordInputBaseTag; i < textField.tag; i ++) {
                UITextField *field = [self viewWithTag:i];
                [txt stringByAppendingString:field.text];
            }
            _text = txt;
        }
        if (intentField) {
            [intentField becomeFirstResponder];
        }
        [self resetNumbers];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger idx = textField.tag - WSMPasswordInputBaseTag;
    if (idx >= 0 && idx < _count) {
        if (![_text notNull] && idx > 0) {
            UITextField *firstField = [self viewWithTag:WSMPasswordInputBaseTag];
            [firstField becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
