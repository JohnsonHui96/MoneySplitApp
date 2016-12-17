//
//  LMRootViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "RootViewController.h"
#import "LMSideBarDepthStyle.h"
#import "MainNavigationController.h"
#import "LeftMenuViewController.h"
#import "HomeViewController.h"
#import "Firebase.h"
#import "Database.h"
@interface RootViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) MainNavigationController* navigationController;
@property (strong, nonatomic) Database* db;
@property (strong, nonatomic) NSString* name;
@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _db = [Database sharedModel];
    [_db getUserName:^(NSString* getName) {
        _name = getName;
    }];

      // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    LMSideBarDepthStyle *sideBarDepthStyle = [LMSideBarDepthStyle new];
    sideBarDepthStyle.menuWidth = 220;
    
    
    // Init view controllers
    
    LeftMenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    [leftMenuViewController setNameLabel:_name];
    _navigationController = [self.storyboard instantiateViewControllerWithIdentifier: @"mainNavigationController"];
   
//    LMRightMenuViewController *rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
//    LMMainNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    
    // Setup side bar controller
    [self setPanGestureEnabled:YES];
    [self setDelegate:self];
    [self setMenuViewController:leftMenuViewController forDirection:LMSideBarControllerDirectionLeft];
    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionLeft];
    [self setContentViewController:_navigationController];
    
}

//- (IBAction)loginButtonPressed:(id)sender {
//
//    NSString* getEmail = _emailTextField.text;
//    NSString* getPassword = _passwordTextField.text;
//    
//    if([getEmail length] == 0 || [getPassword length] == 0) {
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Login Invalid"
//                                              message:@"Email or password empty!"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:@"OK"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       NSLog(@"OK action");
//                                   }];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//    else {
//        [[FIRAuth auth] signInWithEmail:getEmail
//                               password:getPassword
//                             completion:^(FIRUser *user, NSError *error) {
//                                 if(user == nil) {
//                                     UIAlertController *alertController = [UIAlertController
//                                                                           alertControllerWithTitle:@"Login Invalid"
//                                                                           message:@"Email or password incorect!"
//                                                                           preferredStyle:UIAlertControllerStyleAlert];
//                                     UIAlertAction *okAction = [UIAlertAction
//                                                                actionWithTitle:@"OK"
//                                                                style:UIAlertActionStyleDefault
//                                                                handler:^(UIAlertAction *action)
//                                                                {
//                                                                    NSLog(@"OK action");
//                                                                }];
//                                     [alertController addAction:okAction];
//                                     [self presentViewController:alertController animated:YES completion:nil];
//                                 }
//                                 else {
//                                     [self setContentViewController:_navigationController];
//                                 }
//                             }];
//
//    }
//    
//}

#pragma mark - SIDE BAR DELEGATE

- (void)sideBarController:(LMSideBarController *)sideBarController willShowMenuViewController:(UIViewController *)menuViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController willHideMenuViewController:(UIViewController *)menuViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController
{
    
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
