//
//  DKBaoDanViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/16.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaoDanViewController.h"
#import "BaoDanTableViewCell.h"
#import "DKBaoDetailViewController.h"
#import "InsuranceModel.h"

@interface DKBaoDanViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/* 网络请求数据源 */
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DKBaoDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"保单查询";
    [self navBack:YES];
    
    [self setupView];
    [self requestData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.scrollEnabled = NO;
        
        _tableView.rowHeight = 75;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 5;
        _tableView.sectionFooterHeight = 5;
    }
    return _tableView;
}


#pragma mark - setupView
- (void)setupView {
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaoDanTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoDanTableViewCell" owner:self options:nil] lastObject];
    
    cell.model = self.dataArray[indexPath.section];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //把保险种类push传递到下一页
    DKBaoDetailViewController *detailVC = [[DKBaoDetailViewController alloc] init];
    InsuranceModel *model = self.dataArray[indexPath.section];
    detailVC.titleStr = model.name;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - requestData
- (void)requestData {
    

    
    [DataService http_Post:kBaoXian parameters:nil success:^(id responseObject) {
        NSLog(@"保险公司success:%@", responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
            NSArray *insureArray = [responseObject objectForKey:@"datas"];
            if ([insureArray isKindOfClass:[NSArray class]] && insureArray.count > 0) {
                
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *jsonDic in insureArray) {
                    InsuranceModel *model = [[InsuranceModel alloc] initContentWithDic:jsonDic];
                    [mArr addObject:model];
                }
                self.dataArray = mArr;
                //刷新表视图
                [self.tableView reloadData];
            }
        }else {
            [PromtView showAlert:responseObject[@"msg"] duration:1.5];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"保险公司error:%@", error);
        [PromtView showAlert:PromptWord duration:1.5];
    }];
}

@end
