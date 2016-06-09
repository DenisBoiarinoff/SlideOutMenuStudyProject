//
//  HomeViewController.h
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface HomeViewController : UIViewController

@property (nonatomic, assign) id<HomeViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setTitle:(NSString *)title;

- (IBAction)menuBtn:(id)sender;

@property (assign, nonatomic) BOOL isFullMenu;

@end
