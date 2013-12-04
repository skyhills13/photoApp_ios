//
//  ViewController.h
//  photoApp
//
//  Created by soeunpark on 2013. 11. 27..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)onLoginButtonClick:(id)sender;

@end
