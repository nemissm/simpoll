//
//  NRPollViewController.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 06/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRPollViewController.h"

@interface NRPollViewController ()

@property (assign, nonatomic) BOOL displayingPrimary;
@property (strong, nonatomic) UIView *primaryView;
@property (strong, nonatomic) UIView *secondaryView;

@end

@implementation NRPollViewController {
  CGRect primaryViewRect;
  CGRect secondaryViewRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
      
  // Test navigation bar title animation
  
  self.navigationItem.title = @"До";
  
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
  [button setTitle:@"Calibration" forState:UIControlStateNormal];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
  [button addTarget:self
             action:@selector(myAction) 
   forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:button];
  
  // Initialization
  self.displayingPrimary = YES;
  
  primaryViewRect = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 100);
  secondaryViewRect = CGRectMake(0, -36, [UIScreen mainScreen].bounds.size.width, 100);
  
  self.primaryView = [[UIView alloc] initWithFrame:primaryViewRect];
  self.primaryView.backgroundColor = [UIColor greenColor];
  self.secondaryView = [[UIView alloc] initWithFrame:secondaryViewRect];
  self.secondaryView.backgroundColor = [UIColor grayColor];
  
  [self.view addSubview:self.primaryView];
  [self.view addSubview:self.secondaryView];
}

- (void)myAction {
  CATransition *fadeTextAnimation = [CATransition animation];
  fadeTextAnimation.duration = 0.3;
  fadeTextAnimation.type = kCATransitionFade;

  [self.navigationController.navigationBar.layer addAnimation:fadeTextAnimation
                                                       forKey:@"fadeText"];
  if ([self.navigationItem.title isEqualToString:@"До"])
    self.navigationItem.title = @"После";
  else
    self.navigationItem.title = @"До";
  
  // Switch between views
  [UIView animateWithDuration:0.3
    animations:^{
      self.secondaryView.frame = (self.displayingPrimary ? primaryViewRect : secondaryViewRect);
      self.displayingPrimary = !self.displayingPrimary;
    }];
  
  
//  [UIView transitionFromView:(self.displayingPrimary ? self.primaryView : self.secondaryView)
//                      toView:(self.displayingPrimary ? self.secondaryView : self.primaryView)
//                    duration:1.0
//                     options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionFlipFromLeft)
//                  completion:^(BOOL finished) {
//                    if (finished) {
//                      self.displayingPrimary = !self.displayingPrimary;
//                    }
//                  }];
  
//typedef NS_OPTIONS(NSUInteger, UIViewAnimationOptions) {
//    UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
//    UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
//    UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
//    UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
//    UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
//    UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
//    UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
//    UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
//    UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
//    UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
//    
//    UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
//    UIViewAnimationOptionCurveEaseIn               = 1 << 16,
//    UIViewAnimationOptionCurveEaseOut              = 2 << 16,
//    UIViewAnimationOptionCurveLinear               = 3 << 16,
//    
//    UIViewAnimationOptionTransitionNone            = 0 << 20, // default
//    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
//    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
//    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
//    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
//    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
//    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
//    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
//} NS_ENUM_AVAILABLE_IOS(4_0);
  
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

@end
