//
//  NRPollViewController.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 06/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRPollViewController.h"
#import "NRAnswerVotes.h"

@interface NRPollViewController ()

@property (strong, nonatomic) NRPollView *pollView;
@property (strong, nonatomic) NSArray *answerTitlesArray;
@property (strong, nonatomic) NSMutableArray *answerVotesArray;

@end

@implementation NRPollViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.navigationItem.title = @"До";
  
  // Test data
  self.answerTitlesArray = @[@"Short", @"Of", @"1"];
  
  self.answerVotesArray = [NSMutableArray array];
  
  NSUInteger totalCount = 0;
  
  for (NSUInteger i = 0; i <= 2; i++) {
    NSUInteger randomCount = arc4random_uniform(9999);
    totalCount += randomCount;
    NRAnswerVotes *answerVotes = [[NRAnswerVotes alloc] initWithIndex:i count:randomCount];
    [self.answerVotesArray addObject:answerVotes];
  }
  
  for (NRAnswerVotes *answerVotes in self.answerVotesArray) {
    [answerVotes calculateShareWithTotalCount:totalCount];
  }
  
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

- (NSString *)pollView:(NRPollView *)pollView answerTitleAtIndex:(NSUInteger)index {
  return [self.answerTitlesArray objectAtIndex:index];
}

- (NRAnswerVotes *)pollView:(NRPollView *)pollView answerVotesAtIndex:(NSUInteger)index {
  return [self.answerVotesArray objectAtIndex:index];
}

#pragma mark - <NRPollViewDelegate>

- (void)pollView:(NRPollView *)pollView clickedAnswerButtonAtIndex:(NSUInteger)index {
  
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.pollView showResults];
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  });
  
  CATransition *fadeTextAnimation = [CATransition animation];
  fadeTextAnimation.duration = 0.3;
  fadeTextAnimation.type = kCATransitionFade;
  [self.navigationController.navigationBar.layer addAnimation:fadeTextAnimation
                                                       forKey:@"fadeTextAnimation"];
  self.navigationItem.title = @"После";
}

@end
