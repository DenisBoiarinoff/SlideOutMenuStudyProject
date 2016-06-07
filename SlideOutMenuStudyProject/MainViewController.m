//
//  MainViewController.m
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "UIColor+ColorFromHex.h"

#define START_WIDTH 125
#define BTN_HEIGHT 90

@interface MainViewController ()
//<HomeViewControllerDelegate>

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, assign) BOOL isFulPanel;

@property float max_width;

@end

@implementation MainViewController

static NSString *btnHomeImgUrl = @"home";
static NSString *btnMessagesImgUrl = @"messages";
static NSString *btnContactsImgUrl = @"contacts";
static NSString *btnNotesImgUrl = @"notes";
static NSString *btnHoldpointsImgUrl = @"flag";

static NSString *btnPhotoImgUrl = @"camera";
static NSString *btnGaleryImgUrl = @"img";
static NSString *btnQRImgUrl = @"QR";

NSArray *btnImgUrlArray;
NSArray *btnTitleArray;

- (void)viewDidLoad {
    [super viewDidLoad];

	int parentWidth = [[UIScreen mainScreen] bounds].size.width;
	self.max_width = parentWidth / 3;

    // Do any additional setup after loading the view from its nib.

	btnImgUrlArray = [NSArray arrayWithObjects:btnHomeImgUrl, btnMessagesImgUrl, btnContactsImgUrl, btnNotesImgUrl,
					  btnHoldpointsImgUrl, btnPhotoImgUrl, btnGaleryImgUrl, btnQRImgUrl, nil];

	btnTitleArray = [NSArray arrayWithObjects:@"Home", @"Messages", @"Contacts", @"Notes",
					 @"Holdpoints", @"Take a photo", @"Browse photos", @"Print QR code", nil];

	self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
	self.homeViewController.view.tag = 100;

//	self.homeViewController.delegate = self;

	[self.view addSubview:self.homeViewController.view];
	[self addChildViewController:_homeViewController];

	[_homeViewController didMoveToParentViewController:self];
	[self.homeViewController didMoveToParentViewController:self];
	self.homeViewController.view.frame = CGRectMake(START_WIDTH, 18,  self.view.frame.size.width - START_WIDTH, self.view.frame.size.height - 18);
	[self.homeViewController.view.layer setCornerRadius:10];

	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuViewTap:)];
	recognizer.delegate = self;
	[[self.view viewWithTag:50] addGestureRecognizer:recognizer];

	UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeViewTap:)];
	recognizer1.delegate = self;
	[self.homeViewController.view addGestureRecognizer:recognizer1];

	[self addButtonsToMenu];

	self.isFulPanel = FALSE;

	UIButton *btn = (UIButton *)[self.menuView viewWithTag:300];
	[btn setSelected:YES];

//	[self setupGestures];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//	if ([touch.view isKindOfClass:[HomeViewController class]]) {
//		if (self.isFulPanel) {
//			return YES;
//		}
//		return NO;
//	}
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

- (void) addButtonsToMenu
{
	CGRect frameRect = CGRectMake(0, [self.menuView viewWithTag:150].frame.size.height,
								  self.max_width, BTN_HEIGHT);
	for (int i = 0; i < 5; i++) {
		UIButton *btn = [self getBtnWithImgUrl:[btnImgUrlArray objectAtIndex:i]
										 frame:frameRect
										   tag:300 + i
									  andTitle:[btnTitleArray objectAtIndex:i]];

		[self.menuView addSubview:btn];
		frameRect.origin.y = frameRect.origin.y + BTN_HEIGHT;
	}

	frameRect.origin.y = [[UIScreen mainScreen] bounds].size.height;

	for (int i = 7; i > 4; i--) {
		frameRect.origin.y = frameRect.origin.y - BTN_HEIGHT;
		UIButton *btn = [self getBtnWithImgUrl:[btnImgUrlArray objectAtIndex:i]
										 frame:frameRect
										   tag:300+i
									  andTitle:[btnTitleArray objectAtIndex:i]];

		[self.menuView addSubview:btn];
	}

//	UIButton *btn = [self getBtnWithImgUrl:btnHomeImgUrl frame:frameRect andTitle:@"Home"];
//
//	[self.menuView addSubview:btn];
}

- (UIButton *) getBtnWithImgUrl:(NSString *)imgUrl frame:(CGRect)frame tag:(int)tag andTitle:(NSString *)title
{

//	UIButton *btn = [[UIButton alloc] initWithFrame:frame];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setFrame:frame];

	UIImage *img = [UIImage imageNamed:imgUrl];
	CGSize imgSize = img.size;

	CGSize imageSize = CGSizeMake(BTN_HEIGHT - 10, BTN_HEIGHT - 10);
	UIColor *fillColor = [UIColor colorwithHexString:@"232324" alpha:1];

/*-------------------------------------------------------------*/
	UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[fillColor setFill];
	CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
	CGPoint imagePoint = CGPointMake(40 - imgSize.width/2, 40 - imgSize.height/2);
	[img drawAtPoint:imagePoint];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[btn setImage:image forState:UIControlStateNormal];
	[btn setImageEdgeInsets:UIEdgeInsetsMake(0, 22.5, 0, 0)];
/*------------------------------------*/
	fillColor = [UIColor colorwithHexString:@"313132" alpha:1];

	UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
	CGContextRef context1 = UIGraphicsGetCurrentContext();
	[fillColor setFill];
	CGContextFillRect(context1, CGRectMake(0, 0, imageSize.width, imageSize.height));
	[img drawAtPoint:imagePoint];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[btn setImage:image forState:UIControlStateSelected];
/*---------------------------------------------------------*/
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];

//	[btn.layer setBorderWidth:2.f];
//	[btn.layer setBorderColor:[UIColor redColor].CGColor];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

	[btn setFont:[UIFont fontWithName:@"Helvetica-Neue" size:20]];

	[btn addTarget:self
			action:@selector(menuBtnPressed:)
  forControlEvents:UIControlEventTouchUpInside];

	[btn setTag:tag];

	return btn;
}

-(IBAction)menuBtnPressed:(id)sender
{
	if (!self.isFulPanel) {
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
//		[self cancelSelection];
	} else {
//		UIButton *btn = (UIButton *)sender;
		switch ([sender tag]) {
//			case 300:
//
//				[self cancelSelection];
//				[btn setSelected:YES];
//			    break;
//			case 301:
//				[self cancelSelection];
//				[btn setSelected:YES];
//				break;
//			case 302:
//				[self cancelSelection];
//				[btn setSelected:YES];
//				break;
//			case 303:
//				[self cancelSelection];
//				[btn setSelected:YES];
//				break;
//			case 304:
//				[self cancelSelection];
//				[btn setSelected:YES];
//				break;
//			case 305:
//				[self cancelSelection];
//				[btn setSelected:YES];
//				break;
//			case 306:
//				[self cancelSelection];
//				[btn setSelected:YES];
//				break;
//			case 307:
//				[self cancelSelection];
//				[btn setSelected:YES];
				break;
			default:
				[self setSelectedBtnWithtag:(int)[sender tag]];
				break;
		}
	}
}

- (void) cancelSelection
{
	for(UIView *subview in [self.menuView subviews]) {
		if (subview.class == UIButton.class) {
			UIButton *btn = (UIButton *)subview;
			[btn setSelected:NO];
		}
	}
}

- (void) setSelectedBtnWithtag:(int) tag
{
	[self cancelSelection];
	UIButton *btn = (UIButton *)[self.menuView viewWithTag:tag];
	[btn setSelected:YES];
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

//- (void)movePanelRight
//{
//
//}
//
//- (void)movePanelToOriginalPosition
//{
//
//}

//- (IBAction)ShowMenu:(id)sender {
//	NSLog(@"HOME");
////	UIView *childView = [self getRightView];
////	[self.view sendSubviewToBack:self.homeViewController];
////
////	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
////					 animations:^{
////						 self.homeViewController.view.frame = CGRectMake(300, 18, self.view.frame.size.width, self.view.frame.size.height);
////					 }
////					 completion:^(BOOL finished) {
////						 if (finished) {
////							 self.homeViewController.view.tag = 101;
////						 }
////					 }];
//}
//
//- (IBAction)BackMenu:(id)sender {
//	NSLog(@"Messages");
////	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
////					 animations:^{
////						 self.homeViewController.view.frame = CGRectMake(50, 18, self.view.frame.size.width, self.view.frame.size.height);
////					 }
////					 completion:^(BOOL finished) {
////						 if (finished) {
////
//////							 [self resetMainView];
////						 }
////					 }];
//}
@end
