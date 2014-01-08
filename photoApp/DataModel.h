//
//  DataModel.h
//  photoApp
//
//  Created by soeunpark on 2013. 12. 4..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject <NSURLConnectionDataDelegate>
+ (DataModel*)getInstance;
-(void)saveId: (NSString*)userid
    withPassword:(NSString*)password
    withConfirmPassword:(NSString*)confirmPassword
    withEmailAddress:(NSString*)emailAddress;

-(BOOL)authenticateID:(NSString*)userid
         withPassword:(NSString*)password;

-(NSDictionary*)objectAtIndex:(NSUInteger)index;
-(NSUInteger)getArrayCount;
- (void)getBoardDataFromServer;
- (BOOL)UploadNewPostTitle:(NSString*)title WithContent:(NSString*)content WithImage:(UIImage*)image;
//데이터가 모두 도착하면 테이블 (리스트)를 재로딩해주어야지 업데이트가되.
//업데이트를 하기 위해서 TableViewController에 대한 객체를 저장하기 위해서 이렇게 선언해놓은거야.
//여기에 저장하는건 맨처음에 로그인하고 리스트로 진입할때 그때 저장하도록 시켜놨어ㅎ
@property UITableViewController* tableController;
@end
