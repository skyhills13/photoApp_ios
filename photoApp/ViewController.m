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
	_dataModel = [DataModel getInstance];
    
    _idField.delegate = self;
    _passwordField.delegate = self;
    
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
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    return [_dataModel authenticateID:self.idField.text
                       withPassword:self.passwordField.text];
}

//IBAction do nothing related to change view
- (IBAction)onLoginButtonClick:(id)sender {
    //NSLog(@"%@", [_dataModel description]);
    
    
    
//    BOOL idCheck = [_dataModel authenticateID:self.idField.text
//                  withPassword:self.passwordField.text];
//    if (idCheck == YES)
//    {
//        
//    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MyAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    
    CGRect newframe = self.view.frame;
    
    if ( textField == _idField)
    {
        newframe.origin.y = -120;
    }
    else if ( textField == _passwordField )
    {
        newframe.origin.y = -150;
    }
    self.view.frame = newframe;
    
    //self.view.alpha
    //self.view.backgroundColor = [UIColor whiteColor];
    [UIView commitAnimations];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MyAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    CGRect newframe = self.view.frame;
    newframe.origin.y = 0;
    self.view.frame = newframe;
    
    [UIView commitAnimations];
    
    return YES;
}

@end
