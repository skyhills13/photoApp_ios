//
//  TableViewCell.h
//  photoApp
//
//  Created by soeunpark on 2014. 1. 7..
//  Copyright (c) 2014년 soeunpark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UITextView *cellContent;
@property (weak, nonatomic) IBOutlet UITextView *cellContentNum;
@end
