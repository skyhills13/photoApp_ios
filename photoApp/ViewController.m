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
    
        //아이디, 패스워드등을 넣는 인풋항목에 애니메이션이나 제공받는 델리게이션 메소드등을 적용하기 위해서는 어떤 클래스에서의 입력에서 동작할지를 지정해줘야해. 그러니까 self로 지정해주는 거야
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
    
    //다음페이지로 가도되?? 로그인Toregister면 무조건 ㅇㅇ
    if ( [identifier isEqualToString:@"LoginToRegister"]) {
        return true;
        
    //아니면 로그인체크해. (버튼이 두개니까)
    } else {
        NSLog(@"call shouldPerform:");
        return [_dataModel authenticateID:self.idField.text
                             withPassword:self.passwordField.text];
    }
    
    return true;
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
