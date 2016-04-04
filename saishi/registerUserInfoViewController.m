//
//  registerUserInfoViewController.m
//  saishi
//
//  Created by JinHongxu on 16/4/3.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import "registerUserInfoViewController.h"
#import "createAccountViewController.h"
@interface registerUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *danweiText;
@property (weak, nonatomic) IBOutlet UITextField *zhiwuText;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (strong, nonatomic) NSString *sex;

@end

@implementation registerUserInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sex = @"1";
    
    //点击空白键盘消失
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseMale:(id)sender {
    [self.maleButton setBackgroundImage:[UIImage imageNamed:@"check2"] forState:UIControlStateNormal];
    [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
    [self.avatar setImage:[UIImage imageNamed:@"male"]];
    self.sex = @"1";
}

- (IBAction)chooseFemale:(id)sender {
    [self.maleButton setBackgroundImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
    [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"check3"] forState:UIControlStateNormal];
    [self.avatar setImage:[UIImage imageNamed:@"female"]];
    self.sex = @"0";
}

//点击空白键盘消失
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"createAccount"]){
        if ([segue.destinationViewController isKindOfClass:[createAccountViewController class]]){
            createAccountViewController  *createVC = (createAccountViewController *)segue.destinationViewController;
            //NSLog(@"%@", self.me.username);
            createVC.name = self.nameText.text;
            createVC.sex = self.sex;
            createVC.danwei = self.danweiText.text;
            createVC.zhiwu = self.zhiwuText.text;
        }
    }
}


@end
