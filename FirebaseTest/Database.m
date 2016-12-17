//
//  Database.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "Database.h"
#import "User.h"
#import "UserBalance.h"
@implementation Database

static NSString* const kUserDatabase = @"users";
static NSString* const kFriendsDatabase = @"friends";
static NSString* const KUserEmailDatabase = @"emails";
static NSString* const kTransactionDatabase = @"transactions";
static NSString* const kPendingTransactionDatabase = @"pending transactions";

static NSString* const kUserEmail = @"email";
static NSString* const kUserName = @"name";
static NSString* const kUserId = @"id";
static NSString* const kNegativeBalance = @"negative balance";
static NSString* const kPositiveBalance = @"positive balance";
static NSString* const kNetBalance = @"net balance";
//transactions db
static NSString* const kRequested = @"requested";
static NSString* const kRequestor = @"requestor";
static NSString* const kTransactionAmount = @"amount";
static NSString* const kPositiveTransactions = @"You are owed";
static NSString* const kNegativeTransactions = @"You owe";
static NSString* const kTransactionTitle = @"transaction label";

static NSString* const kPendingNotificationDatabase = @"pending notifications";

//Initialize database
-(instancetype) init {
    self = [super init];
    if (self) {
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

//Singleton Model
+(instancetype) sharedModel {
    static Database* _sharedModel = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

//Retrieves basic user info
-(void) getUserName:(void(^)(NSString* userName))block {
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray* name = [[NSMutableArray alloc]init];
        NSString* currUserID = [FIRAuth auth].currentUser.uid;
        NSString* userName = [[[snapshot childSnapshotForPath:kPendingNotificationDatabase]childSnapshotForPath: currUserID] childSnapshotForPath:kUserName].value;
        [name addObject:userName];
        block([name copy]);
    }];
}

//Get all pending transactions for each user
-(void) getPendingTransactions: (NSString*) currentUser selectedUser: (NSString*) currentFriend onCompletition:(void(^)(NSArray* pendingTransactions))block {
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray* allTransactions = [[NSMutableArray alloc] init];
        FIRDataSnapshot* transactionSnapShot = [snapshot childSnapshotForPath:kTransactionDatabase];
        NSEnumerator* allUserId = [transactionSnapShot children];
        FIRDataSnapshot *currTransaction;
        while(currTransaction = [allUserId nextObject]) {
            NSString* requestedID = [currTransaction childSnapshotForPath:kRequested].value;
            NSString* requestorID = [currTransaction childSnapshotForPath:kRequestor].value;
            NSString* amount = [currTransaction childSnapshotForPath:kTransactionAmount].value;
            NSString* transactionLabel = [currTransaction childSnapshotForPath:kTransactionTitle].value;
            
            NSLog(@"RequestedID: %@", requestedID);
            NSLog(@"RequestorID: %@", requestorID);
            NSLog(@"Transaction Amount: %@", amount);
            NSLog(@"Transaction Label: %@", transactionLabel);
            
            //If current logged-in user owes another user money
            if([requestedID isEqualToString:currentUser] && [requestorID isEqualToString: currentFriend]) {
                UserBalance* toAdd = [[UserBalance alloc] init];
                NSString* negativeAmount = [NSString stringWithFormat:@"-$%@", amount];
                [toAdd setNetBalance:negativeAmount];
                [toAdd setTransactionTitle:transactionLabel];
                [allTransactions addObject:toAdd];
            } else if([requestedID isEqualToString:currentFriend] && [requestorID isEqualToString: currentUser]) {
                //If current logged-in user is owed money
                NSString* positiveAmount = [NSString stringWithFormat:@"+$%@", amount];
                UserBalance* toAdd = [[UserBalance alloc] init];
                [toAdd setNetBalance:positiveAmount];
                [toAdd setTransactionTitle:transactionLabel];
                [allTransactions addObject:toAdd];
            }
        }
        block([allTransactions copy]);
    }];
    
}

//Get overall balance for current user
-(void) getBalances:(void (^)(NSDictionary*)) block {
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *balanceDictionary = [[NSMutableDictionary alloc]init];
        NSString* currUserID = [FIRAuth auth].currentUser.uid;
        FIRDataSnapshot* userSnapShot = [snapshot childSnapshotForPath:kUserDatabase];
        NSString* currUserNegBalance = [[userSnapShot childSnapshotForPath:currUserID] childSnapshotForPath:kNegativeBalance].value;
        NSString* currUserPosBalance = [[userSnapShot childSnapshotForPath:currUserID] childSnapshotForPath:kPositiveBalance].value;
        UserBalance* balance = [[UserBalance alloc]init];
        balance.negBalance = currUserNegBalance;
        balance.posBalance = currUserPosBalance;
        [balance calculateNetBalance];
        [balanceDictionary setObject:currUserPosBalance forKey:kPositiveBalance];
        [balanceDictionary setObject:currUserNegBalance forKey:kNegativeBalance];
        [balanceDictionary setObject: balance.netBalance forKey:kNetBalance];
        block([balanceDictionary copy]);
        
    }];

}

//Populates home table view for Home View Controller
-(void) getHomeTableView:(void (^)(NSArray *))block {
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableArray *friendsArray = [[NSMutableArray alloc]init];
        NSString* currentUserId = [FIRAuth auth].currentUser.uid;
        FIRDataSnapshot *allFriends = [[snapshot childSnapshotForPath:kFriendsDatabase] childSnapshotForPath: currentUserId];
        
        NSEnumerator* allFriendId = [allFriends children];
        FIRDataSnapshot *child;

        while(child = [allFriendId nextObject]) {
            NSString* childEmail = [child childSnapshotForPath: kUserEmail].value;
            NSString* childName = [child childSnapshotForPath:kUserName].value;
            NSString* childBalance = [child childSnapshotForPath:kNetBalance].value;
            User* toAdd = [[User alloc] initWithName:childName id: child.key email: childEmail netBalance:childBalance];
            NSLog(@"toAdd name: %@", toAdd.name);
            NSLog(@"toAdd id: %@", toAdd.userID);
            [friendsArray addObject: toAdd];
        }
        
        block([friendsArray copy]);
    }];
}

//Returns the userID given user email
-(void) findUserID: (NSString*) userEmail onCompletition: (void(^)(NSString*)) block {
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        FIRDataSnapshot *allUsers = [snapshot childSnapshotForPath:kUserDatabase];
        NSEnumerator* allUserId = [allUsers children];
        FIRDataSnapshot *currUser;
        NSString* userID = @"nil";
        while(currUser = [allUserId nextObject]) {
            NSString* currUserEmail = [currUser childSnapshotForPath:kUserEmail].value;
            NSLog(@"current user email is: %@", currUserEmail);
            //found the email associated with ID
            if([currUserEmail isEqualToString:userEmail]) {
                NSLog(@"USER IS FOUND, SEND BACK IN BLOCK");
                userID = currUser.key;
                break;
            }
        }
        NSLog(@"ABOUT TO SEND BACK");
        block([userID copy]);
    }];
}

//Stores added bill in database
-(void) addBill: (NSString*) userID withAmount: (NSString*) amount withTitle:(NSString*)title isRequestor:(bool) didRequest onCompletition:(void(^)(bool billComplete)) block {
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
        NSString* currUserID = [FIRAuth auth].currentUser.uid;
        NSLog(@"PARAMETERS ************* USER ID: %@" , userID);
        NSLog(@"PARAMETERS ************* AMOUNT: %@" , amount);
        NSLog(@"PARAMETERS ************* TITLE: %@" , title);
        FIRDataSnapshot* userSnapShot = [snapshot childSnapshotForPath:kUserDatabase];
        NSString* currUserNegBalance = [[userSnapShot childSnapshotForPath:currUserID] childSnapshotForPath:kNegativeBalance].value;
        NSString* currUserPosBalance = [[userSnapShot childSnapshotForPath:currUserID] childSnapshotForPath:kPositiveBalance].value;
        NSString* otherUserNegBalance = [[userSnapShot childSnapshotForPath:userID] childSnapshotForPath:kNegativeBalance].value;
        NSString* otherUserPosBalance = [[userSnapShot childSnapshotForPath:userID] childSnapshotForPath:kPositiveBalance].value;
        
        //net between each other
        NSString* currUserNetBalance = [[[[snapshot childSnapshotForPath:kFriendsDatabase] childSnapshotForPath:currUserID]childSnapshotForPath:userID]childSnapshotForPath:kNetBalance].value;
        NSString* otherUserNetBalance = [[[[snapshot childSnapshotForPath:kFriendsDatabase] childSnapshotForPath:userID]childSnapshotForPath:currUserID]childSnapshotForPath:kNetBalance].value;
        
        //convert each balance to floats
        float currUserNeg = [currUserNegBalance floatValue];
        float currUserPos = [currUserPosBalance floatValue];
        float otherUserNeg = [otherUserNegBalance floatValue];
        float otherUserPos = [otherUserPosBalance floatValue];
        float billAmount = [amount floatValue];
        float currUserNet = [currUserNetBalance floatValue];
        float otherUserNet = [otherUserNetBalance floatValue];
        
        if(!didRequest) {
            currUserPos += billAmount;
            otherUserNeg += billAmount;
            currUserNet += billAmount;
            otherUserNet -= billAmount;
            
            NSLog(@"******currUserPos is: %f", currUserPos);
            NSLog(@"*******otherUserNeg is: %f", otherUserNeg);
            NSString *currUserFormat = [[NSString alloc] initWithFormat:@"%.02f", currUserPos];
            NSString *otherUserFormat = [[NSString alloc] initWithFormat:@"%.02f",otherUserNeg];
            NSString *currUserNetFormat = [[NSString alloc] initWithFormat:@"%.02f", currUserNet];
            NSString *otherUserNetFormat = [[NSString alloc] initWithFormat:@"%.02f", otherUserNet];
            
            NSLog(@"****currUserFormat is: %@", currUserFormat);
            NSLog(@"******otherUserFormat is: %@", otherUserFormat);
            FIRDatabaseReference *transactionRef = [[_ref child:kTransactionDatabase] childByAutoId];
            [transactionRef setValue:@{kRequested: userID, kRequestor: currUserID, kTransactionAmount: amount, kTransactionTitle: title}];
            
            //change overall balance of both
            [[[[_ref child:kUserDatabase] child:currUserID] child: kPositiveBalance]setValue:currUserFormat];
            
            [[[[_ref child:kUserDatabase] child:userID] child: kNegativeBalance]setValue:otherUserFormat];
            
            [[[[[_ref child:kFriendsDatabase] child:currUserID] child:userID] child:kNetBalance]setValue:currUserNetFormat];
            [[[[[_ref child:kFriendsDatabase] child:userID] child:currUserID] child:kNetBalance]setValue:otherUserNetFormat];
            block(true);
            
        } else {
            currUserNeg += billAmount;
            otherUserPos += billAmount;
            currUserNet -= billAmount;
            otherUserNet += billAmount;
            
            NSLog(@"******currUserNeg is: %f", currUserNeg);
            NSLog(@"*******otherUserPos is: %f", otherUserPos);
            NSString *currUserFormat = [[NSString alloc] initWithFormat:@"%.02f", currUserNeg];
            NSString *otherUserFormat = [[NSString alloc] initWithFormat:@"%.02f",otherUserPos];
            NSLog(@"****currUserFormat is: %@", currUserFormat);
            NSLog(@"******otherUserFormat is: %@", otherUserFormat);
            
            NSString *currUserNetFormat = [[NSString alloc] initWithFormat:@"%.02f", currUserNet];
            NSString *otherUserNetFormat = [[NSString alloc] initWithFormat:@"%.02f", otherUserNet];
            
            FIRDatabaseReference *transactionRef = [[_ref child:kTransactionDatabase] childByAutoId];
            [transactionRef setValue:@{kRequested: currUserID, kRequestor: userID, kTransactionAmount: amount, kTransactionTitle: title}];
            
            [[[[_ref child:kUserDatabase] child:userID] child: kPositiveBalance]setValue:otherUserFormat];
            
            [[[[_ref child:kUserDatabase] child:currUserID] child: kNegativeBalance]setValue:currUserFormat];
            [[[[[_ref child:kFriendsDatabase] child:currUserID] child:userID] child:kNetBalance]setValue:currUserNetFormat];
            [[[[[_ref child:kFriendsDatabase] child:userID] child:currUserID] child:kNetBalance]setValue:otherUserNetFormat];
            
            block(true);
            
        }
    }];
}

//Store added user to database
-(void) addUser: (NSString*) email onCompletion: (void (^)(bool userExists)) block {
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
        //get current user name, id,  and email
        NSString* userId = [FIRAuth auth].currentUser.uid;
        FIRDataSnapshot *userInfo = [[snapshot childSnapshotForPath:kUserDatabase] childSnapshotForPath:userId];
        NSString* userEmail = [userInfo childSnapshotForPath:kUserEmail].value;
        NSString* userName = [userInfo childSnapshotForPath:kUserName].value;
        
        //find the user to add
        FIRDataSnapshot *allUsers = [snapshot childSnapshotForPath:kUserDatabase];
        NSEnumerator* allUserId = [allUsers children];
        FIRDataSnapshot *currUser;
        while(currUser = [allUserId nextObject]) {
            NSString* currUserEmail = [currUser childSnapshotForPath:kUserEmail].value;
            NSLog(@"current user email is: %@", currUserEmail);
            if([currUserEmail isEqualToString:email]) {
                //add to your friends
                NSString* currUserId = currUser.key;
                NSString* currUserName = [currUser childSnapshotForPath:kUserName].value;
                NSLog(@"current user id is: %@", currUserId);
                NSLog(@"current user name is: %@" , currUserName);
                
                //add to both friends list
                [[[[_ref child:kFriendsDatabase] child:userId] child: currUserId ]setValue:@{kUserEmail: currUserEmail, kUserName: currUserName, kNetBalance: @"0.00"}];
                [[[[_ref child:kFriendsDatabase] child:currUserId] child: userId ]setValue:@{kUserEmail: userEmail, kUserName: userName, kNetBalance: @"0.00"}];
                block(true);
            }
        }
        block(false);
    }];
}

@end
