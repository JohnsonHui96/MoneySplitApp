//
//  AddFriendViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "AddFriendViewController.h"
#import "UIViewController+LMSideBarController.h"
#import "Database.h"
@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) Database* db;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Friend";
    _db = [Database sharedModel];
    [self setDefaultValues];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [self setDefaultValues];
}

- (void) setDefaultValues{
    _emailTextField.text = @"";
}

//Action for adding a friend
- (IBAction)addFriendButtonPushed:(id)sender {
    NSString* getEmail = _emailTextField.text;
    
    //Fails if email length is empty
    if([getEmail length] == 0){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"Email is empty!"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [_db addUser:getEmail onCompletion:^(bool userExists) {
            //user exists
            if(userExists) {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Success!"
                                                      message:@"Friend was added"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"OK action");
                                           }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                //user doesn't exist
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Error"
                                                      message:@"Email doesn't exist!"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"OK action");
                                           }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }

}

//Left menu bar action
- (IBAction)menuButtonPressed:(id)sender {
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
