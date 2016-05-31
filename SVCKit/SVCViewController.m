//
//  SVCViewController.m
//  SVCKit
//
//  Created by 123 on 16/5/25.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "SVCViewController.h"
#import "SVCTableViewCell.h"
#import "SVCShowCollectionView.h"
#import "SVCShowCollectionViewCell.h"
#import "SVCBackGroundView.h"


#import "SVCModel.h"
#import "MJRefresh.h"

static NSString *const indentifier = @"SVCTableViewCell";

@interface SVCViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasourceArray;
//当前选中的标签
@property (nonatomic, assign) NSInteger selectedIndex;


@end

@implementation SVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self configureTableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(obserDatasource:) name:kNontifictaionDatasource object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(obserSelectedIndex:) name:kNontifictaionSelectedIndex object:nil];

    
    __weak typeof(self)weakSelf = self;
    
    //下拉
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.refreshDelegate && [weakSelf.refreshDelegate respondsToSelector:@selector(refreshDelegateWithNewDate:selectedIndex:complete:failure:)]) {
            [weakSelf.refreshDelegate refreshDelegateWithNewDate:YES selectedIndex:_selectedIndex complete:^(NSMutableArray *datasource) {
                if (datasource.count == 0) {
                    _tableView.scrollEnabled = NO;
                    UIView *backgroundView = [[NSBundle mainBundle]loadNibNamed:@"SVCBackGroundView" owner:nil options:nil].firstObject;
                    backgroundView.frame = weakSelf.view.bounds;
                    _tableView.tableFooterView = backgroundView;

                }
                _tableView.tableFooterView = [UIView new];

                _datasourceArray = datasource;
                NSLog(@"%ld",_datasourceArray.count);
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
            } failure:^(NSError *error) {
                [_tableView.mj_header endRefreshing];

            }];
        }
    }];
    
    //上啦
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.refreshDelegate && [weakSelf.refreshDelegate respondsToSelector:@selector(refreshDelegateWithNewDate:selectedIndex:complete:failure:)]) {
           [weakSelf.refreshDelegate refreshDelegateWithNewDate:NO selectedIndex:_selectedIndex complete:^(NSMutableArray *datasource) {
               if (datasource.count == 0) {
                   _tableView.scrollEnabled = NO;
                   UIView *backgroundView = [[NSBundle mainBundle]loadNibNamed:@"SVCBackGroundView" owner:nil options:nil].firstObject;
                   backgroundView.frame = weakSelf.view.bounds;
                   _tableView.tableFooterView = backgroundView;

               }
               _tableView.tableFooterView = [UIView new];

               [_datasourceArray addObjectsFromArray:datasource];

                [_tableView.mj_footer endRefreshing];
                
            } failure:^(NSError *error) {
                [_tableView.mj_footer endRefreshing];

            }];
           
            [_tableView reloadData];
        }
    }];
    
}

- (void)configureTableView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerNib:[UINib nibWithNibName:@"SVCTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    UIView *backgroundView = [[NSBundle mainBundle]loadNibNamed:@"SVCBackGroundView" owner:nil options:nil].firstObject;
    backgroundView.frame = self.view.bounds;
    _tableView.tableFooterView = backgroundView;
}

//数据源的监听
- (void)obserDatasource:(NSNotification *)notification{
    _datasourceArray = notification.object;
    if (_datasourceArray.count == 0) {
        _tableView.scrollEnabled = NO;
        UIView *backgroundView = [[NSBundle mainBundle]loadNibNamed:@"SVCBackGroundView" owner:nil options:nil].firstObject;
        backgroundView.frame = self.view.bounds;
        _tableView.tableFooterView = backgroundView;

    }
    _tableView.tableFooterView = [UIView new];

    [_tableView reloadData];
}

//选中标签监听
- (void)obserSelectedIndex:(NSNotification *)notification{
    _selectedIndex = (NSInteger)notification.object;
    //取消刷新
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}
  

#pragma mark -UITableView delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    if (_datasourceArray.count == 0 || indexPath.row >= _datasourceArray.count) {
        return [UITableViewCell new];
    }
    SVCModel *model = _datasourceArray[indexPath.row];
    cell.nameLabel.text = model.cate_name;
    cell.titleLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SVCViewController *view = [[SVCViewController alloc]init];
    view.view.backgroundColor = [UIColor orangeColor];
    [self.viewController.navigationController pushViewController:view animated:YES];
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
