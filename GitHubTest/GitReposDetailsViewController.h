//
//  ReposDetailsViewController.h
//  GitHubTest
//
//  Created by Cap on 8/1/15.
//  Copyright (c) 2015 Cap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GitReposDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *repoInfo;

@end
