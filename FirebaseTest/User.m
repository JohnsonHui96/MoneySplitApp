//
//  User.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype) initWithName:(NSString*) userName
                          id:(NSString*) userID email: (NSString*) userEmail netBalance: (NSString*) balance {
    self = [super init];
    if(self) {
        _name = userName;
        _userID = userID;
        _email = userEmail;
        _netBalance = balance;
    }
    return self;
}

@end
