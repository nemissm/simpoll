//
//  NRPollView.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 07/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRPollView.h"
#import "UIColor+NRAppConfig.h"

@interface NRPollView ()

@property (strong, nonatomic) UIView *questionTitleView;
@property (strong, nonatomic) UIView *answerButtonsView;
@property (strong, nonatomic) UIView *answerResultsView;
@property (assign, nonatomic) NSUInteger numberOfAnswers;
@property (assign, nonatomic) NSUInteger longestAnswerTitleIndex;
@property (strong, nonatomic) NSMutableArray *answerVotesArray;

@end

@implementation NRPollView

// TODO: Replace to CGFloat type where needed
static NSUInteger const questionTitlePaddingLeft = 16;
static NSUInteger const questionTitlePaddingRight = 16;
static NSUInteger const questionTitlePaddingTop = 15;
static NSUInteger const questionTitlePaddingBottom = 15;
static NSUInteger const questionTitleFontSize = 14;

static NSUInteger const buttonPaddingLeft = 15;
static NSUInteger const buttonPaddingRight = 15;
static NSUInteger const buttonPaddingBetween = 10;
static NSUInteger const buttonPaddingBottom = 15;
// [UIImage imageNamed:@"answer-button-normal"].size.height
static NSUInteger const buttonHeight = 38;
static NSUInteger const buttonTitleFontSize = 17;
static NSUInteger const buttonTitlePaddingLeft = 13;

static NSUInteger const resultTitlePaddingLeft = 15;
static CGFloat    const resultTitleFontSize = 14.f;
static CGFloat    const resultTitleMaxWidthRatio = 0.3f;

static CGFloat    const votesBarPaddingLeft = 10.f;
static CGFloat    const votesBarMaxWidthRatio = 0.3f;
static CGFloat    const votesLabelPaddingLeft = 8.f;
static CGFloat    const votesLabelPaddingRight = 15.f;

static NSUInteger const resultPaddingBetween = 15;
static NSUInteger const resultPaddingBottom = 15;

// TODO: init without frame. Constraints on view controller
- (instancetype)initBelowNavigationBar {
  
  // Create transparent content view
  // {0, 64} - Point below navigation bar
  
  CGFloat contentViewWidth = [UIScreen mainScreen].bounds.size.width;
  CGFloat contentViewHeight = [UIScreen mainScreen].bounds.size.height - 64;
  
  self = [super initWithFrame:CGRectMake(0, 64, contentViewWidth, contentViewHeight)];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.longestAnswerTitleIndex = 0;
  }
  return self;
}

- (void)reload {
  
  // Return if there is no data source
  if (!self.dataSource)
    return;
  
  // Add question view
  self.questionTitleView = [[UIView alloc] init];
  self.questionTitleView.backgroundColor = [UIColor veryLightGrayColor];
  [self addSubview:self.questionTitleView];
  
  self.questionTitleView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Add question title
  NSString *questionTitleString = [self.dataSource titleForQuestionInPollView:self];
  
  UILabel *questionTitleLabel = [[UILabel alloc] init];
  questionTitleLabel.font = [UIFont systemFontOfSize:questionTitleFontSize];
  questionTitleLabel.textColor = [UIColor blackColor];
  questionTitleLabel.text = questionTitleString;
  questionTitleLabel.backgroundColor = [UIColor redColor];
  [questionTitleLabel sizeToFit];
  
  [self.questionTitleView addSubview:questionTitleLabel];
  
  questionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Constraints
  
  // questionTitleView position & width
  NSLayoutConstraint *questionTitleViewLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:self.questionTitleView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *questionTitleViewTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.questionTitleView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *questionTitleViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.questionTitleView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0];
  
  // questionTitleLabel position & size
  NSLayoutConstraint *questionTitleLabelLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:questionTitleLabel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.questionTitleView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:questionTitlePaddingLeft];
  
  NSLayoutConstraint *questionTitleLabelTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self.questionTitleView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:questionTitleLabel
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:questionTitlePaddingRight];
  
  NSLayoutConstraint *questionTitleLabelTopConstraint =
    [NSLayoutConstraint constraintWithItem:questionTitleLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.questionTitleView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:questionTitlePaddingTop];
  // questionTitleView height
  NSLayoutConstraint *questionTitleViewBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.questionTitleView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:questionTitleLabel
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:questionTitlePaddingBottom];
  
  [self addConstraint:questionTitleViewLeadingConstraint];
  [self addConstraint:questionTitleViewTrailingConstraint];
  [self addConstraint:questionTitleViewTopConstraint];
  
  [self.questionTitleView addConstraint:questionTitleLabelLeadingConstraint];
  [self.questionTitleView addConstraint:questionTitleLabelTrailingConstraint];
  [self.questionTitleView addConstraint:questionTitleLabelTopConstraint];
  [self.questionTitleView addConstraint:questionTitleViewBottomConstraint];
  
  // Add view with answer buttons
  self.answerButtonsView = [[UIView alloc] init];
  self.answerButtonsView.backgroundColor = [UIColor veryLightGrayColor];
  // answerButtonsView will slide up behind questionTitleView
  [self insertSubview:self.answerButtonsView belowSubview:self.questionTitleView];
  
  self.answerButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Constraints
  
  // answerButtonsView position & width
  NSLayoutConstraint *answerButtonsViewLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:self.answerButtonsView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *answerButtonsViewTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.answerButtonsView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *answerButtonsViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.answerButtonsView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.questionTitleView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
  
  [self addConstraint:answerButtonsViewLeadingConstraint];
  [self addConstraint:answerButtonsViewTrailingConstraint];
  [self addConstraint:answerButtonsViewTopConstraint];
  // We will set view height later, when buttons will be placed
  
  // Add view with answer results
  self.answerResultsView = [[UIView alloc] init];
  self.answerResultsView.backgroundColor = [UIColor veryLightGrayColor];
  // answerResultsView will lay behind answerButtonsView
  [self insertSubview:self.answerResultsView belowSubview:self.answerButtonsView];
  
  self.answerResultsView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Constraints
  
  // answerResultsView position & width
  NSLayoutConstraint *answerResultsViewLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:self.answerResultsView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *answerResultsViewTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.answerResultsView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *answerResultsViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.answerResultsView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.questionTitleView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
  
  [self addConstraint:answerResultsViewLeadingConstraint];
  [self addConstraint:answerResultsViewTrailingConstraint];
  [self addConstraint:answerResultsViewTopConstraint];
  // We will set view height later, when answer result titles will be placed
  
  // Get number of answers
  self.numberOfAnswers = [self.dataSource numberOfAnswersInPollView:self];
  
  // [2,7]
  if (self.numberOfAnswers < 2) {
    self.numberOfAnswers = 2;
  } else if (self.numberOfAnswers > 7) {
    self.numberOfAnswers = 7;
  }
  
  // For finding longestAnswerTitleIndex
  CGFloat longestAnswerTitleWidth = 0;
  
  // Add answer buttons & answer result titles
  for (NSUInteger i = 0; i <= self.numberOfAnswers - 1; i++) {
    // Answer buttons
    UIButton *answerButton = [self answerButton];
    answerButton.tag = i;
    answerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.answerButtonsView insertSubview:answerButton atIndex:i];
    
    // Constraints
    
    // Top constraint for the first button
    NSLayoutConstraint *answerButtonTopConstraint;
    if (i == 0) {
      answerButtonTopConstraint =
        [NSLayoutConstraint constraintWithItem:answerButton
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.answerButtonsView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0];
    } else {
      // Top constraint the other buttons
      answerButtonTopConstraint =
        [NSLayoutConstraint constraintWithItem:answerButton
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:[[self.answerButtonsView subviews] objectAtIndex:i - 1]
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:buttonPaddingBetween];
    }
    
    NSLayoutConstraint *answerButtonLeadingConstraint =
      [NSLayoutConstraint constraintWithItem:answerButton
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.answerButtonsView
                                   attribute:NSLayoutAttributeLeading
                                  multiplier:1.0
                                    constant:buttonPaddingLeft];
  
    NSLayoutConstraint *answerButtonTrailingConstraint =
      [NSLayoutConstraint constraintWithItem:self.answerButtonsView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:answerButton
                                   attribute:NSLayoutAttributeTrailing
                                  multiplier:1.0
                                    constant:buttonPaddingRight];
    
    NSLayoutConstraint *answerButtonHeightConstraint =
      [NSLayoutConstraint constraintWithItem:answerButton
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                    constant:buttonHeight];
    
    [self.answerButtonsView addConstraint:answerButtonTopConstraint];
    [self.answerButtonsView addConstraint:answerButtonLeadingConstraint];
    [self.answerButtonsView addConstraint:answerButtonTrailingConstraint];
    [answerButton addConstraint:answerButtonHeightConstraint];
    
    // answerButtonsView height
    NSLayoutConstraint *answerButtonsViewBottomConstraint;
    if (i == self.numberOfAnswers - 1) {
      answerButtonsViewBottomConstraint =
        [NSLayoutConstraint constraintWithItem:self.answerButtonsView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:answerButton
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:buttonPaddingBottom];
      [self.answerButtonsView addConstraint:answerButtonsViewBottomConstraint];
    }
    
    // Answer result titles
    
    NSString *answerResultTitleString = [self.dataSource pollView:self answerTitleAtIndex:i];
    
    // Find index of longest title - result bars will be aligned to the longest title
    CGSize answerResultTitleStringSize = [answerResultTitleString sizeWithAttributes:
      @{NSFontAttributeName: [UIFont systemFontOfSize:resultTitleFontSize]}];
    if (answerResultTitleStringSize.width > longestAnswerTitleWidth) {
      longestAnswerTitleWidth = answerResultTitleStringSize.width;
      self.longestAnswerTitleIndex = i;
    }
    // TODO: Rename testLabel
    UILabel *testLabel = [self answerResultLabel:answerResultTitleString
                                           color:[UIColor blackColor]];
    
    // Directly specify index, as we need access to titles for creating constraints for other elements
    [self.answerResultsView insertSubview:testLabel atIndex:i];
    
    testLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Constraints
    
    // Top constraint for the first result title
    NSLayoutConstraint *answerResultTitleTopConstraint;
    if (i == 0) {
      answerResultTitleTopConstraint =
        [NSLayoutConstraint constraintWithItem:testLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.answerResultsView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0];
    } else {
      // Top constraint the other result titles. Link with previous
      answerResultTitleTopConstraint =
        [NSLayoutConstraint constraintWithItem:testLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:[[self.answerResultsView subviews] objectAtIndex:i - 1]
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:resultPaddingBetween];
    }
    
    NSLayoutConstraint *answerResultTitleLeadingConstraint =
      [NSLayoutConstraint constraintWithItem:testLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.answerResultsView
                                   attribute:NSLayoutAttributeLeading
                                  multiplier:1.0
                                    constant:resultTitlePaddingLeft];

    // Constraint for max answer title width
    NSLayoutConstraint *answerResultTitleMaxWidthConstraint =
      [NSLayoutConstraint constraintWithItem:testLabel
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:self.answerResultsView
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:resultTitleMaxWidthRatio
                                    constant:0];
    
    [self.answerResultsView addConstraint:answerResultTitleTopConstraint];
    [self.answerResultsView addConstraint:answerResultTitleLeadingConstraint];
    [self.answerResultsView addConstraint:answerResultTitleMaxWidthConstraint];
    
    // TODO: add note after all answers
    // answerResultsView height
    if (i == self.numberOfAnswers - 1) {
      NSLayoutConstraint *answerButtonsViewBottomConstraint =
        [NSLayoutConstraint constraintWithItem:self.answerResultsView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:testLabel
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:resultPaddingBottom];
      [self.answerResultsView addConstraint:answerButtonsViewBottomConstraint];
    }
  }
}

- (void)showResults {
  
  // Add votes bar & count
  for (NSUInteger i = 0; i <= self.numberOfAnswers - 1; i++) {
    // Get answer votes from delegate
    NRAnswerVotes *answerVotes = [self.dataSource pollView:self answerVotesAtIndex:i];
    
    // Add votes bar
    UIView *answerVotesBar = [[UIView alloc] init];
    answerVotesBar.backgroundColor = [UIColor darkGrayColor];
    
    [self.answerResultsView addSubview:answerVotesBar];
    
    answerVotesBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Constraints
    
    // Link with answer titles top position
    NSLayoutConstraint *answerVotesBarTopConstraint =
        [NSLayoutConstraint constraintWithItem:answerVotesBar
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:[[self.answerResultsView subviews] objectAtIndex:i]
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0];
    
    // Link with longest answer title
    NSLayoutConstraint *answerVotesBarLeadingConstraint =
      [NSLayoutConstraint constraintWithItem:answerVotesBar
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:[[self.answerResultsView subviews] objectAtIndex:self.longestAnswerTitleIndex]
                                   attribute:NSLayoutAttributeTrailing
                                  multiplier:1.0
                                    constant:votesBarPaddingLeft];
  
    NSLayoutConstraint *answerVotesBarHeightConstraint =
      [NSLayoutConstraint constraintWithItem:answerVotesBar
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:[[self.answerResultsView subviews] objectAtIndex:i]
                                   attribute:NSLayoutAttributeHeight
                                  multiplier:1.0
                                    constant:0];

    // Constraint for answerVotesBar width
    NSLayoutConstraint *answerVotesBarWidthConstraint =
      [NSLayoutConstraint constraintWithItem:answerVotesBar
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.answerResultsView
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:(votesBarMaxWidthRatio * answerVotes.share)
                                    constant:0];
    
    [self.answerResultsView addConstraint:answerVotesBarTopConstraint];
    [self.answerResultsView addConstraint:answerVotesBarLeadingConstraint];
    [self.answerResultsView addConstraint:answerVotesBarHeightConstraint];
    [self.answerResultsView addConstraint:answerVotesBarWidthConstraint];
    
    // Add votes label
    
    NSString *answerVotesString = [NSString stringWithFormat:@"%ld (%.f%%)",
      (unsigned long)answerVotes.count, roundf((answerVotes.share * 100))];
    
    UILabel *answerVotesLabel = [self answerResultLabel:answerVotesString
                                                  color:[UIColor darkGrayColor]];
    
    [self.answerResultsView addSubview:answerVotesLabel];
    
    answerVotesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Constraints
    
    // Link with answer titles top position
    NSLayoutConstraint *answerVotesLabelTopConstraint =
        [NSLayoutConstraint constraintWithItem:answerVotesLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:[[self.answerResultsView subviews] objectAtIndex:i]
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0];
    
    // Link with answerVotesBar
    NSLayoutConstraint *answerVotesLabelLeadingConstraint =
      [NSLayoutConstraint constraintWithItem:answerVotesLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:answerVotesBar
                                   attribute:NSLayoutAttributeTrailing
                                  multiplier:1.0
                                    constant:votesLabelPaddingLeft];
  

    // The rest of space is for answerVotesLabel width
    NSLayoutConstraint *answerVotesLabelTrailingConstraint =
      [NSLayoutConstraint constraintWithItem:self.answerResultsView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                      toItem:answerVotesLabel
                                   attribute:NSLayoutAttributeTrailing
                                  multiplier:1.0
                                    constant:votesLabelPaddingRight];
    
    [self.answerResultsView addConstraint:answerVotesLabelTopConstraint];
    [self.answerResultsView addConstraint:answerVotesLabelLeadingConstraint];
    [self.answerResultsView addConstraint:answerVotesLabelTrailingConstraint];
  }
  
  // Hide answerButtonsView
  CGRect answerButtonsViewHiddenFrame = self.answerButtonsView.frame;
  answerButtonsViewHiddenFrame.origin.y =
    answerButtonsViewHiddenFrame.origin.y - answerButtonsViewHiddenFrame.size.height;
  
  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
    animations:^{
      self.answerButtonsView.frame = answerButtonsViewHiddenFrame;
    }
    completion:^(BOOL finished) {

    }];
}

// TODO: Add title
// TODO: Maybe move to category
- (UIButton *)answerButton {
  
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *answerButtonNormalImage = [UIImage imageNamed:@"answer-button-normal"];
  UIImage *answerButtonHighlightedImage = [UIImage imageNamed:@"answer-button-highlighted"];
  
  // One pixel stretching zone
  // Faster performance as described in docs:
  // developer.apple.com/library/ios/documentation/UIKit/Reference/UIImage_Class/#//apple_ref/occ/instm/UIImage/resizableImageWithCapInsets:
  CGFloat answerButtonImageMiddle = (answerButtonNormalImage.size.width - 1) / 2;
  CGFloat answerButtonLeftEdgeInset = floorf(answerButtonImageMiddle);
  CGFloat answerButtonRightEdgeInset = ceilf(answerButtonImageMiddle);
  
  UIEdgeInsets answerButtonImageEdgeInsets =
    UIEdgeInsetsMake(0, answerButtonLeftEdgeInset, 0, answerButtonRightEdgeInset);
  
  [answerButton setBackgroundImage:[answerButtonNormalImage resizableImageWithCapInsets:answerButtonImageEdgeInsets]
                          forState:UIControlStateNormal];
  [answerButton setBackgroundImage:[answerButtonHighlightedImage resizableImageWithCapInsets:answerButtonImageEdgeInsets]
                          forState:UIControlStateHighlighted];
  //testButton.backgroundColor = [UIColor redColor];
  [answerButton addTarget:self
                 action:@selector(buttonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
  
  return answerButton;
}

- (UILabel *)answerResultLabel:(NSString *)text  color:(UIColor *)color {
  
  UILabel *answerResultTitleLabel = [[UILabel alloc] init];
  answerResultTitleLabel.font = [UIFont systemFontOfSize:resultTitleFontSize];
  answerResultTitleLabel.textColor = color;
  answerResultTitleLabel.text = text;
  answerResultTitleLabel.backgroundColor = [UIColor redColor];
  [answerResultTitleLabel sizeToFit];
  
  return answerResultTitleLabel;
}

- (void)buttonClicked:(UIButton *)answerButton {
  NSLog(@"Pressed %ld", (long)answerButton.tag);
  NSLog(@"self.answerButtonsView.frame: %@", NSStringFromCGRect(self.answerButtonsView.frame));
  if (!self.delegate)
    return;
  
  [self.delegate pollView:self clickedAnswerButtonAtIndex:answerButton.tag];
}

- (void)didMoveToSuperview {
  [self reload];
}

@end
