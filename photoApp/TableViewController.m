//
//  TableViewController.m
//  photoApp
//
//  Created by soeunpark on 2013. 12. 4..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import "TableViewController.h"
#import "DataModel.h" //1

@interface TableViewController ()

@end

@implementation TableViewController
{
    DataModel * _dataModel; //2
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
	// Do any additional setup after loading the view.
    _dataModel = [[DataModel alloc] init]; //3
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataModel getArrayCount];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = [_dataModel objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:
                             UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
//    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(3,2, 50, 50)];
//    imv.image=[UIImage imageNamed:@"lego6.jpg"];
//    [cell.contentView addSubview:imv];
    
    cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"image"]];
    cell.textLabel.text = [item objectForKey:@"text"];
    cell.detailTextLabel.text = [item objectForKey:@"image"];
    return cell;
}

//not working
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"comments" sender:indexPath];
}



@end
