//
//  AddBillViewController.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "AddBillViewController.h"
#import "Database.h"
#import "UIViewController+LMSideBarController.h"

@interface AddBillViewController ()
@property (strong, nonatomic)Database* db;
@property (weak, nonatomic) IBOutlet UITextField *friendEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *transactionAmountTextField;

@property (weak, nonatomic) IBOutlet UISwitch *billSwitch;
@property (weak, nonatomic) IBOutlet UITextField *transactionTitleTextField;
@property (strong, nonatomic) NSString* emailID;
@end

@implementation AddBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _db = [Database sharedModel];
    [self setDefaultValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    [self setDefaultValues];
}
- (void) setDefaultValues{
    _friendEmailTextField.text = @"";
    _transactionAmountTextField.text = @"";
    _transactionTitleTextField.text = @"";
    [_billSwitch setOn:NO animated:YES];
}

//Left Menu bar button action
- (IBAction)menuButtonPressed:(id)sender {
 [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

//Action for adding bill to user
- (IBAction)addBillButtonPressed:(id)sender {
    NSString* email = _friendEmailTextField.text;
    NSString* transactionAmount = _transactionAmountTextField.text;
    NSString* transactionTitle = _transactionTitleTextField.text;
    float transactionConvert = [transactionAmount floatValue];
    //invalid text fields
    if([email length] == 0 || [email length] == 0 || [transactionTitle length] == 0) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Bill Invalid"
                                              message:@"Please enter all fields to complete bill!"
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
    } else if(transactionConvert <= 0) {
        //Transaction must be >= 0
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Bill Invalid"
                                              message:@"Please enter a value higher than $0!"
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
        //want to add to database under transactions
        [_db findUserID: email onCompletition:^(NSString* findID) {
            _emailID = findID;
            NSLog(@"Transaction amount is: %@", transactionAmount);
            //counldnt find
            if([_emailID isEqualToString:@"nil"]) {
                NSLog(@"Email id is: %@" , _emailID);
                NSLog(@"USER DOESNT EXIST");
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Bill Invalid"
                                                      message:@"The email you inputted does not exist or is not your friend!"
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
                //you are requested
                NSLog(@"Email id is: %@", _emailID);
                if([_billSwitch isOn]) {
                    [_db addBill: _emailID withAmount: transactionAmount withTitle: transactionTitle isRequestor: false onCompletition:^(bool billComplete){
                        if(billComplete) {
                            //pop up saying bill completed
                            NSLog(@"BILL ADDED");
                            NSString* alertMessage = [NSString stringWithFormat:@"You are charged $%@ to %@", transactionAmount, email];
                            UIAlertController *alertController = [UIAlertController
                                                                  alertControllerWithTitle:@"Bill Added"
                                                                  message: alertMessage
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
                            NSLog(@"BILL DID NOT ADD");
                        }
                    }];
                } else {
                //you are being requested
                    [_db addBill: _emailID withAmount: transactionAmount withTitle: transactionTitle isRequestor: true onCompletition:^(bool billComplete) {
                        if(billComplete) {
                            //pop up saying bill completed
                            NSLog(@"BILL ADDED");
                            NSString* alertMessage = [NSString stringWithFormat:@"You have charged $%@ to %@", transactionAmount, email];
                            UIAlertController *alertController = [UIAlertController
                                                                  alertControllerWithTitle:@"Bill Added"
                                                                  message:alertMessage
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
                            NSLog(@"BILL DID NOT ADD");
                        }
                    }];
                }
                [self setDefaultValues];
                
            }
        }];
    }

}
@end
