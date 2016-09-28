//
//  MFLoginViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFLoginViewController.h"
#import "MFRegistViewController.h"
#import "MFFindPwdViewController.h"
#import "LoginViewModel.h"

@interface MFLoginViewController ()

//控件
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, strong) UITextField *accountTextFiled;
@property (nonatomic, strong) UITextField *passwordTextFiled;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registBtn;
@property (nonatomic, strong) UIButton *findPwdBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

//ViewModel
@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation MFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self setUpAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setUpNav {
    
    self.title = @"登录";
    [self navBack:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeBtn];
}

- (void)setUpViews {
    
    WEAKSELF
    CGFloat padding = 50;
    CGFloat height = 30;
    
    [self.view addSubview:self.accountTextFiled];
    [self.accountTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.left.equalTo (padding);
        make.right.equalTo(-padding);
        make.top.equalTo(padding+12);
        make.height.equalTo(height);
    }];
    
    [self.view addSubview:self.passwordTextFiled];
    [self.passwordTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.left.equalTo (padding);
        make.right.equalTo(-padding);
        make.top.equalTo(weakSelf.accountTextFiled.mas_bottom).offset(height);
        make.height.equalTo(height);
    }];
    
    [self.accountTextFiled addSubview:self.line1];
    [self.line1 makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(UIEdgeInsetsMake(height-1, 0, 0, 0));
    }];
    [self.passwordTextFiled addSubview:self.line2];
    [self.line2 makeConstraints:^(MASConstraintMaker *make) {
       make.edges.offset(UIEdgeInsetsMake(height-1, 0, 0, 0));
    }];
    
    [self.view addSubview:self.findPwdBtn];
    [self.findPwdBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-padding);
        make.top.equalTo(weakSelf.passwordTextFiled.mas_bottom);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.accountTextFiled);
        make.height.equalTo(35);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.passwordTextFiled.mas_bottom).offset(65);
    }];
    
    [self.view addSubview:self.registBtn];
    [self.registBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.accountTextFiled);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(35);
        make.top.equalTo(weakSelf.loginBtn.mas_bottom).offset(40);
    }];
    
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.passwordTextFiled);
        make.top.equalTo(weakSelf.passwordTextFiled);
        make.height.equalTo(weakSelf.passwordTextFiled);
    }];
}

- (void)setUpAction {
    
    //登录按钮能否点击
    RAC(self.viewModel, account) = self.accountTextFiled.rac_textSignal;
    RAC(self.viewModel, pwd) = self.passwordTextFiled.rac_textSignal;
//
//    RAC(self.loginBtn, enabled) = self.viewModel.loginEnableSignal;
    
//    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"点击了登录按钮");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            BOOL canLogin = [self loginIfCanLogin];
//            if (canLogin) {
//                NSLog(@"login");
//                RACSignal *loginSignal = [self.viewModel.loginCommand execute:nil];
//                [loginSignal subscribeNext:^(id x) {
//                    NSString *token = x;
//                    if (token.length > 0) {
//                        NSLog(@"登录成功");
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }else {
//                        NSLog(@"登录失败");
//                    }
//                }];
//            }
//        });
//    }];
    
    //切换登录
    [[self.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"切换登录");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passwordTextFiled.text = nil;
            self.changeBtn.selected = !self.changeBtn.selected;
            self.viewModel.isPwdLogin = !self.viewModel.isPwdLogin;
            
            NSLog(@"%d", self.changeBtn.selected);
            if (self.changeBtn.selected) {
                self.getCodeBtn.hidden = NO;
                self.findPwdBtn.hidden = YES;
                
                self.passwordTextFiled.placeholder = @"请输入验证码";
                self.passwordTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code"]];
            }else {
                self.getCodeBtn.hidden = YES;
                self.findPwdBtn.hidden = NO;
                self.passwordTextFiled.placeholder = @"请输入密码";
                self.passwordTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
            }
        });
    }];
    
    //获取验证码
    [[self.getCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"获取验证码");
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    
    //忘记密码
    [[self.findPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MFFindPwdViewController *findPwdVC = [[MFFindPwdViewController alloc] init];
            [self.navigationController pushViewController:findPwdVC animated:YES];
        });
    }];
    
    //注册
    [[self.registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MFRegistViewController *registVC = [[MFRegistViewController alloc] init];
            [self.navigationController pushViewController:registVC animated:YES];
        });
    }];
}

- (BOOL)loginIfCanLogin {
    
    if (self.accountTextFiled.text.length == 11) {
//        NSString *tel = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$";
//         NSPredicate *telPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tel];
//        if (([telPredicate evaluateWithObject:self.accountTextFiled.text])) {
            if(self.passwordTextFiled.text.length > 0) {
                return YES;
            }else {
                NSLog(@"请输入密码");
                [PromtView showAlert:@"请输入密码" duration:1.5];
                return NO;
            }
//        }else {
//            NSLog(@"请输入正确的手机号码");
//            return NO;
//        }
    }else {
        NSLog(@"请输入11位手机号码");
        [PromtView showAlert:@"请输入11位手机号码" duration:1.5];
        return NO;
    }
    
    return YES;
}

- (void)loginAction:(UIButton *)sender {
    BOOL canLogin = [self loginIfCanLogin];
    if (canLogin) {
        NSLog(@"login");
       [self.viewModel loginActionWithAccount:self.accountTextFiled.text pwd:self.passwordTextFiled.text result:^(BOOL result) {
           if (result) {
               [self.navigationController popViewControllerAnimated:YES];
           }else {
               
           }
       }];
        
        
//        //RAC总是执行一次，费解，以后研究
//        NSArray *arr = @[self.accountTextFiled.text, self.passwordTextFiled.text];
//        
//        RACSignal *loginSignal = [self.viewModel.loginCommand execute:arr];
//        [loginSignal subscribeNext:^(id x) {
//            NSString *token = x;
//            if (token.length > 0) {
//                NSLog(@"登录成功");
//                [self.navigationController popViewControllerAnimated:YES];
//            }else {
//                NSLog(@"登录失败");
//            }
//        }];
    }

}

#pragma mark - lazyloading
-(UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"切换" forState:UIControlStateNormal];
        _changeBtn.frame = CGRectMake(0, 0, 40, 30);
        _changeBtn.titleLabel.font = H15;
    }
    return _changeBtn;
}

-(UITextField *)accountTextFiled {
    if (!_accountTextFiled) {
        _accountTextFiled = [[UITextField alloc] init];
//        _accountTextFiled.backgroundColor = yellow_color;
        _accountTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
        _accountTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _accountTextFiled.placeholder = @"请输入11位手机号";
//        _accountTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _accountTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _accountTextFiled;
}

-(UITextField *)passwordTextFiled {
    if (!_passwordTextFiled) {
        _passwordTextFiled = [[UITextField alloc] init];
//        _passwordTextFiled.backgroundColor = yellow_color;
        _passwordTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _passwordTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextFiled.placeholder = @"请输入密码";
        _passwordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passwordTextFiled;
}

-(UIButton *)findPwdBtn {
    if (!_findPwdBtn) {
        _findPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _findPwdBtn.titleLabel.font = H14;
        [_findPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_findPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    }
    return _findPwdBtn;
}

-(UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.font = H15;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor blueColor];
//        _loginBtn.layer.cornerRadius = 5;
//        _loginBtn.enabled = NO;
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registBtn.titleLabel.font = H15;
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setBackgroundColor:GRAYCOLOR];
    }
    return _registBtn;
}

-(UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.titleLabel.font = H15;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor = [UIColor grayColor];
        _getCodeBtn.hidden = YES;
    }
    return _getCodeBtn;
}

-(UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = GRAYCOLOR;
    }
    return _line1;
}

-(UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = GRAYCOLOR;
    }
    return _line2;
}

-(LoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}


@end
