//
//  TKAlertController.m
//  AlertViewControllerSample
//
//  Created by kitagawa on 2014/08/07.
//  Copyright (c) 2014年 kitagawa. All rights reserved.
//

#import "TKAlertController.h"

#pragma mark - TKAlertAction

@interface TKAlertAction ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) TKAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(id action);

- (instancetype)initWithTitle:(NSString *)title style:(TKAlertActionStyle)style handler:(void (^)(id action))handler;

@end

@implementation TKAlertAction

#pragma mark - Initialize

- (instancetype)initWithTitle:(NSString *)title
                        style:(TKAlertActionStyle)style
                      handler:(void (^)(id action))handler
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _style = style;
        _handler = [handler copy];
        _enabled = YES;
    }
    return self;
}

+ (id)actionWithTitle:(NSString *)title
                          style:(TKAlertActionStyle)style
                        handler:(void (^)(id action))handler
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    Class klass = NSClassFromString(@"UIAlertAction");
    if (klass) {
        // And over iOS8
        UIAlertActionStyle alertActionStyle;
        switch (style) {
            case TKAlertActionStyleCancel:
                alertActionStyle = UIAlertActionStyleCancel;
                break;
            case TKAlertActionStyleDefault:
                alertActionStyle = UIAlertActionStyleDefault;
                break;
            case TKAlertActionStyleDestructive:
                alertActionStyle = UIAlertActionStyleDestructive;
                break;
        }
        return [UIAlertAction actionWithTitle:title style:alertActionStyle handler:handler];
    } else {
        // Under iOS8
        return [[TKAlertAction alloc] initWithTitle:title style:style handler:handler];
    }
#else
    return [[TKAlertAction alloc] initWithTitle:title style:style handler:handler];
#endif
}

- (id)copyWithZone:(NSZone *)zone
{
    TKAlertAction *alertAction = [[TKAlertAction allocWithZone:zone] initWithTitle:self.title style:self.style handler:self.handler];
    return alertAction;
}

@end

#pragma mark - TKAlertController

@interface TKAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign, readwrite) NSInteger preferredStyle;
@property (nonatomic, strong, readwrite) NSMutableArray *alertActions;
@property (nonatomic, strong, readwrite) NSMutableArray *alertTextFields;
@property (nonatomic, strong) TKAlertAction *cancelAlertAction;
@property (nonatomic, strong) TKAlertAction *destructiveAlertAction;
@property (nonatomic, copy) NSMutableArray *textFieldHandlers;

- initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(TKAlertControllerStyle)style;

@end

@implementation TKAlertController

#pragma mark - initialize

- (id)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(TKAlertControllerStyle)preferredStyle
{
    self = [super init];
    if (self) {
        self.title = [title copy]; // _title is conflict to UIViewController.title.
        _message = [message copy];
        _preferredStyle = preferredStyle;
        _alertActions = [NSMutableArray array];
    }
    return self;
}

+ (UIViewController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(TKAlertControllerStyle)preferredStyle
{
    UIViewController *controller;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    Class klass = NSClassFromString(@"UIAlertController");
    if (klass) {
        // and over iOS 8
        UIAlertControllerStyle style = preferredStyle == TKAlertControllerStyleActionSheet ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
        controller = alertController;
    } else {
        // under iOS 8
        TKAlertController *alertController = [[TKAlertController alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
        controller = alertController;
    }
#else 
    TKAlertController *alertController = [[TKAlertController alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
    controller = alertController;
#endif
    return controller;
}

#pragma mark - LifeCycle

// these only called when UIAlertController did not exist. (under iOS8)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    switch (self.preferredStyle) {
        case TKAlertControllerStyleActionSheet:
            [self showActionSheet];
            break;
        case TKAlertControllerStyleAlert:
            [self showAlertView];
            break;
    }
}

- (void)showActionSheet
{
    UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:self.title
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil, nil];
    [self.actions enumerateObjectsUsingBlock:^(TKAlertAction *action, NSUInteger idx, BOOL *stop) {
        switch (action.style) {
            case TKAlertActionStyleCancel:
                break;
            case TKAlertActionStyleDestructive:
                actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:self.destructiveAlertAction.title];
                break;
            default:
                [actionSheet addButtonWithTitle:action.title];
                break;
        }
    }];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:self.cancelAlertAction.title];
    
    [actionSheet showInView:[UIApplication sharedApplication].windows.firstObject];
}

- (void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title
                                                        message:self.message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
    
    [self.actions enumerateObjectsUsingBlock:^(TKAlertAction *action, NSUInteger idx, BOOL *stop) {
        switch (action.style) {
            case TKAlertActionStyleCancel:
                alertView.cancelButtonIndex = idx;
                break;
            default:
                break;
        }
        [alertView addButtonWithTitle:action.title];
    }];
    
    // TODO textFields...
    
    [alertView show];
}

#pragma mark - Actions

- (NSArray *)actions
{
    return [_alertActions copy];
}

- (void)addAction:(id)action
{
    [_alertActions addObject:action];
    TKAlertAction *alertAction = (TKAlertAction *)action;
    switch (alertAction.style) {
        case TKAlertActionStyleCancel:
            self.cancelAlertAction = alertAction;
            break;
        case TKAlertActionStyleDestructive:
            self.destructiveAlertAction = alertAction;
            break;
        default:
            break;
    }
}

- (TKAlertAction *)findAlertActionWithTitle:(NSString *)title
{
    for (TKAlertAction *action in self.actions) {
        if ([action.title compare:title] == NSOrderedSame) {
            return action;
        }
    }
    return nil;
}

#pragma mark - TextField in Alert

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *))configurationHandler
{
    // it doesn't allow in actionSheet
    if (self.preferredStyle == TKAlertControllerStyleActionSheet) return;

}

- (NSArray *)textFields
{
    return [_alertTextFields copy];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger cancelButtonIndex = actionSheet.cancelButtonIndex;
    NSInteger destructiveAButtonIndex = actionSheet.destructiveButtonIndex;
    if (buttonIndex == cancelButtonIndex) {
        if (!self.cancelAlertAction.enabled) {
            return;
        }
        if (self.cancelAlertAction.handler) {
            self.cancelAlertAction.handler(self.cancelAlertAction);
        }
    } else if (buttonIndex == destructiveAButtonIndex) {
        if (!self.destructiveAlertAction.enabled) {
            return;
        }
        if (self.destructiveAlertAction.handler) {
            self.destructiveAlertAction.handler(self.destructiveAlertAction);
        }
    } else {
        // find action
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        TKAlertAction *alertAction = [self findAlertActionWithTitle:title];
        if (!alertAction.enabled) {
            return;
        }
        if (alertAction.handler) {
            alertAction.handler(alertAction);
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (!self.cancelAlertAction.enabled) {
            return;
        }
        if (self.cancelAlertAction.handler) {
            self.cancelAlertAction.handler(self.cancelAlertAction);
        }
    } else {
        // find action
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        TKAlertAction *alertAction = [self findAlertActionWithTitle:title];
        if (!alertAction.enabled) {
            return;
        }
        if (alertAction.handler) {
            alertAction.handler(alertAction);
        }
    }

    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

#pragma mark - UIViewController Category

@implementation UIViewController (TKAlertController)

- (void)presentTKAlertController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)())completion
{
    if ([controller isKindOfClass:[TKAlertController class]]) {
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:controller animated:animated completion:completion];
}

- (void)addAction:(id)action
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    Class klazz = NSClassFromString(@"UIAlertController");
    if (klazz) {
        UIAlertController *alertController = (UIAlertController *)self;
        [alertController addAction:action];
    } else {
        TKAlertController *alertController = (TKAlertController *)self;
        [alertController addAction:action];
    }
#else
    TKAlertController *alertController = (TKAlertController *)self;
    [alertController addAction:action];
#endif
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *))configurationHandler
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    Class klazz = NSClassFromString(@"UIAlertController");
    if (klazz) {
        UIAlertController *alertController = (UIAlertController *)self;
        [alertController addTextFieldWithConfigurationHandler:configurationHandler];
    } else {
        TKAlertController *alertController = (TKAlertController *)self;
        [alertController addTextFieldWithConfigurationHandler:configurationHandler];
    }
#else
    TKAlertController *alertController = (TKAlertController *)self;
    [alertController addTextFieldWithConfigurationHandler:configurationHandler];
#endif
}

@end
