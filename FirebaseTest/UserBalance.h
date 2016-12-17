//
//  UserBalance.h
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBalance : NSObject
@property (nonatomic, strong) NSString* negBalance;
@property (nonatomic, strong) NSString* posBalance;
@property (nonatomic, strong) NSString* netBalance;
@property (nonatomic, strong) NSString* transactionTitle; 
-(void) calculateNetBalance;
@end
