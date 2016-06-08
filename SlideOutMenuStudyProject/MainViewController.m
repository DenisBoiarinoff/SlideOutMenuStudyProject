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
#import "UIView+RoundedCorners.h"

//#define START_WIDTH 125
//#define BTN_HEIGHT 90

@interface MainViewController () <HomeViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, assign) BOOL isFulPanel;

@property (nonatomic, assign) CGPoint preVelocity;

@property float max_width;

@property float startWidth;

@property float btnSide;

@end

@implementation MainViewController

@synthesize isFulPanel;

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
	int parentHeight = [[UIScreen mainScreen] bounds].size.height;
	self.max_width = parentWidth / 3;

	self.startWidth = parentWidth / 12;

	self.btnSide = parentHeight / 22.8;

    // Do any additional setup after loading the view from its nib.

	btnImgUrlArray = [NSArray arrayWithObjects:btnHomeImgUrl, btnMessagesImgUrl, btnContactsImgUrl, btnNotesImgUrl,
					  btnHoldpointsImgUrl, btnPhotoImgUrl, btnGaleryImgUrl, btnQRImgUrl, nil];

	btnTitleArray = [NSArray arrayWithObjects:@"Home", @"Messages", @"Contacts", @"Notes",
					 @"Holdpoints", @"Take a photo", @"Browse photos", @"Print QR code", nil];

	self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//	self.homeViewController.view.tag = 100;

	self.homeViewController.delegate = self;

	[self.view addSubview:self.homeViewController.view];
	[self addChildViewController:_homeViewController];

	[self.homeViewController didMoveToParentViewController:self];
//	self.homeViewController.view.frame = CGRectMake(self.startWidth,
//													18,
//													self.view.frame.size.width - self.startWidth,
//													self.view.frame.size.height - 18);

	self.homeViewController.view.frame = CGRectMake(self.startWidth,
													18,
													parentWidth - self.startWidth,
													parentHeight - 18);

	NSLog(@"%f, %f, %f, %f",
		  self.homeViewController.view.frame.origin.x,
		  self.homeViewController.view.frame.origin.y,
		  self.homeViewController.view.frame.size.width,
		  self.homeViewController.view.frame.size.height);
//	NSLog(@"%f, %f, %f, %f",
//		  self.homeViewController.view.bounds.origin.x,
//		  self.homeViewController.view.bounds.origin.y,
//		  self.homeViewController.view.bounds.size.width,
//		  self.homeViewController.view.bounds.size.height);

	[self.homeViewController.view setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10.0];
//	self.homeViewController.view.frame = CGRectMake(START_WIDTH, 18,  self.view.frame.size.width - START_WIDTH, self.view.frame.size.height - 18);

//	[self.homeViewController.view.layer setCornerRadius:10];
//	[self.homeViewController.view.layer setMasksToBounds:YES];

//	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.homeViewController.view.bounds
//												   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight )
//														 cornerRadii:CGSizeMake(10.0, 10.0)];
//
//	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//	maskLayer.frame = self.homeViewController.view.bounds;
//	maskLayer.path  = maskPath.CGPath;
//	self.homeViewController.view.layer.mask = maskLayer;


	UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeViewTap:)];
	recognizer1.delegate = self;
	[self.homeViewController.view addGestureRecognizer:recognizer1];

	[self addButtonsToMenu];

	self.isFulPanel = FALSE;
	[self.homeViewController setIsFullMenu:self.isFulPanel];

	UIButton *btn = (UIButton *)[self.menuView viewWithTag:300];
	[btn setSelected:YES];
	[self.homeViewController setTitle:[btn.titleLabel text]];

	[self setupGestures];

//	UIView *v = [self.view viewWithTag:150];
//	[v.layer setBorderWidth:2.f];
//	[v.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
////	if ([touch.view isKindOfClass:[HomeViewController class]]) {
////		if (self.isFulPanel) {
////			return YES;
////		}
////		return NO;
////	}
////	if (touch.view.tag == 50) {
////		if (self.isFulPanel) {
////			return NO;
////		}
////		return YES;
////	}
////	else {
////		return YES;
////	}
//	return NO;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setupGestures
{
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
	if (panRecognizer) {
		[panRecognizer setMinimumNumberOfTouches:1];
		[panRecognizer setMaximumNumberOfTouches:1];
		[panRecognizer setDelegate:self];

		[self.homeViewController.view addGestureRecognizer:panRecognizer];
	}
}

- (void) movePanel:(id)sender
{
//	NSLog(@"guester recogn izer");
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];

	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
//	CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];

	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		UIView *childView = nil;
		childView = self.homeViewController;

		[self.view sendSubviewToBack:childView];
		[[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];

	}

	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		if (self.isFulPanel) {
			[self movePanelRight];
		} else {
			[self movePanelToOriginalPosition];
		}
	}

	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {

		if ([sender view].frame.origin.x >= self.startWidth) {
			if ([sender view].frame.origin.x <= self.view.frame.size.width * 1/3) {

				[sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
				[(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];

				self.isFulPanel = [sender view].frame.origin.x >= (self.startWidth + self.view.frame.size.width * 1/3)/2 ? true : false;
			} else {
				self.isFulPanel = true;
				[self.homeViewController setIsFullMenu:self.isFulPanel];
			}
		} else {
			self.isFulPanel = false;
			[self.homeViewController setIsFullMenu:self.isFulPanel];
		}
	}
}

- (void) menuViewTap:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"MenuViewTap");
	[self.view sendSubviewToBack:self.homeViewController];

	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
//						 self.homeViewController.view.frame = CGRectMake(self.max_width, 18, self.view.frame.size.width - START_WIDTH, self.view.frame.size.height - 18);
						 self.homeViewController.view.frame = CGRectMake(self.max_width, 18, self.view.frame.size.width - self.startWidth, self.view.frame.size.height - 18);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.homeViewController.view.tag = 101;
							 self.isFulPanel = TRUE;
							 [self.homeViewController setIsFullMenu:self.isFulPanel];
						 }
					 }];
}

- (void)homeViewTap:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"HomeViewTap");
	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
//						 self.homeViewController.view.frame = CGRectMake(START_WIDTH, 18, self.view.frame.size.width - START_WIDTH, self.view.frame.size.height - 18);
						 self.homeViewController.view.frame = CGRectMake(self.startWidth, 18, self.view.frame.size.width - self.startWidth, self.view.frame.size.height - 18);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.isFulPanel = FALSE;
							 [self.homeViewController setIsFullMenu:self.isFulPanel];
							 //							 [self resetMainView];
						 }
					 }];
}

- (void) addButtonsToMenu
{
	int parentHeight = [[UIScreen mainScreen] bounds].size.height;
	float space = parentHeight / 13.67;

//	CGRect frameRect = CGRectMake(0, [self.menuView viewWithTag:150].frame.size.height,
//								  self.max_width, self.btnSide);

	CGRect frameRect = CGRectMake(0, space, self.max_width, self.btnSide);

	for (int i = 0; i < 5; i++) {
		NSLog(@"%f",frameRect.origin.y);
		UIButton *btn = [self getBtnWithImgUrl:[btnImgUrlArray objectAtIndex:i]
										 frame:frameRect
										   tag:300 + i
									  andTitle:[btnTitleArray objectAtIndex:i]];

		[self.menuView addSubview:btn];
		frameRect.origin.y = frameRect.origin.y + self.btnSide;
	}

	frameRect.origin.y = parentHeight - parentHeight / 30;

	for (int i = 7; i > 4; i--) {
		frameRect.origin.y = frameRect.origin.y - self.btnSide;
		UIButton *btn = [self getBtnWithImgUrl:[btnImgUrlArray objectAtIndex:i]
										 frame:frameRect
										   tag:300+i
									  andTitle:[btnTitleArray objectAtIndex:i]];

		[self.menuView addSubview:btn];
	}

}

- (UIButton *) getBtnWithImgUrl:(NSString *)imgUrl frame:(CGRect)frame tag:(int)tag andTitle:(NSString *)title
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setFrame:frame];
	NSLog(@"%f", btn.frame.origin.y);

	float imgSide = self.btnSide / 2.2;

	UIImage *img = [UIImage imageNamed:imgUrl];
//	CGSize imgSize = img.size;
//	CGSize imgSize = CGSizeMake(self.btnSide / 2.37, self.btnSide / 2.37);

//	CGSize imageSize = CGSizeMake(self.btnSide - 10, self.btnSide - 10);
	CGSize imageSize = CGSizeMake(self.btnSide, self.btnSide);
	UIColor *fillColor = [UIColor colorwithHexString:@"232324" alpha:1];

	UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[fillColor setFill];
	CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));

//	CGPoint imagePoint = CGPointMake((self.btnSide - 10)/2 - imgSize.width/2, (self.btnSide - 10)/2 - imgSize.height/2);
//	[img drawAtPoint:imagePoint];

//	[img drawInRect:CGRectMake((self.btnSide - 10)/2 - imgSide/2, (self.btnSide - 10)/2 - imgSide/2, imgSide, imgSide)];
	[img drawInRect:CGRectMake(self.btnSide/2 - imgSide/2, self.btnSide/2 - imgSide/2, imgSide, imgSide)];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[btn setImage:image forState:UIControlStateNormal];

	float space = (self.startWidth - self.btnSide)/2;

	[btn setImageEdgeInsets:UIEdgeInsetsMake(0, space, 0, 0)];


	fillColor = [UIColor colorwithHexString:@"313132" alpha:1];

	UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
	CGContextRef context1 = UIGraphicsGetCurrentContext();
	[fillColor setFill];
	CGContextFillRect(context1, CGRectMake(0, 0, imageSize.width, imageSize.height));
//	[img drawAtPoint:imagePoint];
//	[img drawInRect:CGRectMake((self.btnSide - 10)/2 - imgSide/2, (self.btnSide - 10)/2 - imgSide/2, imgSide, imgSide)];
	[img drawInRect:CGRectMake(self.btnSide/2 - imgSide/2, self.btnSide/2 - imgSide/2, imgSide, imgSide)];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();



	[btn setImage:image forState:UIControlStateSelected];
	UIView *btnimageView = [btn imageView];
	[btnimageView.layer setCornerRadius:5];
	[btnimageView.layer setBorderColor:[UIColor greenColor].CGColor];
	[btnimageView.layer setBorderWidth:1.f];


	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];

	[btn.layer setBorderWidth:2.f];
	[btn.layer setBorderColor:[UIColor redColor].CGColor];
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
	switch ([sender tag]) {
			//			case 300:
			//				[self cancelSelection];
			//				[btn setSelected:YES];
			//			    break;
		default:
			[self setSelectedBtnWithtag:(int)[sender tag]];
			[self.homeViewController setTitle: [sender currentTitle]];
			break;
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
						 self.homeViewController.view.frame = CGRectMake(self.startWidth,
																		 18,
																		 self.view.frame.size.width - self.startWidth,
																		 self.view.frame.size.height - 18);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.isFulPanel = FALSE;
							 [self.homeViewController setIsFullMenu:self.isFulPanel];
							 //							 [self resetMainView];
						 }
					 }];

}

#pragma mark -
#pragma mark Delegate Actions

- (void)movePanelRight
{
	[self.view sendSubviewToBack:self.homeViewController];

	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.homeViewController.view.frame = CGRectMake(self.max_width,
																		 18,
																		 self.view.frame.size.width - self.startWidth,
																		 self.view.frame.size.height - 18);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.homeViewController.view.tag = 101;
							 self.isFulPanel = TRUE;
							 [self.homeViewController setIsFullMenu:self.isFulPanel];
						 }
					 }];
}

- (void)movePanelToOriginalPosition
{
	[self.view sendSubviewToBack:self.homeViewController];

	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.homeViewController.view.frame = CGRectMake(self.startWidth,
																		 18,
																		 self.view.frame.size.width - self.startWidth,
																		 self.view.frame.size.height - 18);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.isFulPanel = FALSE;
							 [self.homeViewController setIsFullMenu:self.isFulPanel];
						 }
					 }];

}
@end
