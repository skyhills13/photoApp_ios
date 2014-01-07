//
//  WriteViewController.h
//  photoApp
//
//  Created by soeunpark on 2014. 1. 7..
//  Copyright (c) 2014년 soeunpark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteViewController : UIViewController<UITextViewDelegate>
{
    //내부적으로 전달받는 이미지(편집되고 난 이미지)를 저장하는 변수.
    UIImage* _internalImage;
}
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (weak, nonatomic) IBOutlet UITextField *uploadTitle;
@property (weak, nonatomic) IBOutlet UITextView *uploadContent;

- (IBAction)uploadBtnClick:(id)sender;
- (void)prepareData:(UIImage *)image;
@end