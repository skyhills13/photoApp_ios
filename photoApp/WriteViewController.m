//
//  WriteViewController.m
//  photoApp
//
//  Created by soeunpark on 2014. 1. 7..
//  Copyright (c) 2014년 soeunpark. All rights reserved.
//

#import "WriteViewController.h"
#import "DataModel.h"

@interface WriteViewController()

@end

@implementation WriteViewController
{
    DataModel* uploadModel;
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
    
    uploadModel = [DataModel getInstance];
    _uploadContent.delegate = self; //델리게이션이 적용되게끔하기 위해서.. 어떤 객체에 대해 델리게이션이 작동할거냐? 나!! 라고 선언
    _uploadImage.image = _internalImage;
}

- (void)prepareData:(UIImage *)image
{
    _internalImage = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadBtnClick:(id)sender {
    

    if ( _uploadTitle.text.length == 0 || _uploadContent.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Post Contents is Empty!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OKAY", nil];
        [alert show];
    } else {
        BOOL result = [uploadModel UploadNewPostTitle:_uploadTitle.text WithContent:_uploadContent.text WithImage:_uploadImage.image];
        
        if ( result ) {
            NSLog(@"in result true");
            [self.navigationController popViewControllerAnimated:TRUE];
        } else {
            NSLog(@"in result false");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Save Post Failure. try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OKAY", nil];
            [alert show];
        }
        
        //[loginModel authenticateID:self.inputID.text withPassword:self.inputPW.text]
    }
}

//표기법 바꾸기
- (BOOL)UploadNewPostTitle:(NSString*)title WithContent:(NSString*)content WithImage:(UIImage*)image
{
    NSURL* url = [NSURL URLWithString:@"http://localhost:8080/board/uploadFromIOS"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [request setHTTPMethod:@"POST"];
    NSString* stringBoundary = @"--*****";
    
    // header value
    NSString* headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
    
    // set header
    [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    //add body
    NSMutableData *postBody = [NSMutableData data];
    NSLog(@"body made");
    
    //title
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"title\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //content
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"contents\"\r\n\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //image
    NSDate *date = [NSDate date];
    //NSLog(@"Time: %lli", [@(floor([date timeIntervalSince1970])) longLongValue]);
    NSString* fileName = [NSString stringWithFormat:@"%lli.jpg",
                          [@(floor([date timeIntervalSince1970])) longLongValue]
                          ];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:
                           @"Content-Disposition: form-data; name=\"fileName\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    // add it to body
    [postBody appendData:imgData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"message added");
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add body to post
    [request setHTTPBody:postBody];
    
    
    
    NSLog(@"body set");
    
    
    //response
    NSError* error;
    NSHTTPURLResponse* response;
    NSData* aResultData = [NSURLConnection
                           sendSynchronousRequest:request returningResponse:&response
                           error:&error];
    
    NSDictionary *dataArray = [NSJSONSerialization
                               JSONObjectWithData:aResultData
                               options:NSJSONReadingMutableContainers error:nil];
    
    
    if (error) {
        //NSLog(@"EROROROROROROR: %@", error);
    }
    NSLog(@"just 3");
    
    
    NSLog(@"upload NewPost response = %d", response.statusCode);
    NSLog(@"upload NewPost result = %@", dataArray);
    NSLog(@"%@", [dataArray objectForKey:@"result"]);
    
    NSLog(@"done");
    if ( [[dataArray objectForKey:@"result"] isEqualToString:@"OK" ] ) {
        return YES;
    }
    
    return FALSE;
}


//다른곳 터치하면 editing멈추고 키보드 내려가게끔 처리
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches begin\n");
    [self.view endEditing:YES];
}

//UITextViewDelegate의 델리게이션 메소드.
//글쓸때 화면을 가리기 때문에 텍스트뷰에디팅을 시작할때 전체뷰를 에니메이션으로 올리고 내리고 하게끔 처리하기 위해서
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"view did begin edit\n");
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    
    [UIView beginAnimations:@"MyAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    
    CGRect newframe = self.view.frame;
    newframe.origin.y = 0;
    self.view.frame = newframe;
    [UIView commitAnimations];
    
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"view did begin edit\n");
    self.view.backgroundColor = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:0.1];
    
    [UIView beginAnimations:@"MyAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    
    CGRect newframe = self.view.frame;
    newframe.origin.y = -200;
    self.view.frame = newframe;
    [UIView commitAnimations];
    
    return YES;
}

@end
