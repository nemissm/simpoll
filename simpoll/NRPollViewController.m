//
//  NRPollViewController.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 06/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRPollViewController.h"

@interface NRPollViewController ()

@property (strong, nonatomic) NRPollView *pollView;
@property (strong, nonatomic) NSArray *answerTitles;

@end

@implementation NRPollViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.navigationItem.title = @"До";

  self.answerTitles = @[@"Short", @"Of course I want!", @"1"];
  
  // Initialize poll view
  self.pollView = [[NRPollView alloc] initBelowNavigationBar];
  self.pollView.dataSource = self;
  self.pollView.delegate = self;
  [self.view  addSubview:self.pollView];
}

#pragma mark - <NRPollViewDataSource>

- (NSString *)titleForQuestionInPollView:(NRPollView *)pollView {
  return @"TEST test TEST TEST test TEST TEST test TEST TEST test TEST TEST test TEST";
}

- (NSUInteger)numberOfAnswersInPollView:(NRPollView *)pollView {
  return 3;
}

- (NSString *)pollView:(NRPollView *)pollView titleForAnswerAtIndex:(NSUInteger)index {
  return [self.answerTitles objectAtIndex:index];
}

#pragma mark - <NRPollViewDelegate>

- (void)pollView:(NRPollView *)pollView clickedAnswerButtonAtIndex:(NSUInteger)index {
  [self.pollView showResults];
  
  CATransition *fadeTextAnimation = [CATransition animation];
  fadeTextAnimation.duration = 0.3;
  fadeTextAnimation.type = kCATransitionFade;
  [self.navigationController.navigationBar.layer addAnimation:fadeTextAnimation
                                                       forKey:@"fadeTextAnimation"];
  self.navigationItem.title = @"После";
}

@end
