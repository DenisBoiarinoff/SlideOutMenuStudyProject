//
//  LoginViewController.h
//  SlideOutMenuStudyProject
//
//  Created by Rhinoda3 on 06.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class MainViewController;

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *emailAndPass;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UIButton *forgotPassBtn;

//@property (strong, nonatomic) MainViewController *mainViewController;

- (IBAction)verifyData:(id)sender;
- (IBAction)toForgotPass:(id)sender;

@end
