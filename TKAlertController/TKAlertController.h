//
//  TKAlertController.h
//  AlertViewControllerSample
//
//  Created by kitagawa on 2014/08/07.
//  Copyright (c) 2014年 kitagawa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TKAlertActionStyle) {
    TKAlertActionStyleDefault = 0,
    TKAlertActionStyleCancel,
    TKAlertActionStyleDestructive,
};

typedef NS_ENUM(NSInteger, TKAlertControllerStyle) {
    TKAlertControllerStyleActionSheet = 0,
    TKAlertControllerStyleAlert
};

@interface TKAlertAction : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, readonly) TKAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (id)actionWithTitle:(NSString *)title style:(TKAlertActionStyle)style handler:(void (^)(id action))handler;

@end

@interface TKAlertController : UIViewController

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign, readonly) NSInteger preferredStyle;
@property (nonatomic, strong, readonly) NSArray *actions;
@property (nonatomic, strong, readonly) NSArray *textFields;

+ (UIViewController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(TKAlertControllerStyle)preferredStyle;

@end

@interface UIViewController (TKAlertController)

- (void)addAction:(id)action;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
- (void)presentTKAlertController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)())completion;

@end
