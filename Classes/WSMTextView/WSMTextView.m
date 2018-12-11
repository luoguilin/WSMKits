//
//  UITextView+M_yWSMTextView.m
//  ASD
//
//  Created by yangyang on 15/12/4.
//  Copyright © 2015年  http://www.ehoo100.com/. All rights reserved.
//
#import "WSMTextView.h"

@interface WSMTextView ()
{
    UILabel *placeholderLabel;
}
@property (nonatomic, copy) WSMTextViewHandler keyboardWillShow;
@property (nonatomic, copy) WSMStringBlock textChanged;

@end

@implementation WSMTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        
        placeholderLabel =  [[UILabel alloc]initWithFrame:CGRectMake(5, 8, self.frame.size.width - 10, 21)];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.textColor = RGBA(100, 100, 100, 1);
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:placeholderLabel];

        self.returnKeyType = UIReturnKeyDone;
        
        Add_Observer(UIKeyboardWillShowNotification, @selector(receivedNotification:), nil);
        Add_Observer(UIKeyboardWillHideNotification, @selector(receivedNotification:), nil);
        Add_Observer(UITextViewTextDidChangeNotification, @selector(receivedNotification:), nil);
    }
    return self;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    placeholderLabel.textColor = _placeholderColor;
}

- (void)setPlaceholderString:(NSString *)placeholderString {
    
    _placeholderString = placeholderString;
    placeholderLabel.text = _placeholderString;
    [placeholderLabel sizeToFit];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    
    placeholderLabel.font = placeholderFont;
    [placeholderLabel sizeToFit];
}

- (void)receivedNotification:(NSNotification *)noti {
    if ([noti.name isEqualToString:UITextViewTextDidChangeNotification]) {
        if (_textChanged) {
            _textChanged(self.text);
        }
        placeholderLabel.hidden = self.hasText;
    } else {
        BOOL show = [noti.name isEqualToString:UIKeyboardWillShowNotification];
        if (_keyboardWillShow) {
            _keyboardWillShow(show, noti.userInfo);
        }
    }
}

- (void)keyboardChanged:(WSMTextViewHandler)showHandler {
    _keyboardWillShow = showHandler;
}

- (void)textDidChanged:(WSMStringBlock)changed {
    _textChanged = changed;
}

- (void)dealloc {
    Remove_Observer(self);
}

@end
