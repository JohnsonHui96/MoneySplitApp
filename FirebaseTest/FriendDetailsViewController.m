//
//  FriendDetailsViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "FriendDetailsViewController.h"
#import "Database.h"
#import "Firebase.h"
#import "UserBalance.h"
static NSString* const kPositiveTransactions = @"You are owed";
static NSString* const kNegativeTransactions = @"You owe";

@interface FriendDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNetBalanceLabel;
@property (nonatomic, strong) Database* db;
@property (weak, nonatomic) IBOutlet UITableView *transactionsTableView;
@property (weak, nonatomic) IBOutlet UILabel *selectedFriendLabel;
@property (nonatomic, strong) NSArray* transactionsManager;


@end

@implementation FriendDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _db = [Database sharedModel];
    [self loadLabels];
    [self loadTransactions];
    NSLog(@"DID U PASS IT THE SELECTED USER? %@", _selectedFriend.name);
    
    // Do any additional setup after loading the view.
}

//Default pre-loading
-(void) loadLabels {
    
    _friendNameLabel.text = _selectedFriend.name;
    _emailLabel.text = _selectedFriend.email;
    NSString *firstLetter = [_selectedFriend.netBalance substringToIndex:1];
    if([firstLetter isEqualToString:@"-"]) {
        //negative
        NSString* convert = [_selectedFriend.netBalance substringFromIndex:1];
        _totalNetBalanceLabel.text = [NSString stringWithFormat:@"-$%@", convert];
        //RGB: 219, 50, 54
        [_totalNetBalanceLabel setTextColor:[UIColor colorWithRed:(219/255.f) green:(50/255.f) blue:(54/255.f) alpha:1.0f]];
        
    } else if([_selectedFriend.netBalance isEqualToString:@"0.00"]){
        _totalNetBalanceLabel.text = [NSString stringWithFormat:@"$%@", _selectedFriend.netBalance];
        [_totalNetBalanceLabel setTextColor:[UIColor colorWithRed:(153/255.f) green:(153/255.f) blue:(153/255.f) alpha:1.0f]];
        
    } else {
        //add positive sign to front
        _totalNetBalanceLabel.text= [NSString stringWithFormat:@"+$%@", _selectedFriend.netBalance];
        [_totalNetBalanceLabel setTextColor:[UIColor colorWithRed:(60/255.f) green:(186/255.f) blue:(84/255.f) alpha:1.0f]];

        //60 186 84
    }
    
}

//Default preloading
-(void) loadTransactions {
    [_db getPendingTransactions:[FIRAuth auth].currentUser.uid selectedUser:_selectedFriend.userID onCompletition:^(NSArray* transactions) {
        
        _transactionsManager = transactions;
        [_transactionsTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [self loadLabels];
    [self loadTransactions];
}

//Info on table view display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_transactionsManager count] == 0) {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _transactionsTableView.bounds.size.width, _transactionsTableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
       _transactionsTableView.backgroundView = noDataLabel;
       _transactionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
       _transactionsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _transactionsTableView.backgroundView = nil;
    }
    
    return [_transactionsManager count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Get the user at index path
    UserBalance* currTransaction = [_transactionsManager objectAtIndex:indexPath.row];
    
    // Modify the cell
    cell.textLabel.text = [currTransaction transactionTitle];
    cell.detailTextLabel.text = [currTransaction netBalance];
    
    //Check sign of amount
    NSString *firstLetter = [[currTransaction netBalance] substringToIndex:1];
    if([firstLetter isEqualToString:@"+"]) {
        //positive
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:(60/255.f) green:(186/255.f) blue:(84/255.f) alpha:1.0f]];
    } else {
        //negative
         [cell.detailTextLabel setTextColor:[UIColor colorWithRed:(219/255.f) green:(50/255.f) blue:(54/255.f) alpha:1.0f]];
    }
    // Return the cell
    return cell;
}

@end
