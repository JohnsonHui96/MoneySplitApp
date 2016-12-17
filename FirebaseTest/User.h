//
//  User.h
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* userID;
@property(strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* netBalance;
-(instancetype) initWithName:(NSString*) userName id:(NSString*) userID email:(NSString*) userEmail netBalance:(NSString*) balance;
@end
