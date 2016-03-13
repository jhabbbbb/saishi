//
//  affairsViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/12.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "affairsViewController.h"

@interface affairsViewController (){
    int yeshu;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) BOOL loadedData;//数据是否加载
@end

@implementation affairsViewController

//惰性初始化
- (dataList *)list
{
    if (!_list) _list = [[dataList alloc] init];
    return _list;
}

- (user *)me
{
    if (!_me) _me = [[user alloc] init];
    return _me;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //修复刷新坐标起点问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets=NO;
        UIEdgeInsets insets= self.table.contentInset;
        insets.top= self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.table.contentInset = insets;
        self.table.scrollIndicatorInsets = insets;
    }
    
    //修复navigationBar高度问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    //从mainTabBarController获取用户
    self.me = [(mainTabBarController *)self.navigationController.tabBarController me];
    
    //添加下拉刷新、分页加载控件
    __weak affairsViewController *weakSelf = self;
    [self.table addPullToRefreshWithActionHandler:^{
        [weakSelf refreshTable];
    }];
    
    [self.table addInfiniteScrollingWithActionHandler:^{
        //调整菊花的位置
        CGRect frame = weakSelf.table.infiniteScrollingView.frame;
        frame.origin.y -= 49.0;
        weakSelf.table.infiniteScrollingView.frame = frame;
        [weakSelf loadTable];
    }];
    
    self.navigationItem.title = @"会务";
    self.loadedData = NO;
    
    //获取会务列表
    yeshu = 1;
    [self.list getDataWithType:@"Huiwu" yeshu:yeshu complete:^(){
        //NSLog(@"%@", self.list.affairsList);
        self.loadedData = YES;
        [self.table reloadData];
    }relogin:nil fail:nil];
    
    //修改SVPullToRefresh的文字
    [self.table.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.table.pullToRefreshView setTitle:@"放开刷新" forState:SVPullToRefreshStateTriggered];
    [self.table.pullToRefreshView setTitle:@"加载中..." forState:SVPullToRefreshStateLoading];
   
    
}

- (void)refreshTable{
    
    __weak affairsViewController *weakSelf = self;
    
    //延时
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    //刷新
    yeshu = 1;
    weakSelf.loadedData = NO;
    [weakSelf.list.affairsList removeAllObjects];
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.list getDataWithType:@"Huiwu" yeshu:yeshu complete:^(){
            weakSelf.loadedData = YES;
            [weakSelf.table reloadData];
            [weakSelf.table.pullToRefreshView stopAnimating];
        }relogin:nil fail:^(){
            [weakSelf.table.infiniteScrollingView stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"失败了，重试一下吧～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }];
    });
    
    
    
}//下拉刷新

- (void)loadTable{
    
    __weak affairsViewController *weakSelf = self;
    //延时
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    //加载
    yeshu++;
    //NSLog(@"yeshu:%d", yeshu);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.list getDataWithType:@"Huiwu" yeshu:yeshu complete:^(){
            weakSelf.loadedData = YES;
            [weakSelf.table reloadData];
            [weakSelf.table.infiniteScrollingView stopAnimating];
        }relogin:nil fail:^(){
            
            [weakSelf.table.infiniteScrollingView stopAnimating];
            
            //修复刷新失败菊花位置上移的问题
            CGRect frame = self.table.infiniteScrollingView.frame;
            frame.origin.y += 49.0;
            weakSelf.table.infiniteScrollingView.frame = frame;
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"没有了～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }];
    });
    
}//分页加载

//修复navigationBar高度问题
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation ==UIInterfaceOrientationLandscapeLeft){ // home键靠左右
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
            UIEdgeInsets insets = self.tableView.contentInset;
            
            insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
            insets.top -= 25;
            self.tableView.contentInset = insets;
            self.tableView.scrollIndicatorInsets = insets;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.loadedData){
        return 2;
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return 1;
    }
    else {
        return [self.list.affairsList count]-1;
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
        
        NSInteger index = indexPath.row;
        if (indexPath.section >= 1){
            index++;
        }
        
        cell.contentText = [self.list.affairsList[index] objectForKey:@"content"];
        cell.ID = [self.list.affairsList[index] objectForKey:@"id"];
        cell.titleLabel.text = [self.list.affairsList[index] objectForKey:@"title"];
        cell.readCountLabel.text = [NSString stringWithFormat:@"阅读量:%@", [self.list.affairsList[index] objectForKey:@"fwl"]];
        //cell.subtitleLabel.text = [self.list.affairsList[index] objectForKey:@"subtitle"];
        
        //NSLog(@"%f", cell.titleLabel.frame.size.height);
        
        //处理图片
        imageGetter *imgGetter = [[imageGetter alloc] init];
        [imgGetter getImageWithID:[self.list.affairsList[index] objectForKey:@"icon"] complete:^(){
            [cell.image setImageWithURL:[NSURL URLWithString:imgGetter.imageURL] placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
        }];
        
        
        //处理时间
        cell.timeLabel.text = @"00:00";
        cell.timeLabel.text = @"00:00";
        if (indexPath.section == 0){
            cell.timeLabel.text = @"00-00 00:00";
        }
        cell.time = [self.list.affairsList[index] objectForKey:@"createtime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:cell.time];
        if (date){
            //NSLog(@"%@", date);
            [dateFormatter setDateFormat:@"HH:mm"];
            if (indexPath.section == 0){
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            } 
            NSString *time = [dateFormatter stringFromDate:date];
            cell.timeLabel.text = time;
        }
    }
    
    return cell;
}

//点击置顶cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0&&indexPath.row == 0){
        customCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self addReadCountWithID:cell.ID];
        detailViewController *detailVC= [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailVC.time = cell.time;
        detailVC.text = cell.contentText;
        detailVC.title = cell.titleLabel.text;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

//增加阅读数
- (void)addReadCountWithID:(NSString *)ID {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameter = @{@"id": ID};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/fangwen" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"success");
     }failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}


/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 200.0;//置顶cell
    }
    else {
        return 120.0;//普通cell
    }
}*/

//第二区域的hearderView
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView;
    if (section == 1){
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -5, 100, 15)];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        
        label.text = @"0000-00-00";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:[[self.list.affairsList objectAtIndex:1] objectForKey:@"createtime"]];
        if (date){
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *time = [dateFormatter stringFromDate:date];
            label.text = time;
        }
        
        [headerView addSubview:label];
    }
    
    return headerView;
}*/

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
            [self addReadCountWithID:sender.ID];
            detailViewController *detailVC = (detailViewController *)segue.destinationViewController;
            detailVC.time = sender.time;
            detailVC.text = sender.contentText;
            detailVC.title = sender.titleLabel.text;
        }
    }
    
    if ([segue.identifier isEqualToString:@"me"]){
        if ([segue.destinationViewController isKindOfClass:[meViewController class]]){
            meViewController *meVC = (meViewController *)segue.destinationViewController;
            meVC.me = self.me;
        }
    }
}


@end
