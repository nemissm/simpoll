//
//  NRPollViewController.m
//  simpoll
//
//  Copyright (c) 2016 Mikhail Naryshkin <nemissm@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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

@property (strong, nonatomic) NSMutableArray *answeredQuestions;

@end

@implementation NRPollViewController

static NSInteger const questionsCount = 6;
static CGFloat const questionPickerViewHeight = 50;

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.navigationItem.title = @"До";
  
  self.questionIndex = 0;
  self.answeredQuestions = [NSMutableArray array];
  // Data manager;
  self.dataManager = [NRDataManager sharedManager];
  
  // Get data
  [self loadData];
  
  // Initialize poll view
  self.pollView = [[NRPollView alloc] init];
  self.pollView.dataSource = self;
  self.pollView.delegate = self;
  [self.view  addSubview:self.pollView];
  
  self.pollView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Constraints
  
  // pollView position & width
  NSLayoutConstraint *pollViewLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:self.pollView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *pollViewViewTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self.pollView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *pollViewViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.pollView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.topLayoutGuide
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
  
  
  // Height pollView constraint configured inside pollView implementation
  // It always fits to background view with answer buttons
  
  [self.view addConstraint:pollViewLeadingConstraint];
  [self.view addConstraint:pollViewViewTrailingConstraint];
  [self.view addConstraint:pollViewViewTopConstraint];
  
  // Add picker view
  UIPickerView *questionPickerView = [UIPickerView new];
  questionPickerView.dataSource = self;
  questionPickerView.delegate = self;
  
  [self.view  addSubview:questionPickerView];
  
  questionPickerView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Constraints
  NSLayoutConstraint *questionPickerViewLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:questionPickerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *questionPickerViewTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:questionPickerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *questionPickerViewHeightConstraint =
    [NSLayoutConstraint constraintWithItem:questionPickerView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:questionPickerViewHeight];
  
  NSLayoutConstraint *questionPickerViewBottomConstraint =
    [NSLayoutConstraint constraintWithItem:questionPickerView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
  
  [self.view addConstraint:questionPickerViewLeadingConstraint];
  [self.view addConstraint:questionPickerViewTrailingConstraint];
  [self.view addConstraint:questionPickerViewHeightConstraint];
  [self.view addConstraint:questionPickerViewBottomConstraint];
}

#pragma mark - API Interaction

- (void)loadData {
  self.questionTitle = [self.dataManager
    getTitleForQuestionAtIndex:self.questionIndex];
  self.answerTitlesArray = [self.dataManager
    getAnswerTitlesForQuestionAtIndex:self.questionIndex];
}

#pragma mark - <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {
  
  return questionsCount;
}

#pragma mark - <UIPickerViewDelegate>

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {

  return [NSString stringWithFormat:@"Вопрос %ld", (long)row + 1];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  
  self.questionIndex = row;
  [self loadData];
  
  // Check if question has already been answered
  if ([self.answeredQuestions containsObject:[NSNumber numberWithUnsignedInteger:self.questionIndex]]) {
    self.answerVotesArray = [self.dataManager getAnswerVotesForQuestionAtIndex:row];
    [self.pollView showResultsWithAnimatedTransition:NO];
    self.navigationItem.title = @"После";
    
    return;
  }
  // Else load question
  [self.pollView reload];
  self.navigationItem.title = @"До";
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
  
  // To be properly centered HUD added to self.navigationController.view instead of self.view
  [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  
  [self.dataManager voteForAnswerAtIndex:index
                         questionAtIndex:self.questionIndex
    completion:^(NSArray *answerVotesArray) {
      self.answerVotesArray = answerVotesArray;
      [self.pollView showResultsWithAnimatedTransition:YES];
    
      CATransition *fadeTextAnimation = [CATransition animation];
      fadeTextAnimation.duration = 0.3;
      fadeTextAnimation.type = kCATransitionFade;
      [self.navigationController.navigationBar.layer addAnimation:fadeTextAnimation
                                                           forKey:@"fadeTextAnimation"];
      self.navigationItem.title = @"После";
      
      // Remember index of answered question
      [self.answeredQuestions addObject:[NSNumber numberWithUnsignedInteger:self.questionIndex]];
      
      [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
      
    }];
}
@end
