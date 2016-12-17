//
//  MainNavigationViewController.h
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
@interface MainNavigationViewController : UINavigationController

@property (nonatomic, strong) HomeViewController *homeViewController;

- (void)showHomeViewController;

@end
