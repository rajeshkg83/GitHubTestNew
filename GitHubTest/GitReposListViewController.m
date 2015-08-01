//
//  ReposListViewController.m
//  GitHubTest
//
//  Created by Cap on 8/1/15.
//  Copyright (c) 2015 Cap. All rights reserved.
//

#import "GitReposListViewController.h"
#import "GitReposDetailsViewController.h"

@interface GitReposListViewController ()

@end

@implementation GitReposListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    self.title = @"Repositories";
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.reposList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.reposList objectAtIndex:indexPath.row];
    NSString *str = [dict objectForKey:@"full_name"];
    NSString *repoName = [[str componentsSeparatedByString:@"/"] lastObject];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    label.text = repoName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.reposList objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GitReposDetailsViewController *reposDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ReposDetailsViewController"];
    reposDetailsViewController.repoInfo = dict;
    [self.navigationController pushViewController:reposDetailsViewController animated:YES];

}

@end
