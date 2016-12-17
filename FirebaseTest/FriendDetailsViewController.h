//
//  FriendDetailsViewController.h
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface FriendDetailsViewController : UIViewController
@property (nonatomic, strong) User* selectedFriend;
-(void) loadTransactions;
@end
