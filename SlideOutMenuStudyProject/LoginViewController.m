//
//  LoginViewController.m
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

#import "UIColor+ColorFromHex.h"

#define CORNER_RADIUS 10

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setNeedsStatusBarAppearanceUpdate];

	[self.navigationController.navigationBar setHidden:YES];

	[self.loginBtn.layer setCornerRadius:CORNER_RADIUS];
	
	[self.emailAndPass.layer setCornerRadius:CORNER_RADIUS];

	[self.forgotPassBtn.layer setCornerRadius:CORNER_RADIUS];

	CALayer *bottomBorder = [CALayer layer];

	float emailHeight = self.emailAndPass.frame.size.height / 2 - 1;
	float emailWidth = [[UIScreen mainScreen] bounds].size.width / 2;
	bottomBorder.frame = CGRectMake(0, emailHeight, emailWidth, 1.0f);

	bottomBorder.backgroundColor = [UIColor colorwithHexString:@"e9e9e9" alpha:1.].CGColor;
	[self.emailAndPass.layer addSublayer:bottomBorder];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)verifyData:(id)sender {
//	if (![self.email.text isEqualToString:@""]
//		&& ![self.password.text isEqualToString:@""]) {

		MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
		[self.navigationController pushViewController:mainViewController animated:YES];
//	}
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (IBAction)toForgotPass:(id)sender {
}
@end
