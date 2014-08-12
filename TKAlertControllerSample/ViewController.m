//
//  ViewController.m
//  AlertViewControllerSample
//
//  Created by kitagawa on 2014/08/07.
//  Copyright (c) 2014年 kitagawa. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+Alert.h"

static NSString *kCellIdentifier = @"UITableViewCell";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"even though alertViewController dissmiss, it not called!");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"never called even though alert has shown.");
}

#pragma mark - Public

- (void)displayMessage:(NSString *)message
{
    self.loggingField.text = message;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case ACSAlertActionTypeActionSheet:
            return @"UIActionSheet";
            
        case ACSAlertActionTypeAlert:
            return @"UIAlertView";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    switch (indexPath.section) {
        case ACSAlertActionTypeActionSheet:
            // UIActionSheet
            switch (indexPath.row) {
                case ACSWithoutAlertAction:
                    cell.textLabel.text = @"UIActionSheet";
                    break;
                case ACSWithAlertAction:
                    cell.textLabel.text = @"UIAlertControllerStyleActionSheet";
                    break;
            }
            break;
            
        case ACSAlertActionTypeAlert:
            // UIAlert
            switch (indexPath.row) {
                case ACSWithoutAlertAction:
                    cell.textLabel.text = @"UIAlertView";
                    break;
                case ACSWithAlertAction:
                    cell.textLabel.text = @"UIAlertControllerStyleAlert";
                    break;
            }
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [NSString stringWithFormat:@"index >>>> section: %@, row: %@", @(indexPath.section), @(indexPath.row)];
    [self displayMessage:message];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case ACSAlertActionTypeActionSheet:
            switch (indexPath.row) {
                case ACSWithoutAlertAction:
                    [self presentActionSheetWithTag:ACSAlertActionTagActionSheet];
                    break;
                    
                case ACSWithAlertAction:
                    [self presentActionSheetUsingAlertActionWithTag:ACSAlertActionTagActionSheetUsingAlertAction];
                    break;
            }
            break;
            
        case ACSAlertActionTypeAlert:
            switch (indexPath.row) {
                case ACSWithoutAlertAction:
                    [self presentAlertViewWithTag:ACSAlertActionTagAlertView];
                    break;
                    
                case ACSWithAlertAction:
                    [self presentAlertViewUsingAlertActionWithTag:ACSAlertActionTagAlertViewUsingAlertAction];
                    break;
            }
            break;
    }
}

@end
