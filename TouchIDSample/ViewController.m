//
//  ViewController.m
//  TouchIDSample
//
//  Created by Tatsuya Arai on 8/14/14.
//  Copyright (c) 2014 cutmail. All rights reserved.
//


#import "ViewController.h"
#import <FlatUIKit/FlatUIKit.h>

@import LocalAuthentication;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FUIButton *button;
@end

@implementation ViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupButton
{
    self.button.buttonColor = [UIColor turquoiseColor];
    self.button.shadowColor = [UIColor greenSeaColor];
    self.button.shadowHeight = 3.0f;
    self.button.cornerRadius = 6.0f;
    self.button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    
    [self.button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (IBAction)authButtonPushed:(id)sender
{
    LAContext *laContext = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *localizedReason = @"どうしても必要なので指を置いてください";
    
    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                               error:&error]) {
        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:localizedReason
                            reply:^(BOOL success, NSError *error) {
                            
                                if (success) {
                                    [self showAlertViewWithTitle:@"認証成功"
                                                         message:@"認証が完了しました。"];
                                }
                                else {
                                    NSLog(@"%@", error);
                                    
                                    if (error.code == LAErrorUserFallback) {
                                        [self showAlertViewWithTitle:@"エラー"
                                                             message:@"「パスワードを入力」ボタンが押されました。"];
                                    } else {
                                        [self showAlertViewWithTitle:@"エラー"
                                                             message:@"認証に失敗しました。"];
                                    }
                                }
                            }];
    }
    else {
        NSLog(@"can't use touchID");
    }
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
