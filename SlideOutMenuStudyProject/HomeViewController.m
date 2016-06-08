//
//  HomeViewController.m
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()



@end

@implementation HomeViewController

@synthesize isFullMenu;

static NSString *backgroundImg = @"homeBGshadow";

- (void)viewDidLoad {
    [super viewDidLoad];

	UIImage *img = [UIImage imageNamed:backgroundImg];
	[self.background setImage:img];
//	self.isFullMenu = false;
//
//	CAShapeLayer * maskLayer = [CAShapeLayer layer];
//	maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.view.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10., 10.}].CGPath;
//
//	self.view.layer.mask = maskLayer;

//	[self.view.layer setCornerRadius:10];
//	[self.menu.layer setCornerRadius:10];
//	[self.infoView.layer setCornerRadius:10];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	UIImage *img = [UIImage imageNamed:backgroundImg];
	[self.background setImage:img];

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

- (IBAction)someBTN:(id)sender {
	NSLog(@"Some BTN");

}

- (IBAction)menuBtn:(id)sender {
	NSLog(@"Menu Btn");

	if (self.parentViewController) {

	}

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

@end
