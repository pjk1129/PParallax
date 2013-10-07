//
//  HomeViewController.m
//  PParallax
//
//  Created by JK.Peng on 13-10-6.
//  Copyright (c) 2013年 njut. All rights reserved.
//

#import "HomeViewController.h"
#import "SRRefreshView.h"

static CGFloat kContentOriginPosition = 307.0;

#define kScrollViewOriginY   CGRectGetHeight(self.topImageView.frame)-11

@interface HomeViewController ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIView       *containerView;   //视图容器
@property (nonatomic, strong) UIScrollView       *containerScrollView;   //容器
@property (nonatomic, strong) UIImageView  *topImageView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UITabBar     *tabBar;

@property (nonatomic, strong) UIView         *inviteView;
@property (nonatomic, strong) UITableView    *rewardTableView;
@property (nonatomic, strong) UITableView    *gainTableView;

@property (nonatomic, assign) NSInteger         selectedIndex;

@property (nonatomic, strong) SRRefreshView   *refreshView;

@property (nonatomic, assign) BOOL        topImageViewShowed;

@property (nonatomic, assign) CGFloat     lastOffsetY;


@end

@implementation HomeViewController
@synthesize containerView = _containerView;
@synthesize containerScrollView = _containerScrollView;
@synthesize topImageView = _topImageView;
@synthesize topScrollView = _topScrollView;
@synthesize tabBar = _tabBar;

@synthesize inviteView = _inviteView;
@synthesize rewardTableView = _rewardTableView;
@synthesize gainTableView = _gainTableView;

@synthesize selectedIndex = _selectedIndex;

@synthesize refreshView = _refreshView;

@synthesize topImageViewShowed = _topImageViewShowed;

@synthesize lastOffsetY = _lastOffsetY;

- (void)dealloc{
    [_refreshView removeFromSuperview];
    self.refreshView = nil;
    self.containerView = nil;
    self.topImageView = nil;
    self.topImageView = nil;
    self.tabBar = nil;
    self.inviteView = nil;
    self.containerScrollView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255.0f green:234.0/255.0f blue:234.0/255.0f alpha:1.0];
    [self.containerView addSubview:self.containerScrollView];
    [self.containerView addSubview:self.topImageView];

    [self.containerScrollView addSubview:self.rewardTableView];
    [self.containerScrollView addSubview:self.gainTableView];
    
    [self.containerScrollView addSubview:self.topScrollView];
    [self.containerScrollView addSubview:self.tabBar];
    
    [self.containerScrollView addSubview:self.inviteView];
    
    self.containerScrollView.contentSize = CGSizeMake(320, self.containerScrollView.bounds.size.height+CGRectGetMinY(self.tabBar.frame));
    
    
    [self.containerScrollView addSubview:self.refreshView];
    
    __block  HomeViewController  *this = self;
    [self.refreshView setBlock:^(SRRefreshView* sender){
        [this performSelector:@selector(endRefresh) withObject:nil afterDelay:2.0f];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)endRefresh
{
    [self.refreshView endRefresh];
    [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _gainTableView) {

        
    }else if (scrollView == _rewardTableView){

    }
    
    [_refreshView scrollViewDidScroll];
    
    NSInteger y= self.containerScrollView.contentOffset.y;
    
    if (_topImageViewShowed) {
        if (y>90) {
            _topImageViewShowed=NO;
            [UIView animateWithDuration:0.3f animations:^{
                [self.topImageView setFrame:CGRectMake(0, -70, 320, self.topImageView.bounds.size.height)];
            }];
        }
    }
    else
    {
        if (y<=90) {
            _topImageViewShowed=YES;
            [UIView animateWithDuration:0.3f animations:^{
                [self.topImageView setFrame:CGRectMake(0, 0, 320, self.topImageView.bounds.size.height)];
            }];
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _gainTableView || scrollView == _rewardTableView) {
        CGFloat  newOffY = scrollView.contentOffset.y;
        if (newOffY-_lastOffsetY>0 && self.containerScrollView.contentOffset.y<100) {
            [self.containerScrollView setContentOffset:CGPointMake(0, CGRectGetMinY(self.tabBar.frame)) animated:YES];
        }
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView scrollViewDidEndDraging];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _lastOffsetY = self.containerScrollView.contentOffset.y;
    
    if (self.containerScrollView.contentOffset.y<0) {
        [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

#pragma mark - Table View Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier   = @"RBParallaxTableViewCell";
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        cell.selectionStyle              = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}


#pragma mark -  UITabbarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 2) {
        item.badgeValue=nil;
    }
    if (item.tag == 3) {
        item.badgeValue=nil;
    }
    
    self.selectedIndex = item.tag;
    
}

#pragma mark - setter
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    switch (_selectedIndex) {
        case 1:{
            self.inviteView.hidden = NO;
            self.gainTableView.hidden = YES;
            self.rewardTableView.hidden = YES;
            break;
        }
        case 2:{
            self.inviteView.hidden = YES;
            self.gainTableView.hidden = YES;
            self.rewardTableView.hidden = NO;
            break;
        }
        case 3:{
            self.inviteView.hidden = YES;
            self.gainTableView.hidden = NO;
            self.rewardTableView.hidden = YES;
            break;
        }
        default:{
            self.inviteView.hidden = NO;
            self.gainTableView.hidden = YES;
            self.rewardTableView.hidden = YES;
            break;
        }
    }
    
}


#pragma mark - getter
- (SRRefreshView *)refreshView{
    if (!_refreshView) {
        _refreshView = [[SRRefreshView alloc] init];
        _refreshView.upInset = 40;
        _refreshView.slimeMissWhenGoingBack = YES;
        _refreshView.slime.bodyColor = [UIColor blackColor];
        _refreshView.slime.skinColor = [UIColor whiteColor];
        _refreshView.slime.lineWith = 1;
        _refreshView.slime.shadowBlur = 4;
        _refreshView.slime.shadowColor = [UIColor blackColor];
    }
    return _refreshView;
}

- (UITabBar *)tabBar{
    if (!_tabBar) {
        _tabBar=[[UITabBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.topScrollView.frame), 320, 50)];
        
        UITabBarItem *inviteItem=[[UITabBarItem alloc] initWithTitle:@"Tab1"
                                                               image:[UIImage imageNamed:@"invited.png"]
                                                                 tag:1];
        UITabBarItem *promoteItem=[[UITabBarItem alloc]initWithTitle:@"Tab2"
                                                               image:[UIImage imageNamed:@"market_mission.png"]
                                                                 tag:2];
        promoteItem.badgeValue=@"N";
        UITabBarItem *profitItem=[[UITabBarItem alloc]initWithTitle:@"Tab3"
                                                              image:[UIImage imageNamed:@"myprofits.png"]                                                                tag:3];
        _tabBar.items=[NSArray arrayWithObjects:inviteItem,promoteItem,profitItem, nil];
        
        _tabBar.selectedImageTintColor=[UIColor whiteColor];
        _tabBar.selectionIndicatorImage=[UIImage imageNamed:@"recommend_tab_select"];
        _tabBar.backgroundImage=[UIImage imageNamed:@"tab_background"];
        [_tabBar setSelectedItem:inviteItem];
    
        if  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            _tabBar.tintColor=[UIColor whiteColor];
        }
        
        _tabBar.delegate=self;
    }
    
    return _tabBar;
}

- (UIView *)containerView{
    if (!_containerView) {
        CGFloat  h = [UIScreen mainScreen].bounds.size.height-20;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-h, CGRectGetWidth(self.view.frame), h)];
        _containerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}

- (UIScrollView *)containerScrollView{
    if (!_containerScrollView) {
        _containerScrollView = [[UIScrollView alloc] initWithFrame:self.containerView.bounds];
        _containerScrollView.backgroundColor = [UIColor clearColor];
        _containerScrollView.delegate=self;
        _containerScrollView.showsVerticalScrollIndicator = NO;
    }
    return _containerScrollView;
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.backgroundColor = [UIColor orangeColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(floorf((320-200)/2), floorf((42-20)/2), 200, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.text = @"Demo";
        [_topImageView addSubview:titleLabel];
        
    }
    return _topImageView;
}

- (UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScrollViewOriginY, 320, kContentOriginPosition-kScrollViewOriginY)];
        _topScrollView.backgroundColor = [UIColor blueColor];
        
        UIImageView  *imgView = [[UIImageView alloc] initWithFrame:_topScrollView.bounds];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.image = [UIImage imageNamed:@"Demo1.jpg"];
        [_topScrollView addSubview:imgView];
    }
    
    return _topScrollView;
}

- (UIView *)inviteView{
    if (!_inviteView) {
        _inviteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), 320, CGRectGetHeight(self.containerView.frame)-CGRectGetHeight(self.tabBar.frame))];
        _inviteView.backgroundColor = [UIColor greenColor];
    }
    
    return _inviteView;
}

- (UITableView *)gainTableView{
    if (!_gainTableView) {
        _gainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), 320, self.containerView.bounds.size.height-CGRectGetHeight(self.tabBar.frame)) style:UITableViewStylePlain];
        _gainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gainTableView.delegate = self;
        _gainTableView.dataSource = self;
        _gainTableView.backgroundColor = [UIColor clearColor];
        _gainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _gainTableView.hidden = YES;
        _gainTableView.bounces = NO;
    }
    return _gainTableView;
}

- (UITableView *)rewardTableView{
    if (!_rewardTableView) {
        _rewardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), 320, self.containerView.bounds.size.height-CGRectGetHeight(self.tabBar.frame)) style:UITableViewStylePlain];
        _rewardTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rewardTableView.delegate = self;
        _rewardTableView.dataSource = self;
        _rewardTableView.backgroundColor = [UIColor clearColor];
        _rewardTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _rewardTableView.hidden = YES;
        _rewardTableView.bounces = NO;
    }
    return _rewardTableView;
}

@end
