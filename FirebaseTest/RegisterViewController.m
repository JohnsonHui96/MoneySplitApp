//
//  RegisterViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/10/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "RegisterViewController.h"
#import "Firebase.h"
#import "LMSideBarDepthStyle.h"
#import "MainNavigationController.h"
#import "LeftMenuViewController.h"
#import "HomeViewController.h"
#import "Firebase.h"
#import "RootViewController.h"
#import "Database.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerConfirmPasswordTextfield;
@property (weak, nonatomic) MainNavigationController* navigationController;

@property (nonatomic, strong) FIRDatabaseReference * ref;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _registerNameTextField.delegate = self;
    _registerEmailTextField.delegate = self;
    _registerPasswordTextField.delegate = self;
    _registerConfirmPasswordTextfield.delegate = self;
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view.
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

- (IBAction)registerButtonPressed:(id)sender {
    
    NSString* getEmail = _registerEmailTextField.text;
    NSString* getPassword = _registerPasswordTextField.text;
    NSString* confirmPassword = _registerConfirmPasswordTextfield.text;
    NSString* getName = _registerNameTextField.text;
    
    
    if([getEmail length] == 0 || [getPassword length] == 0 || [getName length] == 0 || [confirmPassword length] == 0) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Invalid Registration"
                                              message:@"Please fill out all text fields to register"
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
    else if(![getPassword isEqualToString:confirmPassword]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Invalid Registration"
                                              message:@"Passwords do not match"
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
        [[FIRAuth auth]
         createUserWithEmail:getEmail
         password:getPassword
         completion:^(FIRUser *_Nullable user,
                      NSError *_Nullable error) {
             if(user != nil) {
            [[[_ref child:@"users"] child:user.uid] setValue:@{@"email": getEmail, @"name": getName, @"negative balance": @"0.00", @"positive balance": @"0.00"}];
                 
                 //[[[[_ref child:@"email"] child:user.uid] child:@"email"] setValue: getEmail];
                 
                 
                 
                 
                 //[[[_ref child:@"emails"] child:getEmail] setValue:user.uid];
                 
                // [[[_ref child:@"emails"] child:getEmail] setValue:user.uid];
                    //go to navigation controller
                 
                 RootViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                 [rvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                 [self presentViewController:rvc animated:YES completion:nil];
                 
                 //[self setContentViewController:_navigationController];
                 
                 //[[f childByAutoId] setValue:@{@"meh": @"lol", @"hum": @"kek"}}];
             } else {
                 UIAlertController *alertController = [UIAlertController
                                                       alertControllerWithTitle:@"Invalid Registration"
                                                       message:@"Account already created"
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

                 
                 //alert saying user already created
             }
         }];
    }
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
