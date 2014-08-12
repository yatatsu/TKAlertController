//
//  ViewController.h
//  AlertViewControllerSample
//
//  Created by kitagawa on 2014/08/07.
//  Copyright (c) 2014年 kitagawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAlertController.h"

typedef NS_ENUM(NSInteger, ACSAlertActionType) {
    ACSAlertActionTypeActionSheet,
    ACSAlertActionTypeAlert,
};

typedef NS_ENUM(NSInteger, ACSAlertVersionType) {
    ACSWithoutAlertAction,
    ACSWithAlertAction,
};

typedef NS_ENUM(NSInteger, ACSAlertActionTag) {
    ACSAlertActionTagActionSheet = 1,
    ACSAlertActionTagActionSheetUsingAlertAction,
    ACSAlertActionTagAlertView,
    ACSAlertActionTagAlertViewUsingAlertAction,
};

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *loggingField;

//@property (nonatomic, weak) UIAlertAction *OKAlertAction;

- (void)displayMessage:(NSString *)message;

@end
