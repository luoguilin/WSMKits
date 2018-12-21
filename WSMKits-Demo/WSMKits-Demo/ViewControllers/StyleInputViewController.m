//
//  StyleInputViewController.m
//  WSMKits-Demo
//
//  Created by Mvoicer on 2018/12/18.
//  Copyright © 2018 luoguilin. All rights reserved.
//

#import "StyleInputViewController.h"
#import "WSMStyleInputView.h"

@interface StyleInputViewController ()

@property (weak, nonatomic) IBOutlet WSMStyleInputView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation StyleInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)buildUI {
    JHVCConfig *config     = [[JHVCConfig alloc] init];
    config.inputBoxNumber  = 4;
    config.inputBoxSpacing = 4;
    config.inputBoxWidth   = 33;
    config.inputBoxHeight  = 28;
    config.tintColor       = [UIColor blueColor];
    config.secureTextEntry = YES;
    config.inputBoxColor   = [UIColor clearColor];
    config.font            = [UIFont boldSystemFontOfSize:16];
    config.textColor       = [UIColor grayColor];
    config.inputType       = JHVCConfigInputType_Alphabet;
    
    config.inputBoxBorderWidth  = 1;
    config.showUnderLine = YES;
    config.underLineSize = CGSizeMake(33, 2);
    config.underLineColor = [UIColor brownColor];
    config.underLineHighlightedColor = [UIColor redColor];
    
    _inputView.config = config;
    _inputView.finishBlock = ^(NSString *code) {
        self.textLabel.text = code;
    };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
