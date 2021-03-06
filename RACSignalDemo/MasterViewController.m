//
//  MasterViewController.m
//  RACSignalDemo
//
//  Created by Xiao ChenYu on 12/26/14.
//  Copyright (c) 2014 sumi-sumi. All rights reserved.
//

#import "MasterViewController.h"


@interface MasterViewController ()
<UISearchControllerDelegate, UISearchResultsUpdating>

@property NSMutableArray *objects;

@property (nonatomic, strong) UISearchController *searchController;
@property(nonatomic, copy) NSArray *searchTexts;
@property(nonatomic, copy) NSArray *searchResults;
@property(nonatomic, assign, getter = isSearching) BOOL searching;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.searchTexts = @[
                         @"San Francisco",
                         @"Grand Rapids",
                         @"Chicago",
                         @"San Jose"
                         ];
    self.searchResults = @[];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.searchBar.text.length > 0) {
        self.searchResults = [self search:searchController.searchBar.text];
    } else {
        self.searchResults = self.searchTexts;
    }

    [self.tableView reloadData];
}


- (NSArray *)search:(NSString *)searchText {
    NSMutableArray *results = [NSMutableArray array];
    for (NSString *text in self.searchTexts) {
        if([[text lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
            [results addObject:text];
        }
    }
    return results;
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.searching = YES;
}

- (void)didPresentSearchController:(UISearchController *)searchController
{

}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    self.searching = NO;
    [self.tableView reloadData];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isSearching) {
        return self.searchResults.count;
    } else {
        return self.searchTexts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.isSearching ? self.searchResults[indexPath.row] : self.searchTexts[indexPath.row];
    return cell;
}


@end
