//
//  MFPayActivityOrderViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFPayActivityOrderViewController.h"
#import "PayOrderCell.h"
#import "UIViewController+WeChatAndAliPayMethod.h"
#import "WXApi.h"
#import "ActivityOrderHeaderView.h"

static NSString *const identifier = @"OrderDetailCellID";
@interface MFPayActivityOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
    NSArray *imgNameArr;
    NSInteger payWay;
    ActivityOrderHeaderView *headerView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *payMoneyBtn;


@end

@implementation MFPayActivityOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUpNav];
    [self setUpViews];
    [self combineViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"活动支付";
}

- (void)setUpViews {
    [self.view addSubview:self.payMoneyBtn];
    [self.payMoneyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(50);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
}


#pragma mark - lazyloading
-(UIButton *)payMoneyBtn {
    if (!_payMoneyBtn) {
        _payMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payMoneyBtn createButtonWithBGImgName:@"pay"
                               bghighlightImgName:@"pay_h"
                                         titleStr:@"立即支付活动诚意金"
                                         fontSize:16];
        [_payMoneyBtn addTarget:self action:@selector(payMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payMoneyBtn;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}


#pragma mark - action
- (void)combineViewModel {
    
}

- (void)payMoneyAction:(UIButton *)button {
    
}

#pragma mark - MVVM
- (void)setData {
    
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel createLabelWithFontSize:14 color:TEXTCOLOR];
        cell.textLabel.text = @"支付方式";
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44*kHeightSale-1, kScreenWidth - 30, 1)];
        lineView.backgroundColor = kplayceGrayColor;
        [cell.contentView addSubview:lineView];
        
        return cell;
    }else if (indexPath.row == 3) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noneCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else {
        PayOrderCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayOrderCell" owner:nil options:nil] lastObject];
        
        cell.icon_View.image = [UIImage imageNamed:imgNameArr[indexPath.row - 1]];
        cell.payLabel.text = titleArr[indexPath.row - 1];
        
        if (indexPath.row == 2) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 69, kScreenWidth - 30, 1)];
            lineView.backgroundColor = kplayceGrayColor;
            [cell.contentView addSubview:lineView];
        }
        
        return cell;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50;
    }else if(indexPath.row == 3) {
#define NONE_H (kScreenHeight - 64 - 50*2 - 12 - 70*2 - headerView.height)
        return NONE_H;
    }else {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        payWay = 1;
        
        //拿到button，设置背景
        PayOrderCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = [selectedCell viewWithTag:110];
        [btn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        
        //设置另外一个没有对号
        PayOrderCell *otherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UIButton *otherBtn = [otherCell viewWithTag:110];
        [otherBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }else if (indexPath.row == 2) {
        payWay = 2;
        
        //拿到button，设置背景
        PayOrderCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = [selectedCell viewWithTag:110];
        [btn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        
        //设置另外一个没有对号
        PayOrderCell *otherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UIButton *otherBtn = [otherCell viewWithTag:110];
        [otherBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}

#pragma mark - Alipay methods
/*支付宝支付*/
- (void)payMoneyWithAlipay {
    //暂时不能用支付宝支付
    [PromtView showAlert:@"抱歉，暂时不能用支付宝支付" duration:1];
    
    
    //这里调用我自己写的catagoary中的方法，方法里集成了支付宝支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
    //    [self payTHeMoneyUseAliPayWithOrderId:self.activityID
    //                               totalMoney:@"0.01"
    //                                 payTitle:@"activity title"];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPayResultNoti:) name:ALI_PAY_RESULT object:nil];
    
}

//支付宝支付成功失败
-(void)AliPayResultNoti:(NSNotification *)noti {
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:ALIPAY_SUCCESSED]) {
        [PromtView showAlert:@"支付成功" duration:1];
        //在这里填写支付成功之后你要做的事情
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [PromtView showAlert:@"支付宝支付失败" duration:1];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALI_PAY_RESULT object:nil];
}

#pragma mark - WechatPay methods
- (void)payWithWechatPay {
    //判断用户是否安装微信
    if ([WXApi isWXAppInstalled]) {
        //安装
        NSLog(@"正在微信支付");
        
        //获取prepay_id和随机字符串
        [self getData];
        
        //所以这里添加一个监听，用来接收是否成功的消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];
        
    }else {
        //没安装
        [PromtView showAlert:@"您没有安装微信" duration:1];
    }
    
}

//微信支付付款成功失败
-(void)weChatPayResultNoti:(NSNotification *)noti {
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:IS_SUCCESSED]) {
        [PromtView showAlert:@"微信支付成功" duration:3];
        //在这里填写支付成功之后你要做的事情
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [PromtView showAlert:@"微信支付失败" duration:3];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
}

- (void)getData {
    /*
     返回JSON对象：
     {
     appid：		APPID
     partnerid：	商户ID
     noncestr：  随机数
     timestamp： unix时间戳
     package:	值固定为"Sign=WXPay"
     prepayid：	预支付编号prepay_id
     sign:		签名
     }
     */
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[self.array firstObject],@"oid",
                            @"2",@"orderType", nil];
    
    [DataService http_Post:GET_DATA
     
                parameters:params
     
                   success:^(id responseObject) {
                       //
                       NSLog(@"success:%@, msg:%@", responseObject, [responseObject objectForKey:@"msg"]);
                       
                       [self payTheMoneyUseWeChatPayWithPrepay_id:[responseObject objectForKey:@"prepayid"]
                        
                                                        partnerID:[responseObject objectForKey:@"partnerid"]
                        
                                                        nonce_str:[responseObject objectForKey:@"noncestr"]
                        
                                                        timeStamp:[responseObject objectForKey:@"timestamp"]
                        
                                                          package:[responseObject objectForKey:@"package"]
                        
                                                             sign:[responseObject objectForKey:@"sign"]];
                       
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"error:%@", error);
                       //请求网络失败
                       [PromtView showAlert:@"微信支付失败" duration:2];
                       
                   }];
}



@end
