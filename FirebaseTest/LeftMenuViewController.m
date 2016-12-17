//
//  LeftMenuViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+LMSideBarController.h"
#import "HomeViewController.h"
#import "MainNavigationController.h"
#import "Database.h"
@interface LeftMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuTitles;
@property (weak, nonatomic) IBOutlet UILabel *userNameTextLabel;
@property (nonatomic, strong) Database * db;
@property (nonatomic, strong) NSArray* nameManager;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //maybe need name later but not for now
    _db = [Database sharedModel];
    self.menuTitles = @[@"Home", @"Add Friend", @"Add Bill"];
    
    // Do any additional setup after loading the view.
}

-(void) setNameLabel: (NSString*) name {
        _userNameTextLabel.text = name;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLE VIEW DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.menuTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.11 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainNavigationController *mainNavigationController = (MainNavigationController *)self.sideBarController.contentViewController;
    NSString *menuTitle = self.menuTitles[indexPath.row];
    if ([menuTitle isEqualToString:@"Home"]) {
        [mainNavigationController showHomeViewController];
    }
    else if([menuTitle isEqualToString:@"Add Friend"]) {
        [mainNavigationController showAddFriendViewController];
    } else if([menuTitle isEqualToString:@"Add Bill"]) {
        [mainNavigationController showAddBillViewController];
    }
    [self.sideBarController hideMenuViewController:YES];
    

    //if(mainNavigationController.)
//    else {
//        mainNavigationController.othersViewController.title = menuTitle;
//        [mainNavigationController showOthersViewController];
//    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
