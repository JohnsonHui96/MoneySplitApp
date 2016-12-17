//
//  Database.h
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase.h"
#import "UserBalance.h"
@interface Database : NSObject
@property (nonatomic, strong )FIRDatabaseReference* ref;

+(instancetype) sharedModel;
-(void) getHomeTableView: (void (^)(NSArray* friends)) block;
-(void) addUser: (NSString*) email onCompletion: (void (^)(bool userExists)) block;
-(void) findUserID: (NSString*) userEmail onCompletition: (void(^)(NSString*)) block;
-(void) addBill: (NSString*) userID withAmount: (NSString*) amount withTitle:(NSString*)title isRequestor:(bool) didRequest onCompletition:(void(^)(bool billComplete)) block;
-(void) getBalances:(void (^)(NSDictionary*)) block;
-(void) getPendingTransactions: (NSString*) currentUser selectedUser: (NSString*) currentFriend onCompletition:(void(^)(NSArray* pendingTransactions))block;
-(void) getPendingNotifications:(void(^)(NSArray* pendingNotifications))block;
-(void) getUserName:(void(^)(NSString* userName))block;
@end
