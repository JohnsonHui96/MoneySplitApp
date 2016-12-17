//
//  MainNavigationController.h
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h";
#import "AddFriendViewController.h"
#import "AddBillViewController.h"
@interface MainNavigationController : UINavigationController

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) AddFriendViewController * addFriendViewController;
@property (nonatomic, strong) AddBillViewController* addBillViewController;
-(void) showHomeViewController;
-(void) showAddFriendViewController;
-(void) showAddBillViewController;

@end
