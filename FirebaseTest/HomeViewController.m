//
//  HomeViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+LMSideBarController.h"
#import "Firebase.h"
#import "Database.h"
#import "User.h"
#import "UserBalance.h"
#import "FriendDetailsViewController.h"
#import "LoginViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
static NSString* const kNegativeBalance = @"negative balance";
static NSString* const kPositiveBalance = @"positive balance";
static NSString* const kNetBalance = @"net balance";

@interface HomeViewController() <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) Database* db;
@property (strong, nonatomic) NSArray* friendsManager;
@property (weak, nonatomic) IBOutlet UILabel *userPosBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNegBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNetBalanceLabel;
@property (strong, nonatomic) NSDictionary* balanceManager;
@end
@implementation HomeViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    _db = [Database sharedModel];
    self.title = @"Home";
    [self loadAllFriends];
    [self loadBalance];

}
-(void) viewWillAppear:(BOOL)animated {
    [self loadAllFriends];
    [self loadBalance];
}

//Method to load net overall balance
-(void) loadBalance {
    [_db getBalances:^(NSDictionary* userBalance) {
        
        _balanceManager = userBalance;
        if([[_balanceManager objectForKey:kPositiveBalance]isEqualToString:@"0.00"]) {
            [_userPosBalanceLabel setTextColor:[UIColor colorWithRed:(153/255.f) green:(153/255.f) blue:(153/255.f) alpha:1.0f]];
        } else {
            [_userPosBalanceLabel setTextColor:[UIColor colorWithRed:(60/255.f) green:(186/255.f) blue:(84/255.f) alpha:1.0f]];
        }
        
        if([[_balanceManager objectForKey:kNegativeBalance]isEqualToString:@"0.00"]) {
            [_userNegBalanceLabel setTextColor:[UIColor colorWithRed:(153/255.f) green:(153/255.f) blue:(153/255.f) alpha:1.0f]];
        } else {
            [_userNegBalanceLabel setTextColor:[UIColor colorWithRed:(219/255.f) green:(50/255.f) blue:(54/255.f) alpha:1.0f]];
        }

        _userPosBalanceLabel.text = [NSString stringWithFormat:@"+$%@",[_balanceManager objectForKey:kPositiveBalance]];
        _userNegBalanceLabel.text = [NSString stringWithFormat:@"-$%@",[_balanceManager objectForKey:kNegativeBalance]];
        NSString *firstLetter = [[_balanceManager objectForKey:kNetBalance] substringToIndex:1];
        if([firstLetter isEqualToString:@"-"]) {
            //negative
            NSString* convert = [[_balanceManager objectForKey:kNetBalance] substringFromIndex:1];
            _userNetBalanceLabel.text = [NSString stringWithFormat:@"-$%@", convert];
            //RGB: 219, 50, 54
            [_userNetBalanceLabel setTextColor:[UIColor colorWithRed:(219/255.f) green:(50/255.f) blue:(54/255.f) alpha:1.0f]];

        } else if([[_balanceManager objectForKey:kNetBalance]isEqualToString:@"0.00"]){
            _userNetBalanceLabel.text = [NSString stringWithFormat:@"$%@", [_balanceManager objectForKey:kNetBalance]];
            [_userNetBalanceLabel setTextColor:[UIColor colorWithRed:(153/255.f) green:(153/255.f) blue:(153/255.f) alpha:1.0f]];

        } else {
            //add positive sign to front
            _userNetBalanceLabel.text = [NSString stringWithFormat:@"+$%@", [_balanceManager objectForKey:kNetBalance]];
            [_userNetBalanceLabel setTextColor:[UIColor colorWithRed:(60/255.f) green:(186/255.f) blue:(84/255.f) alpha:1.0f]];

            //60 186 84
        }
        
    }];
}

//Loads all friends of current user
-(void) loadAllFriends {
    [_db getHomeTableView:^(NSArray* getFriends) {
        _friendsManager = getFriends;
        
        [_friendsTableView reloadData];
    }];
}

//Action for left menu bar button
- (IBAction)menuButtonTapped:(id)sender {
         [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Table View delegation methods below
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_friendsManager count] == 0) {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _friendsTableView.bounds.size.width, _friendsTableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        _friendsTableView.backgroundView = noDataLabel;
        _friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
    _friendsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _friendsTableView.backgroundView = nil;
    }
    
    return [_friendsManager count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Create a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    
    // Get the user at index path
    User* currUser = [_friendsManager objectAtIndex:indexPath.row];
    
    // Modify the cell
    cell.textLabel.text = [currUser name];
    NSString *firstLetter = [currUser.netBalance substringToIndex:1];
    if([firstLetter isEqualToString:@"-"]) {
        //negative
        NSString* convert = [currUser.netBalance substringFromIndex:1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"-$%@", convert];
        //RGB: 219, 50, 54
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:(219/255.f) green:(50/255.f) blue:(54/255.f) alpha:1.0f]];
        
    } else if ([currUser.netBalance isEqualToString:@"0.00"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", currUser.netBalance];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:(153/255.f) green:(153/255.f) blue:(153/255.f) alpha:1.0f]];
    } else{
        //add positive sign to front
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+$%@", currUser.netBalance];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:(60/255.f) green:(186/255.f) blue:(84/255.f) alpha:1.0f]];
        //60 186 84
    }

   
    
    // Return the cell
    return cell;
}

//Segue for logging out and viewing friend details
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* idSeg = segue.identifier;
    if([idSeg isEqualToString:@"Logout"]) {
        NSError *signOutError;
        BOOL status = [[FIRAuth auth] signOut:&signOutError];
        if (!status) {
            NSLog(@"Error signing out: %@", signOutError);
            return;
        } else {
            LoginViewController *lvc = (LoginViewController*) segue.destinationViewController;
        }
    } else {
        NSIndexPath* indexPath = [self.friendsTableView indexPathForCell: sender];
        User* selectedUser = [_friendsManager objectAtIndex: indexPath.row];
        
        FriendDetailsViewController *fdvc = (FriendDetailsViewController*) segue.destinationViewController;
        
        fdvc.selectedFriend = selectedUser;
    }
}

@end
