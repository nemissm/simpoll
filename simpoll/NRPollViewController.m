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
@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) NRPollView *pollView;

@end

@implementation NRPollViewController {
  CGRect primaryViewRect;
  CGRect secondaryViewRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  // Tests
  CGSize size = [@"" sizeWithAttributes:
    @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
  NSLog(@"size: %@", NSStringFromCGSize(size));
  
  
  
  // Test navigation bar title animation
  
  self.navigationItem.title = @"До";
  
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
  [button setTitle:@"Calibration" forState:UIControlStateNormal];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
  [button addTarget:self
             action:@selector(myAction) 
   forControlEvents:UIControlEventTouchUpInside];
  
  
  
  // Initialization
  self.displayingPrimary = YES;
  
  primaryViewRect = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 100);
  secondaryViewRect = CGRectMake([UIScreen mainScreen].bounds.size.width, 64, [UIScreen mainScreen].bounds.size.width, 100);
  
  self.primaryView = [[UIView alloc] initWithFrame:primaryViewRect];
  self.primaryView.backgroundColor = [UIColor greenColor];
  self.secondaryView = [[UIView alloc] initWithFrame:secondaryViewRect];
  self.secondaryView.backgroundColor = [UIColor grayColor];
  
//  self.containerView = [[UIView alloc] initWithFrame:primaryViewRect];
//  
//  [self.view addSubview:self.containerView];
  
//  [self.view  addSubview:self.primaryView];
//  [self.view  addSubview:self.secondaryView];
  
  // Test poll View
  self.pollView = [[NRPollView alloc] initBelowNavigationBar];
  self.pollView.dataSource = self;
  self.pollView.delegate = self;
  [self.view  addSubview:self.pollView];
  // all subviews must go after pollView
  [self.view addSubview:button];
}

#pragma mark - <NRPollViewDataSource>

- (NSString *)titleForQuestionInPollView:(NRPollView *)pollView {
  return @"TEST test TEST TEST test TEST TEST test TEST TEST test TEST TEST test TEST";
}

- (NSUInteger)numberOfAnswersInPollView:(NRPollView *)pollView {
  return 2 + arc4random_uniform(6);
}

#pragma mark - <NRPollViewDelegate>
- (void)pollView:(NRPollView *)pollView clickedAnswerButtonAtIndex:(NSUInteger)index {
  [self.pollView showResults];
}

#pragma mark - Other
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
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
    animations:^{
      self.secondaryView.frame = (self.displayingPrimary ? primaryViewRect : secondaryViewRect);
      self.displayingPrimary = !self.displayingPrimary;
    }
    completion:^(BOOL finished) {

    }];
  
  
//  CATransition *transition = [CATransition animation];
//  transition.duration = 0.5;
//  transition.type = kCATransitionPush;
//  transition.subtype = kCATransitionFromTop;
//  [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//  [self.secondaryView.layer addAnimation:transition forKey:nil];
//
//  [self.containerView addSubview:self.secondaryView];
  
//  [UIView transitionFromView:(self.displayingPrimary ? self.primaryView : self.secondaryView)
//                      toView:(self.displayingPrimary ? self.secondaryView : self.primaryView)
//                    duration:0.3
//                     options:(UIViewAnimationOptionTransitionCurlDown | UIViewAnimationOptionCurveEaseInOut)
//                  completion:^(BOOL finished) {
//                    if (finished) {
//                      self.displayingPrimary = !self.displayingPrimary;
//                    }
//                  }];
  

  
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
