//
//  NRPollViewController.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 06/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRPollViewController.h"
#import "NRAnswerVotes.h"
#import "NRDataManager.h"

#import <MBProgressHUD.h>

@interface NRPollViewController ()

@property (strong, nonatomic) NRDataManager *dataManager;
@property (strong, nonatomic) NRPollView *pollView;

@property (assign, nonatomic) NSUInteger questionIndex;
@property (strong, nonatomic) NSString *questionTitle;
@property (strong, nonatomic) NSArray *answerTitlesArray;
@property (strong, nonatomic) NSArray *answerVotesArray;

@end

@implementation NRPollViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.navigationItem.title = @"До";
  /*
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
  */
  
  self.questionIndex = 1;
  // Data manager;
  self.dataManager = [NRDataManager sharedManager];
  
  // Get data
  [self loadData];
  
  // Initialize poll view
  self.pollView = [[NRPollView alloc] initBelowNavigationBar];
  self.pollView.dataSource = self;
  self.pollView.delegate = self;
  [self.view  addSubview:self.pollView];
}

#pragma mark - API Interaction

- (void)loadData {
  self.questionTitle = [self.dataManager getTitleForQuestionAtIndex:self.questionIndex];
  self.answerTitlesArray = [self.dataManager getAnswerTitlesForQuestionAtIndex:self.questionIndex];
}

#pragma mark - <NRPollViewDataSource>

- (NSString *)titleForQuestionInPollView:(NRPollView *)pollView {
  return self.questionTitle;
}

- (NSUInteger)numberOfAnswersInPollView:(NRPollView *)pollView {
  return [self.answerTitlesArray count];
}

- (NSString *)pollView:(NRPollView *)pollView answerTitleAtIndex:(NSUInteger)index {
  return [self.answerTitlesArray objectAtIndex:index];
}

- (NRAnswerVotes *)pollView:(NRPollView *)pollView answerVotesAtIndex:(NSUInteger)index {
  return [self.answerVotesArray objectAtIndex:index];
}

#pragma mark - <NRPollViewDelegate>

- (void)pollView:(NRPollView *)pollView clickedAnswerButtonAtIndex:(NSUInteger)index {
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
  [self.dataManager voteForAnswerAtIndex:index
                         questionAtIndex:self.questionIndex
    completion:^(NSArray *answerVotesArray) {
      self.answerVotesArray = answerVotesArray;
      [self.pollView showResults];
    
      CATransition *fadeTextAnimation = [CATransition animation];
      fadeTextAnimation.duration = 0.3;
      fadeTextAnimation.type = kCATransitionFade;
      [self.navigationController.navigationBar.layer addAnimation:fadeTextAnimation
                                                           forKey:@"fadeTextAnimation"];
      self.navigationItem.title = @"После";
      
      //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      
    }];
}

@end
