//
//  TableViewController.m
//  photoApp
//
//  Created by soeunpark on 2013. 12. 4..
//  Copyright (c) 2013년 soeunpark. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "TableViewController.h"
#import "DataModel.h" //1
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WriteViewController.h"
#import "CommentsViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController
{
    DataModel * _dataModel; //2
    NSInteger index;
    
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
    _dataModel = [DataModel getInstance]; //3
    _dataModel.tableController = self; //reload를 위해서 커넥션이 끝날경우 모델에서 호출해줘야하니까 객체 저장
    
    //오른쪽 상단에 카메라 버튼만들기
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(newImage:)];
    //selector안에 있는 newImage는 함수명이야. 콜백함수인거지. 만약에 버튼을 눌르면 실행되는거야
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void) viewWillAppear:(BOOL)animated
{
    [_dataModel getBoardDataFromServer];
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
    
    
    
//다이나믹 이전에. 정적으로 코딩해서 버튼만들고 했던부분. 하지만 뷰를 디테일하게 정하지는 못해! 그래서 밑에 코드로 쓰는거야!!
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:
//                             UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
//    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(3,2, 50, 50)];
//    imv.image=[UIImage imageNamed:@"lego6.jpg"];
//    [cell.contentView addSubview:imv];
//    cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"image"]];
//    cell.textLabel.text = [item objectForKey:@"text"];
//    cell.detailTextLabel.text = [item objectForKey:@"image"];

    
    //다이나믹 셀을 만들기 위한 참조. tableViewCell클래스를 참조해서 거기에 있는 애들을 쓰는거야!!
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
//    NSLog(@"%@", item);
    cell.cellTitle.text = [item objectForKey:@"title"];
    cell.cellContent.text = [item objectForKey:@"contents"];
//    NSLog(@"comments :!!");
//    NSLog(@"%@", [item objectForKey:@"comments"]);
    
    NSString* imgUrl = [item objectForKey:@"fileName"];
    
    //만약에 item object안에 파일명에 대한 정보가 있을경우에만 실행되도록
    if ( [imgUrl class] != [NSNull class] )
    {
        //#import "UIImageView+WebCache.h" api로 웹에 있는 이미지 불러오는거야. 지금 db에는 이미지파일명만 있으니까 밑에처럼명시적으로 /images로 경로 잡아준거
        NSString* loadURL = @"http://localhost:8080/images/";
        loadURL = [loadURL stringByAppendingString:imgUrl];
        
        [cell.cellImage setImageWithURL:[NSURL URLWithString:loadURL]];
        NSLog(@"imgURL = %@", imgUrl);
        NSLog(@"loadURL = %@", loadURL);
    } else {
        [cell.cellImage setImageWithURL:[NSURL URLWithString:@"http://localhost:8080/images/default-no-image.png"]];
    }
    
    //cell.cellImage.image = [UIImage imageNamed:[item objectForKey:@"image"]];
    //NSString*
    
    return cell;
}


//클릭됐을때
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    index = indexPath.row;
    [self performSegueWithIdentifier:@"Comments" sender:indexPath];
}



//오른쪽 상단의 카메라 버튼을 클릭했을때 호출되는 콜백함수
- (void)newImage:(id)sender
{
    UIImagePickerController *picker
    = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    picker.delegate = self;
    [self.navigationController
     presentViewController:picker animated:YES completion:^{}];
}

//UIImagePickerControllerDelegate os에서 제공해주는 이미지 델리게이션에 대한 메소드 부분이야
//이걸로 이미지를 골르고 하는것들을 처리할 수 있어
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    
    //kUTTypeImage 는 MobileCoreServices/MobileCoreServices.h를 임포트해야지 참조할 수 있어. 디파인되어있는 변수인거 같아
    //아마 시스템에 있는 이미지데이터 타입인거 같아
    if ([mediaType isEqualToString:(__bridge id)kUTTypeImage])
    {
        UIImage* aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //#import "CLImageEditor.h"외부 라이브러리(개인이 만든) 에서 제공해주는 editor에 대한 소스코드 부분이야
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:aImage];
        editor.delegate = self;
        [picker pushViewController:editor animated:YES];
        //editor 소스추가 부분 끝
    }
    //이미지 골랐을때 자동으로 뷰 닫기. 여기도 {} 안에 액션을 구현하면 뷰가 닫힌후 {}안에 영역이 실행된다.
    //    [picker dismissViewControllerAnimated:YES completion:^{
    //        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"이미지" message:@"골랐어요" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    //        alertView1.alertViewStyle = UIAlertViewStyleDefault;
    //        [alertView1 show];
    //    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}]; //^{}는 콜백함수. ananimous함수로 뷰가 끝난뒤 실행할 부분을 구현한다.
}
///여기까지가 imagePicker부분이야

//#import "CLImageEditor.h"외부 라이브러리(개인이 만든) 에서 제공해주는 델리게이션 메소드야
//오른쪽 상단의 done버튼을 클릭하면 콜백해줄 컨트롤러를 지정해주고 있어
//하단 메서드의     [writeVC prepareData:image]부분은 이중에서도 어떤 함수를 호출한건지를 의미해. prepareData함수를 호출하는거지
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    WriteViewController* writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"writeView"];
    [writeVC prepareData:image];
    [editor dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController pushViewController:writeVC animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CommentsViewController* targetController = segue.destinationViewController;
    targetController.index = index;
    
    NSLog(@"index : %d", index);
}

@end
