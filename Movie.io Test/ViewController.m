//
//  ViewController.m
//  Movie.io Test
//
//  Created by James Lonely on 15/3/8.
//  Copyright (c) 2015年 James Lonely. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MovieData.h"
#import "MovieTableViewCell.h"
#import "UIImageView+WebCache.h"

static const NSUInteger kSearchBarHeight = 44;

@interface ViewController ()<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,ATMHudDelegate>

@property(nonatomic, retain) UISearchBar *searchBar;
@property(nonatomic, retain) UITableView *tableView;
@property(atomic, retain) NSArray *dataArray;
@property(nonatomic,retain) ATMHud *hud;     // Hud 提示

@end

@implementation ViewController

-(void)dealloc{
    self.searchBar.delegate=nil;
    self.searchBar=nil;
    self.tableView.delegate=nil;
    self.tableView=nil;
    self.dataArray=nil;
    self.hud.delegate=nil;
    self.hud=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dataArray = [NSArray new];
    
    self.searchBar = [[UISearchBar new] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSearchBarHeight)];
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, self.view.frame.size.width, self.view.frame.size.height-kSearchBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.tableView];

   
    /*--------------------------------------------------------------
     *  Hud 提示
     *-------------------------------------------------------------*/
	self.hud = [[ATMHud alloc] initWithDelegate:self];
	[self.view addSubview:self.hud.view];
    [self.hud setCaption:@"連線中,請稍候.."];
    [self.hud setActivity:YES];
    self.hud.center = self.view.center;
    [self.hud show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchBar.text = @"hobbit";
    [self searchData:self.searchBar.text];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
		cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    MovieData *movieItem = [self.dataArray objectAtIndex:indexPath.row];
    [cell.posterImageView setImageWithURL:[NSURL URLWithString:movieItem.poster]
                   placeholderImage:[UIImage imageNamed:@"sample.png"]];
    
    cell.starRateView.scorePercent = movieItem.rating/10;
    cell.titleLabel.text = movieItem.title;
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@",movieItem.year];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消選取狀態
}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarItem
{
    [searchBarItem resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBarItem {
    
    [self searchData:searchBarItem.text];
    
    [self.hud setCaption:@"連線中,請稍候.."];
    [self.hud setActivity:YES];
    self.hud.center = self.view.center;
    [self.hud show];
}


#pragma mark -  Data Search

- (void)searchData:(NSString*)parm {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.movies.io/movies/search?q=%@",parm] parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *responseList = [response objectForKey:@"movies"];
      
        if (responseList.count>0) {
            NSMutableArray *tmpDataAry = [NSMutableArray new];
            for (NSDictionary *movie in responseList) {
                MovieData *movieData = [MovieData new];
                movieData.title = [movie objectForKey:@"title"];
                movieData.year = [movie objectForKey:@"year"];
                movieData.rating = [[movie objectForKey:@"rating"] floatValue];
                movieData.poster = [[[movie objectForKey:@"poster"] objectForKey:@"urls"] objectForKey:@"original"];
                [tmpDataAry addObject: movieData];
            }
            [self.hud hideAfter:1.0];   // 關掉Hud
            self.dataArray=tmpDataAry;
            [self.tableView reloadData];
        }else{
            [self showErrorMessage:@"找不到符合的電影資訊"];
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showErrorMessage:@"找不到符合的電影資訊"];
    }];
    
}

// 顯示錯誤訊息
-(void)showErrorMessage:(NSString *)message{
    
    [self.hud setCaption:message];
    [self.hud setActivity:NO];
    [self.hud update];
    
    [self.hud hideAfter:2.0];   // 關掉Hud
}
@end
