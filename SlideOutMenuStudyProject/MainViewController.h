//
//  MainViewController.h
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIGestureRecognizerDelegate>


- (IBAction)ShowMenu:(id)sender;
- (IBAction)BackMenu:(id)sender;

- (void)menuViewTap:(UITapGestureRecognizer *)recognizer;
- (void)homeViewTap:(UITapGestureRecognizer *)recognizer;

@end
