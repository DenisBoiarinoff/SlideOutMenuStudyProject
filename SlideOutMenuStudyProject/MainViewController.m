//
//  MainViewController.m
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"

#define START_WIDTH 125

@interface MainViewController () <HomeViewControllerDelegate>

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, assign) BOOL isFulPanel;

@property float max_width;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	int parentWidth = [[UIScreen mainScreen] bounds].size.width;
	self.max_width = parentWidth / 3;

    // Do any additional setup after loading the view from its nib.

	self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
	self.homeViewController.view.tag = 100;
	self.homeViewController.delegate = self;

	[self.homeViewController.view.layer setCornerRadius:3];

	[self.view addSubview:self.homeViewController.view];
	[self addChildViewController:_homeViewController];

	[_homeViewController didMoveToParentViewController:self];
	[self.homeViewController didMoveToParentViewController:self];
	self.homeViewController.view.frame = CGRectMake(START_WIDTH, 18,  self.view.frame.size.width - START_WIDTH, self.view.frame.size.height - 18);

	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuViewTap:)];
	recognizer.delegate = self;
	[[self.view viewWithTag:50] addGestureRecognizer:recognizer];

	UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeViewTap:)];
	recognizer1.delegate = self;
	[self.homeViewController.view addGestureRecognizer:recognizer1];

	self.isFulPanel = FALSE;
//	[self setupGestures];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([touch.view isKindOfClass:[HomeViewController class]]) {
		if (self.isFulPanel) {
			return YES;
		}
		return NO;
	}
	if (touch.view.tag == 50) {
		if (self.isFulPanel) {
			return NO;
		}
		return YES;
	}
	else {
		return YES;
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) menuViewTap:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"MenuViewTap");
	[self.view sendSubviewToBack:self.homeViewController];

	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.homeViewController.view.frame = CGRectMake(self.max_width, 18, self.view.frame.size.width - START_WIDTH, self.view.frame.size.height - 18);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.homeViewController.view.tag = 101;
							 self.isFulPanel = TRUE;
						 }
					 }];
}

- (void)homeViewTap:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"HomeViewTap");
	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.homeViewController.view.frame = CGRectMake(START_WIDTH, 18, self.view.frame.size.width - START_WIDTH, self.view.frame.size.height - 18);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.isFulPanel = FALSE;
							 //							 [self resetMainView];
						 }
					 }];
}

#pragma mark -
#pragma mark Delegate Actions

- (void)movePanelRight
{

}

- (void)movePanelToOriginalPosition
{

}

- (IBAction)ShowMenu:(id)sender {
	NSLog(@"HOME");
//	UIView *childView = [self getRightView];
//	[self.view sendSubviewToBack:self.homeViewController];
//
//	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
//					 animations:^{
//						 self.homeViewController.view.frame = CGRectMake(300, 18, self.view.frame.size.width, self.view.frame.size.height);
//					 }
//					 completion:^(BOOL finished) {
//						 if (finished) {
//							 self.homeViewController.view.tag = 101;
//						 }
//					 }];
}

- (IBAction)BackMenu:(id)sender {
	NSLog(@"Messages");
//	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
//					 animations:^{
//						 self.homeViewController.view.frame = CGRectMake(50, 18, self.view.frame.size.width, self.view.frame.size.height);
//					 }
//					 completion:^(BOOL finished) {
//						 if (finished) {
//
////							 [self resetMainView];
//						 }
//					 }];
}
@end
