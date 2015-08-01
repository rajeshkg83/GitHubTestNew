//
//  ViewController.m
//  GitHubTest
//
//  Created by Cap on 8/1/15.
//  Copyright (c) 2015 Cap. All rights reserved.
//

#import "ViewController.h"
#import "ReposListViewController.h"

@interface ViewController ()

@property (nonatomic , strong) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) NSString *accessType;

- (IBAction)signInAction:(id)sender;

@end

static NSString * const BaseURLString = @"https://api.github.com/";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchUserRepos
{
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];

    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];

    NSData *userPasswordData = [[NSString stringWithFormat:@"%@:%@", userName, password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", base64EncodedCredential];
    sessionManager.session.configuration.HTTPAdditionalHeaders = @{@"Authorization":authString};
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    [sessionManager GET:self.accessType parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        NSLog(@"%@",responseObject);
        NSArray *repos = (NSArray *)responseObject;

        if (repos.count)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ReposListViewController *reposListViewController = [storyboard instantiateViewControllerWithIdentifier:@"ReposListViewController"];
            reposListViewController.reposList = repos;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reposListViewController];
            [self presentViewController:navController animated:YES completion:^{
                
            }];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No repositories found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError *error) {

        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        NSLog(@"%@",error.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Authentication Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
    
}

- (IBAction)signInAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 10)
        self.accessType = @"user/repos";
    else
        self.accessType = @"repositories";
    
    if (self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0)
    {
        [self.userNameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self fetchUserRepos];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"User name and Password must be entered." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
@end
