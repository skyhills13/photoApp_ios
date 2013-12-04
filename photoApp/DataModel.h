//
//  DataModel.h
//  photoApp
//
//  Created by soeunpark on 2013. 12. 4..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

-(void)saveId: (NSString*)userid
    withPassword:(NSString*)password
    withConfirmPassword:(NSString*)confirmPassword
    withEmailAddress:(NSString*)emailAddress;

-(BOOL)authenticateID:(NSString*)userid
         withPassword:(NSString*)password;

-(NSDictionary*)objectAtIndex:
(NSUInteger)index;

-(NSUInteger)getArrayCount;

@end
