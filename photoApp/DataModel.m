//
//  DataModel.m
//  photoApp
//
//  Created by soeunpark on 2013. 12. 4..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import "DataModel.h"
#define kID_KEY @"id"
#define kPASSWORD_KEY @"pwd"
#define kCONFIRMPASSWORD_KEY @"pwdc"

@implementation DataModel
{
    NSMutableDictionary *_registerData;
    NSMutableArray* _itemArray;//for test 테스트용이야. 이제는 안써
    
    NSArray* _listArray;
    //서버에서 데이터를요청하고 받아서 처리하기 위한 변수들이야.
    NSMutableData* _responseData;  // 그냥 데이터타입중 하나야. 데이터가 서버로부터 도착하면 저장할 그릇!
    NSURLConnection* connection; //커넥션 객체. 연결에 대한 부분을 담당
}

//singleton으로 쓰기 위해서
static DataModel* sharedInstance;

+ (DataModel*)getInstance
{
    if ( sharedInstance == nil )
        sharedInstance = [[super alloc] init];
    return sharedInstance;
}


-(id)init{
    self = [super init];
    if(self){
        _itemArray = [@[
                        @{@"text":@"first",
                          @"image":@"lego2.jpg",
                          @"comments":@"aaba"},
                        @{@"text":@"second",
                        @"image":@"lego3.jpg",
                          @"comments":@"aasa"},
                        @{@"text":@"third",
                          @"image":@"lego6.jpg",
                          @"comments":@"aaca"}]
                      mutableCopy];
        _registerData = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

-(void)saveId: (NSString*)userid
 withPassword:(NSString*)password
 withConfirmPassword:(NSString*)confirmPassword
withEmailAddress:(NSString*)emailAddress
{
    [_registerData setObject:userid forKey:kID_KEY];
    [_registerData setObject:password forKey:kPASSWORD_KEY];
    [_registerData setObject:confirmPassword forKey:kCONFIRMPASSWORD_KEY];
    [_registerData setObject:emailAddress forKey:@"email"];
}

-(NSDictionary*)objectAtIndex:(NSUInteger)index{
    //return _itemArray[index]; test용. init해서 하드코딩하는 부분
    return _listArray[index];
}

-(NSString*)description
{
    // NSString *result = [NSString stringWithFormat:@"array = %@, dic = %@", _itemArray, _itemDictionary];
    return _registerData.description;
}

-(BOOL)authenticateID:(NSString *)userid withPassword:(NSString *)password
{
    NSLog(@"userid : %@", userid);
    NSLog(@"password : %@", password);
    
    
    //send
    NSString* urlString = @"http://localhost:8080/login_check.json";
    NSError* aError;
    NSDictionary* requestData = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 userid, @"ID", password, @"PW", nil];
    NSData* postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&aError];
    
    
    NSURL *aURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest* aRequest = [NSMutableURLRequest requestWithURL:aURL];
    [aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [aRequest setHTTPMethod:@"POST"];
    [aRequest setHTTPBody:postData];
    //send
    
    
    //response
    NSHTTPURLResponse* aResponse;
    NSData* aResultData = [NSURLConnection
                           sendSynchronousRequest:aRequest returningResponse:&aResponse
                           error:&aError];
    
    NSDictionary *dataArray = [NSJSONSerialization
                               JSONObjectWithData:aResultData
                               options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"login response = %d", aResponse.statusCode);
    NSLog(@"login result = %@", dataArray);
    NSLog(@"%@", [dataArray objectForKey:@"result"]);
    
    return [[dataArray objectForKey:@"result"] isEqualToString:@"OK" ];
}

-(NSUInteger)getArrayCount
{
    //return [_itemArray count]; test용. init해서 하드코딩하는 부분
    return [_listArray count];
}

//커넥션 델리게이션을 통해서 나머지는 다 처리할거기 때문에 요청, 연결하는 부분만 여기서 구현해놓으면 되.
//헤더에 NSURLConnectionDataDelegate 선언을 통해서 델리게이션 모델부분에서 쓰는것으로 선언
- (void)getBoardDataFromServer
{
    _responseData = [[NSMutableData alloc] initWithCapacity:10];
    NSString *aURLString = @"http://localhost:8080/board/list.json";//@"http://1.234.2.8/board.php";
    NSURL* aURL = [NSURL URLWithString:aURLString];
    NSMutableURLRequest* aRequest = [NSMutableURLRequest requestWithURL:aURL];
    //[aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    connection = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES];
}

//NSURLConnectionDataDelegate 선언으로 제공되는 함수들
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    //데이터가 서버로부터 도착하면 위에 선언해놓은 responseData에 새로운 데이터를 더한다.
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* aError;
    
    NSString *result = [NSString stringWithUTF8String:_responseData.bytes];
    NSLog(@"result data = %@", result);
    NSDictionary* resultDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&aError];
    
    NSLog(@"result json = %@", resultDictionary);
    
    NSArray* resultArray = [resultDictionary objectForKey:@"boardAllData"];
    NSLog(@"result json = %@", resultArray);
    _listArray = resultArray;
    
    //리스트를 업데이트하기위해서 새로고침하는거야ㅎ
    [_tableController.tableView reloadData];
    
    NSLog(@"Error : %@",aError);
}
////NSURLConnectionDataDelegate 선언으로 제공되는 함수들 끝

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
                           @"Content-Disposition: form-data; name=\"file\"; fileName=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
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

@end
