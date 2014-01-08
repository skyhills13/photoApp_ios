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
    NSArray* _contents;
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
    
    [self.navigationController setNavigationBarHidden:false];
    _dataModel = [DataModel getInstance];
    NSLog(@"dataModel : %@", _dataModel);
    NSLog(@"%@",[_dataModel objectAtIndex:_index]);
    _contents = [[_dataModel objectAtIndex:_index] objectForKey:@"comments"];
    NSLog(@"contents : %@", _contents);
    NSLog(@"objectAtIndex : %@", [_dataModel objectAtIndex:_index]);
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
//이전 버전.
// Return the number of rows in the section.
//NSLog(@"%d", section);
//return 3;//코멘트 갯수만큼을 리턴해야 한다. 지금은 이전에 몇번글이 눌렸는지 알 수 없어서 하드코딩함
   
    //갯수만큼 리턴
   return [_contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//이전 버전.
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"comment"];
//    cell.textLabel.text = @"test";//위와 동일한 이유로 하드코딩함
//    
//    return cell;
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary* comment = _contents[indexPath.row];
    
    cell.textLabel.text = [comment objectForKey:@"contents"];
    
    return cell;
}

@end