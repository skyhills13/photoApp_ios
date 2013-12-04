//
//  ViewControllerRegister.m
//  photoApp
//
//  Created by soeunpark on 2013. 11. 27..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import "ViewControllerRegister.h"
#import "DataModel.h"

@interface ViewControllerRegister ()




@end

@implementation ViewControllerRegister
{
    DataModel *_dataModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _dataModel = [[DataModel alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)didTap:(UITapGestureRecognizer*)rec
{
    [self.idField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordConfirmField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onSignupButtonClick:(id)sender {
    [_dataModel saveId:self.idField.text
     withPassword:self.passwordField.text
     withConfirmPassword:self.passwordConfirmField.text
     withEmailAddress:self.emailField.text];
    NSLog(@"%@", [_dataModel description]);
}
@end
