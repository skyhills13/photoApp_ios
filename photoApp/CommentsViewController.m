//
//  CommentsViewController.m
//  photoApp
//
//  Created by soeunpark on 2013. 12. 4..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import "CommentsViewController.h"
#import "DataModel.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController
{
    DataModel* _dataModel;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataModel = [[DataModel alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%d", section);
    return 3;//코멘트 갯수만큼을 리턴해야 한다. 지금은 이전에 몇번글이 눌렸는지 알 수 없어서 하드코딩함
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"comment"];
    cell.textLabel.text = @"test";//위와 동일한 이유로 하드코딩함
    
    return cell;
}

@end