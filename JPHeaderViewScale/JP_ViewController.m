//
//  JP_ViewController.m
//  JPHeaderViewScale
//
//  Created by tztddong on 2016/11/3.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JP_ViewController.h"
#import "UIView+JP_Frame.h"

static NSString *cellID = @"JP_TableViewCell";
static CGFloat kHeaderHeight = 200;

@interface JP_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JP_ViewController

{
    UIView              *_headerView;
    UIImageView         *_headerImageView;
    UIView              *_lineView;
    UIStatusBarStyle    _statusBarStyle;
    UITableView         *_tableView;
    UIButton            *_backBtn;
    UILabel             *_titleNameLab;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatTableView];
    [self creatHeaderView];
    
    _statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self.navigationController popViewControllerAnimated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return _statusBarStyle;
}

#pragma mark - creat headerview
- (void)creatHeaderView{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.jp_w, kHeaderHeight)];
    _headerView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.view addSubview:_headerView];
    
    _headerImageView = [[UIImageView alloc]initWithFrame:_headerView.bounds];
    _headerImageView.backgroundColor = [UIColor redColor];
    //http://www.fotor.com/images2/features/photo_effects/e_bw.jpg
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;//等比例填充
    _headerImageView.clipsToBounds = YES;
    [_headerView addSubview:_headerImageView];
    
    CGFloat lineH = 1 / [UIScreen mainScreen].scale;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeaderHeight - lineH, _headerView.jp_w, lineH)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_headerView insertSubview:_lineView belowSubview:_headerImageView];
    
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, kHeaderHeight - 10 - 20, 30, 20)];
    [_backBtn setImage:[UIImage imageNamed:@"nav_btn_back_tiny_normal"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"nav_btn_back_tiny_pressed"] forState:UIControlStateHighlighted];
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.hidden = YES;
    [_headerView insertSubview:_backBtn belowSubview:_headerImageView];
    
    _titleNameLab = [[UILabel alloc]init];
    _titleNameLab.text = @"英雄联盟";
    _titleNameLab.textColor = [UIColor purpleColor];
    _titleNameLab.font = [UIFont systemFontOfSize:18];
    [_titleNameLab sizeToFit];
    _titleNameLab.jp_centerX = _headerView.jp_w/2.0;
    _titleNameLab.jp_centerY = _backBtn.jp_centerY;
    _titleNameLab.hidden = YES;
    [_headerView insertSubview:_titleNameLab belowSubview:_headerImageView];
}

#pragma mark - backClick
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - creat UITableView
- (void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    //设置滚动范围
    _tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //手动设置了滚动范围 需要加上
    CGFloat offset = scrollView.contentOffset.y + _tableView.contentInset.top;
    //offset 正--向上滚动   负--向下滚动
    //headerView滚动的最小Y值
    CGFloat kHeaderMinY = kHeaderHeight-64;
    if (offset <= 0 ) {
        _headerView.jp_h = kHeaderHeight - offset;
        _headerImageView.alpha = 1.0;
        
    }else{
        //哪个值小 取当值的负数便是Y值
        _headerView.jp_y = -MIN(offset, kHeaderMinY);
        CGFloat progress = 1 - offset/kHeaderMinY;
        _headerImageView.alpha = progress;
        
        //返回按钮 标题 的显示与否
        _titleNameLab.hidden = _backBtn.hidden = progress > 0.01;
        //改变工具栏的颜色
        _statusBarStyle = progress < 0.5 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }
    
    _headerImageView.jp_h = _headerView.jp_h;
    _lineView.jp_y = _headerView.jp_h - _lineView.jp_h;
}

@end
