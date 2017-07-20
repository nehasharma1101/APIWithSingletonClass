//
//  ViewController.m
//  SibgletonClassExample
//
//  Created by Rajesh K G on 25/11/16.
//  Copyright © 2016 INDGlobal. All rights reserved.
//

#import "ViewController.h"

#import "CommonManager.h"
#import "BaseUrls.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Login
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] addSpinnerViewOnScreen:YES];
    NSString *strParam =[NSString stringWithFormat:@"email=%@&pass=%@",_emailID.text,_password.text];
    
    [[CommonManager sharedManager] postOrGetFormData:kLogin strParameters:strParam postPar:nil method:@"POST" setHeader:NO successHandler:^(id response) {
        
        if (response)
        {
            
            NSLog(@"%@",response);
            if (![response[@"isSuccess"] isEqualToString:@"false"]) {
                [[NSUserDefaults standardUserDefaults] setObject:response[@"userId"] forKey:@"customerId"];
                [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"userDetails"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginSaved"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"LoginToDashboardIdentifier" sender:nil];
                });
            }
            else
            {
                
                [self customAlertView:@"" Message:response[@"successMsg"] okBtn:@"OK" cancle:nil tag:0];
            }
            
        }
        
    } failureHandler:^(id response) {
        [self customAlertView:@"Server Error" Message:@"" okBtn:@"OK" cancle:nil tag:0];
    }];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] addSpinnerViewOnScreen:NO];
}

#pragma mark -Custom Alert view method

-(void)customAlertView:(NSString *)title Message:(NSString *)message okBtn:(NSString *)okBtn cancle:(NSString *)cancle tag:(NSInteger)alertTag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:okBtn otherButtonTitles:cancle, nil];
    alert.tag = alertTag;
    [alert show];
}

- (IBAction)Submit:(id)sender
{
    [self Login];
}



@end
