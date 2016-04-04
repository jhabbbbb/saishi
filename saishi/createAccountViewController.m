//
//  createAccountViewController.m
//  saishi
//
//  Created by JinHongxu on 16/4/3.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import "createAccountViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface createAccountViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdText;
@property (weak, nonatomic) IBOutlet UITextField *verifyText;
@property (weak, nonatomic) IBOutlet UIImageView *verify;
@property (weak, nonatomic) IBOutlet UIImageView *avater;
@property (weak, nonatomic) IBOutlet UILabel *warning;
@property (strong, nonnull) UIAlertView *successAlert;

@end

@implementation createAccountViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"%@ %@ %@ %@", self.name, self.sex, self.danwei, self.zhiwu);
    
    // Do any additional setup after loading the view.
    
    if ([self.sex isEqualToString:@"1"]){
        [self.avater setImage:[UIImage imageNamed:@"male"]];
        
    }
    else {
        [self.avater setImage:[UIImage imageNamed:@"female"]];
    }
    
    //点击空白键盘消失
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:Tap];
    
    
    //点击更换验证码
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
    singleTap.numberOfTapsRequired = 1;
    [self.verify setUserInteractionEnabled:YES];
    [self.verify addGestureRecognizer:singleTap];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    /*NSURLRequest *request =  [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://121.42.157.180/qgfdyjnds/index.php/Api/getverify"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
     [self.image setImageWithURLRequest:request placeholderImage:nil success:nil failure:nil];*/
    
    NSString *imageUrl = @"http://121.42.157.180/qgfdyjnds/index.php/Api/getverify";
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.verify.image = [UIImage imageWithData:data];
    }];
}

-(void)onClickImage{
    
    //NSLog(@"clicked");
    [self updateUI];
    
}

- (IBAction)confirm:(id)sender {
    
    //键盘消失
    [self.view endEditing:YES];
    
    NSString *coo;
    //获取Cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://121.42.157.180/qgfdyjnds/index.php/Api/getverify"]];
    for (NSHTTPCookie *cookie in cookies)
    {
        //NSLog(@"%@", cookie.value);
        coo = cookie.value;
        //[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //这两句太坑了
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@", coo] forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //NSLog(@"%@",self.verifyText.text);
    NSDictionary *parameter = @{@"verify":self.verifyText.text, @"phone": self.phoneText.text, @"username": self.name, @"sex":self.sex, @"age":@"", @"pwd":self.pwdText.text, @"danwei":self.danwei, @"zhiwu":self.zhiwu};
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/register" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary *dict = (NSDictionary *)responseObject;
         //NSLog(@"%@", dict);
         if ([[dict objectForKey:@"msg"] isEqualToString:@"注册成功"]){
             self.successAlert = [[UIAlertView alloc]initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [self.successAlert show];
         }
         else {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alert show];
         }
         
     }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.successAlert){
        UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigation"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.confirmPwdText){
        if (![self.confirmPwdText.text isEqualToString:self.pwdText.text]){
            [self.warning setAlpha:1.0];
        }
        else [self.warning setAlpha:0.0];
    }
}

//界面上升
- (void)keyboardWillShow:(NSNotification *)notif {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -85.0;
        self.view.frame = frame;
    }];
}

//界面下降
- (void)keyboardWillHide:(NSNotification *)notif {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}


//点击空白键盘消失
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
