//
//  UserBalance.m
//  FirebaseTest
//
//  Created by Johnson Hui on 12/11/16.
//  Copyright © 2016 Johnson Hui. All rights reserved.
//

#import "UserBalance.h"

@implementation UserBalance

-(void) calculateNetBalance {
    float negFloat = [_negBalance floatValue];
    float posFloat = [_posBalance floatValue];
    float netFloat = posFloat - negFloat;
    _netBalance = [[NSString alloc] initWithFormat:@"%.02f",netFloat];
}
@end
