//
//  MainNavigationController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HomeViewController *)homeViewController
{
    if (!_homeViewController) {
        _homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    }
    return _homeViewController;
}
- (AddFriendViewController*) addFriendViewController {
    if(!_addFriendViewController) {
        _addFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"addFriendViewController"];
    }
    return _addFriendViewController;
}

- (AddBillViewController*) addBillViewController {
    if(!_addBillViewController) {
        _addBillViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addBillViewController"];
    }
    return _addBillViewController;
}

-(void) showHomeViewController {
    [self setViewControllers:@[self.homeViewController] animated:YES];
}

-(void) showAddFriendViewController {
    [self setViewControllers: @[self.addFriendViewController] animated: YES];
}

-(void) showAddBillViewController {
    [self setViewControllers: @[self.addBillViewController] animated: YES];
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
