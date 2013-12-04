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
    NSMutableArray* _itemArray;//for test
}

-(id)init{
    self = [super init];
    if(self){
        _itemArray = [@[
                        @{@"text":@"first",
                          @"image":@"lego2.jpg",
                          @"comments":@"aaa"},
                        @{@"text":@"second",
                        @"image":@"lego3.jpg",
                          @"comments":@"aaa"},
                        @{@"text":@"third",
                          @"image":@"lego6.jpg",
                          @"comments":@"aaa"}]
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
    return _itemArray[index];
}

-(NSString*)description
{
    // NSString *result = [NSString stringWithFormat:@"array = %@, dic = %@", _itemArray, _itemDictionary];
    return _registerData.description;
}

-(BOOL)authenticateID:(NSString *)userid withPassword:(NSString *)password
{
    return true;
}

-(NSUInteger)getArrayCount
{
    
    return [_itemArray count];
}


@end
