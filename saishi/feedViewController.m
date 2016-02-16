//
//  feedViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/12.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "feedViewController.h"

@interface feedViewController (){
    int yeshu;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) BOOL loadedData;//是否加载数据
@end

@implementation feedViewController

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
    
    
    //修复刷新坐标起点问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets=NO;
        UIEdgeInsets insets= self.table.contentInset;
        insets.top= self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.table.contentInset = insets;
        self.table.scrollIndicatorInsets = insets;
    }
    
    //添加下拉刷新、分页加载控件
    __weak feedViewController *weakSelf = self;
    [self.table addPullToRefreshWithActionHandler:^{
        [weakSelf refreshTable];
    }];
    
    [self.table addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadTable];
    }];
    
    self.navigationItem.title = @"动态";
    
    self.loadedData = NO;
    
    //获取动态列表
    yeshu = 2;
    [self.list getDataWithType:@"Dongtai" yeshu:yeshu complete:^(){
        //NSLog(@"%@", self.list.feedList);
        self.loadedData = YES;
        [self.table reloadData];
    }];

}

- (void)refreshTable
{
    //延时
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    //刷新
    yeshu = 1;
    self.loadedData = NO;
    [self.list.feedList removeAllObjects];
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.list getDataWithType:@"Dongtai" yeshu:yeshu complete:^(){
            self.loadedData = YES;
            [self.table reloadData];
            [self.table.pullToRefreshView stopAnimating];
        }];
    });
    
}

- (void)loadTable{
    
    //延时
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    //加载
    yeshu++;
    //NSLog(@"yeshu:%d", yeshu);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.list getDataWithType:@"Dongtai" yeshu:yeshu complete:^(){
            self.loadedData = YES;
            [self.table reloadData];
            [self.table.infiniteScrollingView stopAnimating];
        }];
    });
    
}//分页加载


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//tableView
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
#warning need fix by createTime 用日期初始化时间
    if (section == 0){
        return 1;
    }
    else {
        return [self.list.feedList count]-1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    customCell *cell;
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"topCell" forIndexPath:indexPath];//置顶cell
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];//普通cell
    }
    
    // Configure the cell...
    if (self.loadedData){
        cell.titleLabel.text = [self.list.feedList[indexPath.row] objectForKey:@"title"];
        cell.subtitleLabel.text = [self.list.feedList[indexPath.row] objectForKey:@"content"];
        
        //处理图片
        imageGetter *imgGetter = [[imageGetter alloc] init];
        [imgGetter getImageWithID:[self.list.feedList[indexPath.row] objectForKey:@"icon"] complete:^(){
            [cell.image setImageWithURL:[NSURL URLWithString:imgGetter.imageURL] placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
        }];
        
        
        //处理时间
        cell.timeLabel.text = @"00:00";
        cell.time = [self.list.feedList[indexPath.row] objectForKey:@"createtime"];
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
        return 150.0;
    }
    else {
        return 120.0;
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

//segue to detailViewController
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(customCell *)sender
 {
    if ([segue.identifier isEqualToString:@"detail"]){
        if ([segue.destinationViewController isKindOfClass:[detailViewController class]]){
            detailViewController *detailVC = (detailViewController *)segue.destinationViewController;
            detailVC.time = sender.time;
            detailVC.text = sender.subtitleLabel.text;
        }
    }
}

@end
