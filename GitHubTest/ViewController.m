//
//  ViewController.m
//  GitHubTest
//
//  Created by Cap on 7/31/15.
//  Copyright (c) 2015 Cap. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic , strong) NSURLSession *session;

@end

static NSString * const BaseURLString = @"https://api.github.com/";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
    NSString *requestString = @"https://api.github.com/user/repos";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSData *userPasswordData = [[NSString stringWithFormat:@"%@:%@", @"rajeshkg83", @"#pragop123"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", base64EncodedCredential];
    
    NSURLSessionConfiguration *sessionConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPAdditionalHeaders=@{@"Authorization":authString};
    
    self.session=[NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strData);
    }];
    
    [dataTask resume];
    */
    NSString *string = [NSString stringWithFormat:@"%@user/repos", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    
    NSData *userPasswordData = [[NSString stringWithFormat:@"%@:%@", @"rajeshkg83", @"#pragop123"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", base64EncodedCredential];
    sessionManager.session.configuration.HTTPAdditionalHeaders = @{@"Authorization":authString};
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [sessionManager GET:@"user/repos" parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        
        NSLog(@"%@",error.description);
    }];
    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dict = (NSDictionary *)responseObject;
//        
//        NSLog(@"%@",[dict description]);
//        // 3
////        self.weather = (NSDictionary *)responseObject;
////        self.title = @"JSON Retrieved";
////        [self.tableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        // 4
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }];
//    
//    // 5
//    [operation start];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
