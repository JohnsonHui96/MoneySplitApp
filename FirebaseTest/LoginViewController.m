//
//  ViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/9/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "LoginViewController.h"
#import "Firebase.h"
#import "LMSideBarController.h"
#import "RootViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginButtonPressed:(id)sender {
    
    NSString* getEmail = _emailTextField.text;
    NSString* getPassword = _passwordTextField.text;
    
    if([getEmail length] == 0 || [getPassword length] == 0) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Login Invalid"
                                              message:@"Email or password empty!"
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
    else {
        [[FIRAuth auth] signInWithEmail:getEmail
                               password:getPassword
                             completion:^(FIRUser *user, NSError *error) {
                                 if(user == nil) {
                                     UIAlertController *alertController = [UIAlertController
                                                                           alertControllerWithTitle:@"Login Invalid"
                                                                           message:@"Email or password incorect!"
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
                                 else {
                                     RootViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                                     [rvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                                     [self presentViewController:rvc animated:YES completion:nil];

                                     //go to the root view controller
                                 }
                             }];
    }
    
}

@end
