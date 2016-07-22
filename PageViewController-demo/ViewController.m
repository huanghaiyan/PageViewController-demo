//
//  ViewController.m
//  PageViewController-demo
//
//  Created by 黄海燕 on 16/7/21.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#define kHEIGHT [[UIScreen mainScreen]bounds].size.height
#define kWIDTH [[UIScreen mainScreen]bounds].size.width

// 分类背景颜色
#define BGCOLOR [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
// 分类灰色字体颜色
#define GRAYCOLOR [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0]
// 红色色值
#define REDCOLOR [UIColor colorWithRed:255/255.0 green:94.0/255.0 blue:91.0/255.0 alpha:1.0]
#define GLOGBALCOLOR [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:247.0/255.0 alpha:1]
@interface ViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *titleBGView;
    UIScrollView *colorview;
    UIScrollView *mainScrollView;
    NSUInteger kCount;
    
}
@property(nonatomic,assign)BOOL exchange;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"新闻";
    
    titleBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWIDTH, 40)];
    titleBGView.backgroundColor = BGCOLOR;
    [self.view addSubview:titleBGView];
    
    NSArray *titles = @[@"电影",@"电视剧",@"娱乐",@"综艺"];
    kCount = titles.count;
    for (int i = 0; i < kCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((kWIDTH/kCount)*i, 0, kWIDTH/titles.count, 40);
        btn.tag = i+1;
        [btn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        [btn setTitleColor:REDCOLOR forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBGView addSubview:btn];
        
        if (btn.tag == 1) {
            btn.selected = YES;
        }
    }
    
    colorview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+40, kWIDTH, 3)];
    colorview.pagingEnabled=YES;
    colorview.bounces=NO;
    colorview.backgroundColor = BGCOLOR;
    colorview.showsHorizontalScrollIndicator=NO;
    colorview.contentSize=CGSizeMake(kWIDTH*kCount,3);
    [self.view addSubview:colorview];

    for (int i = 0; i<kCount; i++) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake((kWIDTH+kWIDTH/titles.count)*i,0,kWIDTH/kCount,2.5)];
        view.backgroundColor=[UIColor colorWithRed:1.00f green:0.36f blue:0.34f alpha:1.00f];
        [colorview addSubview:view];
    }
    
    //主滑动的Scrollview
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+43, kWIDTH, kHEIGHT - 107)];
    mainScrollView.backgroundColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled=YES;
    mainScrollView.bounces=NO;
    mainScrollView.delaysContentTouches = NO;
    //mainScrollView.scrollEnabled = NO;
    mainScrollView.showsHorizontalScrollIndicator=NO;
    mainScrollView.contentSize=CGSizeMake(kWIDTH*kCount,kHEIGHT - 107);
    [self.view addSubview:mainScrollView];
    
    if (_exchange) {
        CGRect rect = mainScrollView.frame;
        rect.origin.x = mainScrollView.frame.size.width;
        rect.origin.y = 0;
        [mainScrollView scrollRectToVisible:rect animated:YES];
        [colorview setContentOffset:CGPointMake(kWIDTH,0)];
    }

    [self creatTableView];
}

- (void)creatTableView
{
    for (int i = 0; i<kCount; i++) {
       UITableView *mTableView = [[UITableView alloc]initWithFrame:CGRectMake(kWIDTH*i,0,kWIDTH,kHEIGHT - 107)style:UITableViewStylePlain];
        mTableView.tag = 100+i;
        mTableView.delegate = self;
        mTableView.dataSource = self;
        mTableView.backgroundColor = GLOGBALCOLOR;
        //mTableView.separatorStyle = UITableViewCellAccessoryNone;
        [mainScrollView addSubview:mTableView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.tag == 101) {
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 100) {
        return 10;
    }else{
        
        return 20;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"hahha";
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        int a;
        a=scrollView.contentOffset.x / kWIDTH;
        NSLog(@"%d",a);
        [colorview setContentOffset:CGPointMake(a*kWIDTH, 0)];
        NSArray *array=[[NSArray alloc]init];
        array=titleBGView.subviews;
        for (UIButton *btn in array) {
            btn.selected=NO;
            
        }
        for (UIButton *btn in array) {
            if (btn.tag==a+1) {
                btn.selected=YES;
                
            }else {
             
            }
        }
        
    }
    
}

- (void)btnClick:(UIButton *)btn
{
    NSArray *array=[[NSArray alloc]init];
    array=titleBGView.subviews;
    for (UIButton *btn in array) {
        btn.selected=NO;
    }
    
    if (btn.tag == 1) {
        
        btn.selected=YES;
        CGRect rect=mainScrollView.frame;
        rect.origin.x=0;
        rect.origin.y=0;
        [mainScrollView scrollRectToVisible:rect animated:YES];
        [colorview setContentOffset:CGPointMake(0,0)];
    }else{
        btn.selected=YES;
        [self.view endEditing:YES];
        CGRect rect = mainScrollView.frame;
        rect.origin.x = mainScrollView.frame.size.width;
        rect.origin.y = 0;
        [mainScrollView scrollRectToVisible:rect animated:YES];
        [colorview setContentOffset:CGPointMake(kWIDTH*(btn.tag -1),0)];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
