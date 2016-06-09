//
//  HomeViewController.m
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+ColorFromHex.h"

@interface HomeViewController ()



@end

@implementation HomeViewController

@synthesize isFullMenu;

static NSString *backgroundImg = @"homeBGshadow";
static NSString *menuImgUrl = @"search";

- (void)viewDidLoad {
    [super viewDidLoad];

	[self configureInfoView];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtn:(id)sender {
	if (self.isFullMenu) {
		[self.delegate movePanelToOriginalPosition];
		self.isFullMenu = false;
	} else {
		[self.delegate movePanelRight];
		self.isFullMenu = true;
	}
}

- (void)setTitle:(NSString *)title
{
	[self.titleLabel setText:title];
}

- (void) configureInfoView
{
	CALayer *rightBorder = [CALayer layer];

	float menuBtnHeight = [[UIScreen mainScreen] bounds].size.height / 32.53;
	float menuBtnWidth = [[UIScreen mainScreen] bounds].size.width / 21.86;

	rightBorder.frame = CGRectMake(menuBtnWidth, 0, 1.0f, menuBtnHeight);

	rightBorder.backgroundColor = [UIColor colorwithHexString:@"e9e9e9" alpha:1.].CGColor;
	[self.infoView.layer addSublayer:rightBorder];


	CGRect frameRrect = CGRectMake(0, 0, menuBtnWidth, menuBtnHeight);

	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setFrame:frameRrect];

	UIImage *img = [UIImage imageNamed:menuImgUrl];
	CGSize imgSize = img.size;

	CGSize imageSize = CGSizeMake(menuBtnWidth, menuBtnHeight);
	UIColor *fillBtnColor = [UIColor whiteColor];

	UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
	CGContextRef btnContext = UIGraphicsGetCurrentContext();
	[fillBtnColor setFill];
	CGContextFillRect(btnContext, CGRectMake(0, 0, menuBtnWidth, menuBtnHeight));

	float xRatio = 0.6;
	float yRatio = 0.43;

	[img drawInRect:CGRectMake((imageSize.width - imgSize.width * xRatio)/2,
							   (imageSize.height - imgSize.height * yRatio)/2,
							   imgSize.width * xRatio,
							   imgSize.height * yRatio)];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	[btn setImage:image forState:UIControlStateNormal];

	[btn addTarget:self
			action:@selector(menuBtn:)
  forControlEvents:UIControlEventTouchUpInside];

	[self.infoView addSubview:btn];

}

@end
