//
//  NRPollView.m
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

#import "NRPollView.h"
#import "UIColor+NRAppConfig.h"

@interface NRPollView ()

@property (strong, nonatomic) UIView *questionTitleView;
@property (strong, nonatomic) UILabel *questionTitleLabel;
@property (strong, nonatomic) UIView *answerButtonsView;
@property (strong, nonatomic) UIView *answerResultsView;
@property (assign, nonatomic) NSUInteger numberOfAnswers;
@property (strong, nonatomic) NSMutableArray *answerVotesArray;

@end

@implementation NRPollView {
  NSLayoutConstraint *_answerButtonsViewTopConstraint;
}


static CGFloat const questionTitlePaddingLeft = 16.f;
static CGFloat const questionTitlePaddingRight = 16.f;
static CGFloat const questionTitlePaddingTop = 15.f;
static CGFloat const questionTitlePaddingBottom = 15.f;
static CGFloat const questionTitleFontSize = 14.f;

static CGFloat const buttonPaddingLeft = 15.f;
static CGFloat const buttonPaddingRight = 15.f;
static CGFloat const buttonPaddingBetween = 10.f;
static CGFloat const buttonPaddingBottom = 15.f;
// [UIImage imageNamed:@"answer-button-normal"].size.height
static CGFloat const buttonHeight = 38.f;
static CGFloat const buttonTitleFontSize = 17.f;
static CGFloat const buttonTitlePaddingLeft = 13.f;

static CGFloat const resultFontSize = 14.f;
static CGFloat const resultTitlePaddingLeft = 15.f;
static CGFloat const resultTitleMaxWidthRatio = 0.3f;

static CGFloat const votesBarPaddingLeft = 10.f;
static CGFloat const votesBarMaxWidthRatio = 0.3f;
static CGFloat const votesLabelPaddingLeft = 8.f;
static CGFloat const votesLabelPaddingRight = 15.f;

static CGFloat const resultPaddingBetween = 15.f;
static CGFloat const resultPaddingBottom = 15.f;

static NSString *const bottomSignString = @"(ваш голос уже принят)";
static CGFloat const bottomSignLabelFontSize = 12.f;
static CGFloat const bottomSignLabelPaddingTop = 19.f;

#pragma mark - UI

- (void)reload {
  
  // Return if there is no data source
  if (!self.dataSource)
    return;
  
  // Remove all subviews
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
  // Add question view
  self.questionTitleView = [[UIView alloc] init];
  self.questionTitleView.backgroundColor = [UIColor veryLightGrayColor];
  [self addSubview:self.questionTitleView];
  
  self.questionTitleView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Add question title
  NSString *questionTitleString = [self.dataSource titleForQuestionInPollView:self];
  
  self.questionTitleLabel = [self pollViewLabel:questionTitleString
                                          color:[UIColor blackColor]
                                       fontSize:questionTitleFontSize];
  
  [self.questionTitleView addSubview:self.questionTitleLabel];
  
  self.questionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
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
    [NSLayoutConstraint constraintWithItem:self.questionTitleLabel
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
                                    toItem:self.questionTitleLabel
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:questionTitlePaddingRight];
  
  NSLayoutConstraint *questionTitleLabelTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.questionTitleLabel
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
                                    toItem:self.questionTitleLabel
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
  
  // Keep it for animation
  _answerButtonsViewTopConstraint = answerButtonsViewTopConstraint;
  
  [self addConstraint:answerButtonsViewLeadingConstraint];
  [self addConstraint:answerButtonsViewTrailingConstraint];
  [self addConstraint:answerButtonsViewTopConstraint];
  // We will set view height later, when buttons will be placed
  
  // Get number of answers
  self.numberOfAnswers = [self.dataSource numberOfAnswersInPollView:self];
  
  // [2,7]
  if (self.numberOfAnswers < 2) {
    self.numberOfAnswers = 2;
  } else if (self.numberOfAnswers > 7) {
    self.numberOfAnswers = 7;
  }
  
  // Add answer buttons & answer result titles
  for (NSUInteger i = 0; i <= self.numberOfAnswers - 1; i++) {
    // Answer buttons
    NSString *answerButtonTitleString = [self.dataSource pollView:self answerTitleAtIndex:i];
    UIButton *answerButton = [self answerButtonWithTitle:answerButtonTitleString];
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
    if (i == self.numberOfAnswers - 1) {
      NSLayoutConstraint *answerButtonsViewBottomConstraint =
        [NSLayoutConstraint constraintWithItem:self.answerButtonsView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:answerButton
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:buttonPaddingBottom];
      [self.answerButtonsView addConstraint:answerButtonsViewBottomConstraint];
    }
  }
  
  // Add constraint for height of self
  // Other constraints must be configured in delegate!
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSLayoutConstraint *selfBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.answerButtonsView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
  [self addConstraint:selfBottomConstraint];
}

- (void)showResultsWithAnimatedTransition:(BOOL)isAnimatedTransition {
  
  // Clear previous
  [self.answerResultsView removeFromSuperview];
  
  // Update questionTitleLabel
  self.questionTitleLabel.text = [self.dataSource titleForQuestionInPollView:self];
  
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
  
  // Get number of answers. We can't use value assigned in -reload, because
  // sometimes -showResults invoked with different number of answers
  self.numberOfAnswers = [self.dataSource numberOfAnswersInPollView:self];
  
  // [2,7]
  if (self.numberOfAnswers < 2) {
    self.numberOfAnswers = 2;
  } else if (self.numberOfAnswers > 7) {
    self.numberOfAnswers = 7;
  }
  
  // Separate loop required for finding longestAnswerTitleIndex
  CGFloat longestAnswerTitleWidth = 0;
  NSUInteger longestAnswerTitleIndex = 0;
  
  for (NSUInteger i = 0; i <= self.numberOfAnswers - 1; i++) {
    
    // Answer result titles
    NSString *answerResultTitleString = [self.dataSource pollView:self answerTitleAtIndex:i];
    
    // Find index of longest title - result bars will be aligned to the longest title
    CGSize answerResultTitleStringSize = [answerResultTitleString sizeWithAttributes:
      @{NSFontAttributeName: [UIFont systemFontOfSize:resultFontSize]}];
    
    if (answerResultTitleStringSize.width > longestAnswerTitleWidth) {
      longestAnswerTitleWidth = answerResultTitleStringSize.width;
      longestAnswerTitleIndex = i;
    }

    UILabel *answerResultTitleLabel = [self pollViewLabel:answerResultTitleString
                                                    color:[UIColor blackColor]
                                                 fontSize:resultFontSize];
    
    // Directly specify index, as we need access to titles for creating constraints for other elements
    [self.answerResultsView insertSubview:answerResultTitleLabel atIndex:i];
    
    answerResultTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Constraints
    
    // Top constraint for the first result title
    NSLayoutConstraint *answerResultTitleTopConstraint;
    if (i == 0) {
      answerResultTitleTopConstraint =
        [NSLayoutConstraint constraintWithItem:answerResultTitleLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.answerResultsView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0];
    } else {
      // Top constraint the other result titles. Link with previous
      answerResultTitleTopConstraint =
        [NSLayoutConstraint constraintWithItem:answerResultTitleLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:[[self.answerResultsView subviews] objectAtIndex:i - 1]
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:resultPaddingBetween];
    }
    
    NSLayoutConstraint *answerResultTitleLeadingConstraint =
      [NSLayoutConstraint constraintWithItem:answerResultTitleLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.answerResultsView
                                   attribute:NSLayoutAttributeLeading
                                  multiplier:1.0
                                    constant:resultTitlePaddingLeft];

    // Constraint for max answer title width
    NSLayoutConstraint *answerResultTitleMaxWidthConstraint =
      [NSLayoutConstraint constraintWithItem:answerResultTitleLabel
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:self.answerResultsView
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:resultTitleMaxWidthRatio
                                    constant:0];
    
    [self.answerResultsView addConstraint:answerResultTitleTopConstraint];
    [self.answerResultsView addConstraint:answerResultTitleLeadingConstraint];
    [self.answerResultsView addConstraint:answerResultTitleMaxWidthConstraint];
    
    // Last iteration
    if (i == self.numberOfAnswers - 1) {
      
      // Add bottom sign after all answers
      UILabel *bottomSignLabel = [self pollViewLabel:bottomSignString
                                               color:[UIColor lightGrayColor]
                                            fontSize:bottomSignLabelFontSize];
      [self.answerResultsView addSubview:bottomSignLabel];
    
      bottomSignLabel.translatesAutoresizingMaskIntoConstraints = NO;
      
      // Constraints
      
      NSLayoutConstraint *bottomSignLabelTopConstraint =
        [NSLayoutConstraint constraintWithItem:bottomSignLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:answerResultTitleLabel
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:bottomSignLabelPaddingTop];
      
      NSLayoutConstraint *bottomSignLabelLeadingConstraint =
        [NSLayoutConstraint constraintWithItem:bottomSignLabel
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:answerResultTitleLabel
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:0];
      
      [self.answerResultsView addConstraint:bottomSignLabelTopConstraint];
      [self.answerResultsView addConstraint:bottomSignLabelLeadingConstraint];
      
      // Constraint for answerResultsView height
      NSLayoutConstraint *answerResultsViewBottomConstraint =
        [NSLayoutConstraint constraintWithItem:self.answerResultsView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:bottomSignLabel
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:resultPaddingBottom];
      [self.answerResultsView addConstraint:answerResultsViewBottomConstraint];
    }
  }
  
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
                                      toItem:[[self.answerResultsView subviews] objectAtIndex:longestAnswerTitleIndex]
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
    
    UILabel *answerVotesLabel = [self pollViewLabel:answerVotesString
                                              color:[UIColor darkGrayColor]
                                           fontSize:resultFontSize];
    
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
  CGFloat answerButtonsViewHiddenTop = -self.answerButtonsView.bounds.size.height;
  _answerButtonsViewTopConstraint.constant = answerButtonsViewHiddenTop;
  
  if (isAnimatedTransition) {
    [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
    animations:^{
      [self layoutIfNeeded];
    }
    completion:^(BOOL finished) {

    }];
  } else {
    [self layoutIfNeeded];
  }
}

#pragma mark - Elements

- (UILabel *)pollViewLabel:(NSString *)text
                     color:(UIColor *)color
                  fontSize:(CGFloat)fontSize {
  
  UILabel *pollViewLabel = [[UILabel alloc] init];
  pollViewLabel.font = [UIFont systemFontOfSize:fontSize];
  pollViewLabel.textColor = color;
  pollViewLabel.text = text;
  [pollViewLabel sizeToFit];
  
  // For long width-constrained labels
  pollViewLabel.minimumScaleFactor = 8. / pollViewLabel.font.pointSize;
  pollViewLabel.adjustsFontSizeToFitWidth = YES;
  
  return pollViewLabel;
}

- (UIButton *)answerButtonWithTitle:(NSString *)title {
  
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

  [answerButton addTarget:self
                   action:@selector(buttonPushedDown:)
         forControlEvents:UIControlEventTouchDown];
  [answerButton addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
  
  // Add answer title
  UILabel *answerButtonTitleLabel = [self pollViewLabel:title
                                                  color:[UIColor blackColor]
                                               fontSize:buttonTitleFontSize];
  [answerButton addSubview:answerButtonTitleLabel];
  
  answerButtonTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Constraints
  NSLayoutConstraint *answerButtonTitleLabelCenterConstraint =
      [NSLayoutConstraint constraintWithItem:answerButtonTitleLabel
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:answerButton
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                    constant:0];
  
  NSLayoutConstraint *answerButtonTitleLabelLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:answerButtonTitleLabel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:answerButton
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:buttonTitlePaddingLeft];
  
  [answerButton addConstraint:answerButtonTitleLabelCenterConstraint];
  [answerButton addConstraint:answerButtonTitleLabelLeadingConstraint];
  
  return answerButton;
}

// First
- (void)buttonPushedDown:(UIButton *)answerButton {

  // Make a little offset for answerButtonTitleLabel when button pushed
  for (NSLayoutConstraint *answerButtonConstraint in answerButton.constraints) {
    // Find constraints with label - this is the only answerButtonTitleLabel constraints
    if ([answerButtonConstraint.firstItem isKindOfClass:[UILabel class]]) {
      answerButtonConstraint.constant += 1;
    }
  }

  [answerButton layoutIfNeeded];
}

// Second
- (void)buttonClicked:(UIButton *)answerButton {
  
  // Return answerButtonTitleLabel at initial position
  for (NSLayoutConstraint *answerButtonConstraint in answerButton.constraints) {
    // Find constraints with label - this is the only answerButtonTitleLabel constraints
    if ([answerButtonConstraint.firstItem isKindOfClass:[UILabel class]]) {
      answerButtonConstraint.constant -= 1;
    }
  }

  [answerButton layoutIfNeeded];
  
  if (!self.delegate)
    return;
  
  [self.delegate pollView:self clickedAnswerButtonAtIndex:answerButton.tag];
}

#pragma mark - UIViewHierarchy

- (void)didMoveToSuperview {
  [self reload];
}

@end
