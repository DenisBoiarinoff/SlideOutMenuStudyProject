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

@interface MainViewController () <HomeViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, assign) BOOL isFulPanel;

@property (nonatomic, assign) CGPoint preVelocity;

@property float maxWidth;

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
	self.maxWidth = parentWidth / 3;

	self.startWidth = parentWidth / 12;

	self.btnSide = parentHeight / 22.8;

    // Do any additional setup after loading the view from its nib.

	btnImgUrlArray = [NSArray arrayWithObjects:btnHomeImgUrl, btnMessagesImgUrl, btnContactsImgUrl, btnNotesImgUrl,
					  btnHoldpointsImgUrl, btnPhotoImgUrl, btnGaleryImgUrl, btnQRImgUrl, nil];

	btnTitleArray = [NSArray arrayWithObjects:@"Home", @"Messages", @"Contacts", @"Notes",
					 @"Holdpoints", @"Take a photo", @"Browse photos", @"Print QR code", nil];

	self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];

	self.homeViewController.delegate = self;

	[self.view addSubview:self.homeViewController.view];
	[self addChildViewController:_homeViewController];

	[self.homeViewController didMoveToParentViewController:self];
	self.homeViewController.view.frame = CGRectMake(self.startWidth,
													18,
													self.view.frame.size.width - self.startWidth,
													self.view.frame.size.height /*- 18*/);

	[self.homeViewController.view.layer setCornerRadius:5];
	[self.homeViewController.view.layer setMasksToBounds:YES];

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
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];

	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];

	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		UIView *childView = nil;
		childView = (UIView *)self.homeViewController;

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
	[self.view sendSubviewToBack:(UIView *)self.homeViewController];

	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.homeViewController.view.frame = CGRectMake(self.maxWidth,
																		 18,
																		 self.view.frame.size.width - self.startWidth,
																		 self.view.frame.size.height);
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
	[self movePanelToOriginalPosition];
}

- (void) addButtonsToMenu
{
	int parentHeight = [[UIScreen mainScreen] bounds].size.height;
	float space = parentHeight / 13.67 + 10;

	CGRect frameRect = CGRectMake(0, space, self.maxWidth, self.btnSide);

	for (int i = 0; i < 5; i++) {
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

	float imgSide = self.btnSide / 2.1;

	UIImage *img = [UIImage imageNamed:imgUrl];
	CGSize imgSize = img.size;

	float xRatio;
	float yRatio;

	if (imgSize.width > imgSize.height) {
		xRatio = 1;
		yRatio = imgSize.height / imgSize.width;
	} else {
		xRatio = imgSize.width / imgSize.height;
		yRatio = 1;
	}

	float spaceToImg = (self.startWidth - self.btnSide)/2;

	[btn setImageEdgeInsets:UIEdgeInsetsMake(0, spaceToImg, 0, 0)];

	CGSize imageSize = CGSizeMake(self.btnSide, self.btnSide);
	UIColor *fillColor = [UIColor colorwithHexString:@"232324" alpha:1];

	UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[fillColor setFill];
	CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));

	[img drawInRect:CGRectMake((self.btnSide - imgSide * xRatio)/2, (self.btnSide - imgSide * yRatio)/2, imgSide * xRatio, imgSide * yRatio)];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[btn setImage:image forState:UIControlStateNormal];

	fillColor = [UIColor colorwithHexString:@"313132" alpha:1];

	UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
	CGContextRef context1 = UIGraphicsGetCurrentContext();
	[fillColor setFill];
	CGContextFillRect(context1, CGRectMake(0, 0, imageSize.width, imageSize.height));
	[img drawInRect:CGRectMake((self.btnSide - imgSide * xRatio)/2, (self.btnSide - imgSide * yRatio)/2, imgSide * xRatio, imgSide * yRatio)];

	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[btn setImage:image forState:UIControlStateSelected];
	UIView *btnimageView = [btn imageView];
	[btnimageView.layer setCornerRadius:5];
	[btnimageView.layer setBorderColor:[UIColor colorwithHexString:@"232324" alpha:1].CGColor];
	[btnimageView.layer setBorderWidth:1.5f];

	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];

	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

	[btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Neue" size:20]];

	[btn addTarget:self
			action:@selector(menuBtnPressed:)
  forControlEvents:UIControlEventTouchUpInside];

	[btn setTag:tag];

	return btn;
}

-(IBAction)menuBtnPressed:(id)sender
{
	switch ([sender tag]) {
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
}

#pragma mark -
#pragma mark Delegate Actions

- (void)movePanelRight
{
	[self.view sendSubviewToBack:(UIView *)self.homeViewController];

	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.homeViewController.view.frame = CGRectMake(self.maxWidth,
																		 18,
																		 self.view.frame.size.width - self.startWidth,
																		 self.view.frame.size.height);
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
	[self.view sendSubviewToBack:(UIView *)self.homeViewController];

	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.homeViewController.view.frame = CGRectMake(self.startWidth,
																		 18,
																		 self.view.frame.size.width - self.startWidth,
																		 self.view.frame.size.height);
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.isFulPanel = FALSE;
							 [self.homeViewController setIsFullMenu:self.isFulPanel];
						 }
					 }];

}
@end
