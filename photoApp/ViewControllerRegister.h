//
//  ViewControllerRegister.h
//  photoApp
//
//  Created by soeunpark on 2013. 11. 27..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerRegister : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *idField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)onSignupButtonClick:(id)sender;

@end
