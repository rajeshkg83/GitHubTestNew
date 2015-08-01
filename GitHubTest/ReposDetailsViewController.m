//
//  ReposDetailsViewController.m
//  GitHubTest
//
//  Created by Cap on 8/1/15.
//  Copyright (c) 2015 Cap. All rights reserved.
//

#import "ReposDetailsViewController.h"

@interface ReposDetailsViewController ()

@property (nonatomic, strong) NSArray *details;
@property (weak, nonatomic) IBOutlet UISegmentedControl *detailsSegment;
@property (weak, nonatomic) IBOutlet UITableView *detailsTable;
- (IBAction)didSelectSegment:(id)sender;

@end

typedef enum
{
    kContentsType = 0,
    kCommentsType = 1
    
} DetailsType;


@implementation ReposDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Details";
    [self didSelectSegment:self.detailsSegment];
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
    
    return self.details.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.detailsSegment.selectedSegmentIndex == kContentsType)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentsCell" forIndexPath:indexPath];
        NSDictionary *dict = [self.details objectAtIndex:indexPath.row];
        NSString *type = [dict objectForKey:@"type"];
        NSString *name = [dict objectForKey:@"name"];
        
        UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:10];
        NSMutableAttributedString * typeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Type: %@",type]];
        [typeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
        typeLabel.attributedText = typeString;
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:20];
        NSMutableAttributedString * nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Name: %@",name]];
        [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
        nameLabel.attributedText = nameString;

        return cell;
    }
    if (self.detailsSegment.selectedSegmentIndex == kCommentsType)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell" forIndexPath:indexPath];
        NSDictionary *dict = [self.details objectAtIndex:indexPath.row];
        NSString *comment = [dict objectForKey:@"body"];
        
        UILabel *commentLabel = (UILabel *)[cell.contentView viewWithTag:10];
        NSMutableAttributedString * commentString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Comment %d: \n%@",indexPath.row+1, comment]];
        NSRange range = [[commentString string] rangeOfString:@":"];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,range.location+1)];
        commentLabel.attributedText = commentString;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (self.detailsSegment.selectedSegmentIndex)
    {
        case kContentsType:
            return 66;
            break;
        case kCommentsType:
            return 88;
            break;
        default:
            break;
    }
    return 0;
}

#pragma mark - Custom Methods


- (IBAction)didSelectSegment:(id)sender
{
    
    [self fetchDetailsOfType:(DetailsType)self.detailsSegment.selectedSegmentIndex];
    
}

-(void)fetchDetailsOfType:(DetailsType)type
{
    NSString *urlString = @"";
    NSString *baseRequestUrl = @"";
    NSString *detailsType = @"";
    self.details = nil;
    [self.detailsTable reloadData];
    
    switch (type)
    {
        case kContentsType:
            detailsType = @"contents";
            urlString = [self.repoInfo objectForKey:@"contents_url"];
            break;
        case kCommentsType:
            detailsType = @"comments";
            urlString = [self.repoInfo objectForKey:@"comments_url"];
            break;
        default:
            break;
    }
    
    NSLog(@"FULL URL:  %@",urlString);

    baseRequestUrl = [[urlString componentsSeparatedByString:detailsType] firstObject];

    NSLog(@"BASE URL:  %@",baseRequestUrl);
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseRequestUrl]];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [sessionManager GET:detailsType parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        NSLog(@"%@",responseObject);
        self.details = (NSArray *)responseObject;
        if (self.details.count == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Details not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
        [self.detailsTable reloadData];
        
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        NSLog(@"%@",error.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Details not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
}


@end
