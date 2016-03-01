//
//  filesViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/12.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "filesViewController.h"

@interface filesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSString *filePathToOpen;


@property (nonatomic) BOOL loadedData;//数据是否加载
@end

@implementation filesViewController

//惰性初始化
- (dataList *)list
{
    if (!_list) _list = [[dataList alloc] init];
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"文件";
    self.loadedData = NO;
    
    //获取文件列表
    [self.list getFileList:^(){
        //NSLog(@"%@", self.list.fileList);
        self.loadedData = YES;
        [self.table reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning need fix by createTime
    if (self.loadedData){
        return 2;
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning need fix by createTime 用创建日期分区
    if (section == 0){
        return 1;
    }
    else {
        return [self.list.fileList count]-1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    fileCell *cell;
    
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"topFileCell" forIndexPath:indexPath];//置顶cell
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"normalFileCell" forIndexPath:indexPath];//普通cell
    }
    
    // Configure the cell...
    if (self.loadedData){
        
        NSInteger index = indexPath.row;
        if (indexPath.section >= 1){
            index++;
        }
        
        cell.fileTypeLabel.text = @"文件";
        if ([self.list.fileList[index] objectForKey:@"type"] != [NSNull null]){
            cell.fileTypeLabel.text = [self.list.fileList[index] objectForKey:@"type"];
        }
        cell.fileNameLabel.text = [self.list.fileList[index] objectForKey:@"title"];
        cell.fileID = [self.list.fileList[index] objectForKey:@"file"];
        
        
        //获得归档文件路径
        NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"file.archiver"];
        //NSLog(@"%@", path);
        
        //解归档
        NSMutableDictionary *downloadedFiles = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSString *fileName = [downloadedFiles objectForKey:[cell.fileID stringByAppendingString:@"fileName"]];
        cell.fileName = fileName;
        
        //NSLog(@"%@", fileName);
        if (fileName){//如果有过记录，看它还在不在Documents里面
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //指向文件目录
            NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            
            //NSLog(@"%@", filePath);
            if(![fileManager fileExistsAtPath:filePath]){ //如果不存在
                
                
                [cell.downloadButton setBackgroundImage:[UIImage imageNamed:@"11"]  forState:UIControlStateNormal];
                [cell.downloadButton setEnabled:YES];
                
                //表示文件没有下载
                cell.fileIsDownloaded = NO;
                [cell getFileURL];
                
            }
            else { //如果存在
                
                //设置按钮状态
                [cell.downloadButton setBackgroundImage:[UIImage imageNamed:@"10"]  forState:UIControlStateNormal];
                [cell.downloadButton setEnabled:NO];
                
                //为预览文件准备filePath
                cell.filePath = [NSString stringWithFormat:@"file://%@", filePath];
                
                
                //表示文件已下载
                cell.fileIsDownloaded = YES;
            }
        }

        else {//如果没有记录
            [cell.downloadButton setBackgroundImage:[UIImage imageNamed:@"11"]  forState:UIControlStateNormal];
            [cell.downloadButton setEnabled:YES];
            cell.fileIsDownloaded = NO;
            [cell getFileURL];
        }
        
        [cell getFileURL];
        
        //处理时间
        cell.timeLabel.text = @"00:00";
        cell.time = [self.list.fileList[index] objectForKey:@"createtime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:cell.time];
        if (date){
            //NSLog(@"%@", date);
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *time = [dateFormatter stringFromDate:date];
            cell.timeLabel.text = time;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 150.0;//置顶cell
    }
    else {
        return 120.0;//普通cell
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    fileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.filePathToOpen = cell.filePath;
    //NSLog(@"%@", self.filePathToOpen);
    if ([[NSFileManager defaultManager] fileExistsAtPath:cell.filePath]){
        NSLog(@"aa");
    }
    if (!cell.fileIsDownloaded){//如果没有下载
        [cell download];
    }
    else {
        
        //quickLook
        QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
        myQlPreViewController.delegate = self;
        myQlPreViewController.dataSource = self;
        [myQlPreViewController setCurrentPreviewItemIndex:0];
        
        //[self.navigationController showViewController:myQlPreViewController sender:nil];
        [self showViewController:myQlPreViewController sender:nil];
    }
    
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


//quickLookDatasource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    //普通url前记得加file://
    return [NSURL URLWithString:self.filePathToOpen];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
