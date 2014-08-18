//
//  ViewController+Alert.m
//  AlertViewControllerSample
//
//  Created by kitagawa on 2014/08/07.
//  Copyright (c) 2014年 kitagawa. All rights reserved.
//

#import "ViewController+Alert.h"

static NSString *kButtonTitleOK = @"OK";
static NSString *kButtonTitleCancel = @"Cancel";
static NSString *kButtonTitlePostpone = @"Remind me later";

@implementation ViewController (Alert)

#pragma mark - traditional style

- (void)presentActionSheetWithTag:(NSInteger)tag
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"ActionSheetOldStyle"
                                                             delegate:self
                                                    cancelButtonTitle:kButtonTitleCancel
                                               destructiveButtonTitle:kButtonTitleOK
                                                    otherButtonTitles:kButtonTitlePostpone, nil];
    actionSheet.tag = tag;
    [actionSheet showInView:self.view];
}

- (void)presentAlertViewWithTag:(NSInteger)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AlertViewOldStyle"
                                                        message:@"Please input 5 chars at least."
                                                       delegate:self
                                              cancelButtonTitle:kButtonTitleCancel
                                              otherButtonTitles:kButtonTitleOK, kButtonTitlePostpone, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = tag;
    [alertView show];
}

# pragma mark - UIAlertController

- (void)presentActionSheetUsingAlertActionWithTag:(NSInteger)tag
{
    NSString *title = @"UIAlertController";
    UIViewController *alertController =
     [TKAlertController alertControllerWithTitle:title
                                         message:@"message can be here"
                                  preferredStyle:TKAlertControllerStyleActionSheet];
    
    // AlertAction
    __weak typeof(self) wself = self;
    TKAlertAction *cancelAction =
     [TKAlertAction actionWithTitle:kButtonTitleCancel
                              style:TKAlertActionStyleCancel
                            handler:^(id action) {
                                [wself didClickCancelButtonWithTag:tag
                                                           message:title];
                            }];
    TKAlertAction *OKAction =
     [TKAlertAction actionWithTitle:kButtonTitleOK
                              style:TKAlertActionStyleDestructive
                            handler:^(TKAlertAction *action) {
                                [wself didClickOKWithTag:tag
                                                 message:title];
                            }];
    TKAlertAction *postponeAction =
     [TKAlertAction actionWithTitle:kButtonTitlePostpone
                              style:TKAlertActionStyleDefault
                            handler:^(TKAlertAction *action) {
                                  [wself didClickRemindMeLaterWithTag:tag
                                                              message:title];
                            }];
    
    // add AlertAction
    [alertController addAction:cancelAction];
    [alertController addAction:OKAction];
    [alertController addAction:postponeAction];

    // present viewController
    [self presentTKAlertController:alertController animated:YES completion:^{
        NSLog(@"...");
    }];
}

- (void)presentAlertViewUsingAlertActionWithTag:(NSInteger)tag
{
    NSString *title = @"UIAlertController";
    UIViewController *alertController =
    [TKAlertController alertControllerWithTitle:title
                                        message:@"Please input 5 chars at least."
                                 preferredStyle:TKAlertControllerStyleAlert];
    
    // AlertAction
    __weak typeof(self) wself = self;
    TKAlertAction *cancelAction =
     [TKAlertAction actionWithTitle:kButtonTitleCancel
                              style:TKAlertActionStyleCancel
                            handler:^(TKAlertAction *action) {
                                [wself didClickCancelButtonWithTag:tag message:title];
                                [wself removeSelfObserver];
                            }];
    TKAlertAction *OKAlertAction =
     [TKAlertAction actionWithTitle:kButtonTitleOK
                              style:TKAlertActionStyleDestructive
                            handler:^(TKAlertAction *action) {
                                [wself didClickOKWithTag:tag message:title];
                                [wself removeSelfObserver];
                            }];
    TKAlertAction *postponeAction =
     [TKAlertAction actionWithTitle:kButtonTitlePostpone
                              style:TKAlertActionStyleDefault
                            handler:^(TKAlertAction *action) {
                                [wself didClickRemindMeLaterWithTag:tag message:title];
                                [wself removeSelfObserver];
                            }];

    // textfield setting
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // set observer
        [[NSNotificationCenter defaultCenter] addObserver:wself
                                                 selector:@selector(checkInputCount:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
    }];
    //OKAlertAction.enabled = NO;
    
    // add AlertAction
    [alertController addAction:cancelAction];
    [alertController addAction:OKAlertAction];
    [alertController addAction:postponeAction];
    
    // present ViewController
    [self presentTKAlertController:alertController animated:YES completion:^{
        NSLog(@"show alert.");
    }];
}

- (void)dismissAlertController:(NSNotification *)notification
{
    
}

- (void)removeSelfObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkInputCount:(NSNotification *)notification
{
//    if (!self.OKAlertAction) return;
//    UITextField *textField = (UITextField *)notification.object;
//    self.OKAlertAction.enabled = textField.text.length > 4;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = actionSheet.tag;
    if (!tag) return;
    NSString *message = @"actionSheet";
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self didClickCancelButtonWithTag:actionSheet.tag message:@"actionSheet"];
        return;
    }
    switch (buttonIndex) {
        case 0:
            [self didClickOKWithTag:tag message:message];
            break;
            
        case 1:
            [self didClickRemindMeLaterWithTag:tag message:message];
            break;
    }
}

#pragma mark - UIAlertViewDelegate

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *input = [alertView textFieldAtIndex:0].text;
    return input.length > 4;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (!tag) return;
    NSString *message = @"UIAlertView";
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self didClickCancelButtonWithTag:tag message:message];
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self didClickOKWithTag:tag message:message];
            break;
            
        case 1:
            [self didClickRemindMeLaterWithTag:tag message:message];
            break;
    }
}

#pragma mark - Callbacks

- (void)didClickCancelButtonWithTag:(NSInteger)tag message:(NSString *)message
{
    [self displayMessage:[NSString stringWithFormat:@"canceled in %@. TAG: %@", message, @(tag)]];
}

- (void)didClickOKWithTag:(NSInteger)tag message:(NSString *)message
{
    [self displayMessage:[NSString stringWithFormat:@"OK in %@. TAG: %@", message, @(tag)]];
}

- (void)didClickRemindMeLaterWithTag:(NSInteger)tag message:(NSString *)message
{
    [self displayMessage:[NSString stringWithFormat:@"postponed in %@. TAG: %@", message, @(tag)]];
}

@end
