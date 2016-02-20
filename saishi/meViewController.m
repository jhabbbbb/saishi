//
//  meViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/16.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "meViewController.h"
#import "changePasswordViewController.h"
#import "loginViewController.h"
#import "mainTabBarController.h"
@interface meViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation meViewController

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
    
    self.navigationItem.title = @"我";
    
    //从mainTabBarController获取用户
    self.me = [(mainTabBarController *)self.navigationController.tabBarController me];

    
    [self updateUI];
    
}

- (void)updateUI
{
    
    imageGetter *imgGetter = [[imageGetter alloc] init];
    [imgGetter getImageWithID:self.me.portraitID complete:^(){
        [self.portrait setImageWithURL:[NSURL URLWithString:imgGetter.imageURL] placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
    }];
    
    //获取用户信息
    self.nameLabel.text = self.me.name;
    self.usernameLabel.text =[[NSString alloc]initWithFormat:@"账号：%@", self.me.username];
    self.jobLabel.text = [[NSString alloc]initWithFormat:@"单位职务：%@%@", self.me.danwei, self.me.zhiwu];
    self.phoneLabel.text = self.me.username;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1&&indexPath.row == 1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

//登出网络请求
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/log_out" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             //NSLog(@"success");
             NSDictionary *dict = (NSDictionary *)responseObject;
             //NSLog(@"%@", [dict objectForKey:@"msg"]);
             if ([[dict objectForKey:@"msg"] isEqualToString:@"登出成功"]){
                 
                 //删除用户登录状态
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 [userDefaults removeObjectForKey:@"loginInfo"];
                 [userDefaults synchronize];
                 
                 loginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
                 [self presentViewController:vc animated:YES completion:nil];
             }
             else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
                 [alert show];
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
        
        
    }
}


//segue to changePasswordViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"changePassword"]){
        if ([segue.destinationViewController isKindOfClass:[changePasswordViewController class]]){
            changePasswordViewController *changePasswordVC = (changePasswordViewController *)segue.destinationViewController;
            //NSLog(@"%@", self.me.username);
            changePasswordVC.me = self.me;
        }
    }
}



/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
