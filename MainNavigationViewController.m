//
//  MainNavigationViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "MainNavigationViewController.h"
@interface MainNavigationViewController ()

@end

@implementation MainNavigationViewController

- (HomeViewController *)homeViewController
{
    if (!_homeViewController) {
        _homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    }
    return _homeViewController;
}
- (void)showHomeViewController
{
    [self setViewControllers:@[self.homeViewController] animated:YES];
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
