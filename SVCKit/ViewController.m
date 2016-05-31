//
//  ViewController.m
//  SVCKit
//
//  Created by 123 on 16/5/25.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "ViewController.h"
#import "SVCSegmetCollectionView.h"
#import "SVCViewController.h"
#import <AFNetworking.h>
#import "SVCModel.h"


#define url @"http://m.zfkx.com.cn/app/home/sanban"



static NSString *const indentifier = @"cell";

typedef void(^compelete)(NSMutableArray *datasource);


@interface ViewController () <SVCSegmetCollectionViewDelegate>

@property (nonatomic, strong) SVCSegmetCollectionView *segmentView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, copy) compelete block;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _datasource = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _segmentView = [[SVCSegmetCollectionView alloc]initWithSVCFrame:CGRectMake(0, 64, self.view.frame.size.width, 60) markCount:4 markTitles:@[@"你上",@"和大家说",@"阿萨德",@"我单位"]];
    _segmentView.segmetCollectionViewDelegate = self;
    [self.view addSubview:_segmentView];
    
    [self networking:0 isResfresh:NO];
}

- (void)networking:(NSInteger)index isResfresh:(BOOL)resfresh{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dataDict = [responseObject objectForKey:@"data"];
        NSArray *datas = [dataDict objectForKey:@"list"];
        
        for (NSDictionary *dict in datas) {
            SVCModel *model = [[SVCModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_datasource addObject:model];
        }
        if (resfresh) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.block(_datasource);
                return ;
            });
        }
       
        _segmentView.datasource = _datasource;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

#pragma mark -SVCSegmetCollectionViewDelegate
- (void)selectedOrEndScrolIndex:(NSInteger)index{
    [_datasource removeAllObjects];
    [self networking:index isResfresh:NO];
}

- (void)resfreshWithNewData:(BOOL)newData selectedIndex:(NSInteger)selectedIndex complete:(void(^)(NSMutableArray *datasource))complete failure:(void(^)(NSError *error))failure{
    NSLog(@"ssssss");
    if (newData) {
        //下拉
        [_datasource removeAllObjects];
        [self networking:selectedIndex isResfresh:YES];
    }else{
        [self networking:selectedIndex isResfresh:YES];
    }
    self.block = complete;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
