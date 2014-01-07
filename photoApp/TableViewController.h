//
//  TableViewController.h
//  photoApp
//
//  Created by soeunpark on 2013. 12. 4..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, CLImageEditorDelegate>
@end