//
//  ViewController+Alert.h
//  AlertViewControllerSample
//
//  Created by kitagawa on 2014/08/07.
//  Copyright (c) 2014年 kitagawa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Alert) <UIAlertViewDelegate, UIActionSheetDelegate>

- (void)presentActionSheetWithTag:(NSInteger)tag;
- (void)presentAlertViewWithTag:(NSInteger)tag;
- (void)presentActionSheetUsingAlertActionWithTag:(NSInteger)tag;
- (void)presentAlertViewUsingAlertActionWithTag:(NSInteger)tag;

@end
