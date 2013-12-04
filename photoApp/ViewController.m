//
//  ViewController.m
//  photoApp
//
//  Created by soeunpark on 2013. 11. 27..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import "ViewController.h"
#import "DataModel.h"

@interface ViewController ()

@end

@implementation ViewController
{
    DataModel *_dataModel;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_dataModel = [[DataModel alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)didTap:(UITapGestureRecognizer*)rec
{
    [self.idField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButtonClick:(id)sender {
    
    [_dataModel authenticateID:self.idField.text
                   withPassword:self.passwordField.text];
    
//    BOOL idCheck = [_dataModel authenticateID:self.idField.text
//                  withPassword:self.passwordField.text];
//    if (idCheck == YES)
//    {
//        
//    }
}
@end
