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

@end

@implementation NRPollView

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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initBelowNavigationBar {
  
  // Create transparent content view
  // {0, 64} - Point below navigation bar
  
  CGFloat contentViewWidth = [UIScreen mainScreen].bounds.size.width;
  CGFloat contentViewHeight = [UIScreen mainScreen].bounds.size.height - 64;
  
  self = [super initWithFrame:CGRectMake(0, 64, contentViewWidth, contentViewHeight)];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
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
  [self addSubview:self.answerButtonsView];
  
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
  
  // Add answer buttons

  NSUInteger numberOfAnswers = [self.dataSource numberOfAnswersInPollView:self];
  
  // [2,7]
  if (numberOfAnswers < 2) {
    numberOfAnswers = 2;
  } else if (numberOfAnswers > 7) {
    numberOfAnswers = 7;
  }
  
  for (NSUInteger i = 0; i <= numberOfAnswers - 1; i++) {
    //break;
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
    if (i == numberOfAnswers - 1) {
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
  }
}

// TODO: Add title
- (UIButton *)answerButton {
  
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *answerButtonNormalImage = [UIImage imageNamed:@"answer-button-normal"];
  UIImage *answerButtonHighlightedImage = [UIImage imageNamed:@"answer-button-highlighted"];
  
  // One pixel stretching zone
  // Faster performance as described in docs:
  // developer.apple.com/library/ios/documentation/UIKit/Reference/UIImage_Class/#//apple_ref/occ/instm/UIImage/resizableImageWithCapInsets:
  CGFloat answerButtonMiddle = (answerButtonNormalImage.size.width - 1) / 2;
  CGFloat answerButtonLeftEdgeInset = floorf(answerButtonMiddle);
  CGFloat answerButtonRightEdgeInset = ceilf(answerButtonMiddle);
  
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

- (void)buttonClicked:(UIButton *)answerButton {
  NSLog(@"Pressed %ld", (long)answerButton.tag);
  NSLog(@"self.answerButtonsView.frame: %@", NSStringFromCGRect(self.answerButtonsView.frame));
  if (!self.delegate)
    return;
  
  [self.delegate pollView:self clickedAnswerButtonAtIndex:answerButton.tag];
}

- (void)showResults {
  
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

- (void)didMoveToSuperview {
    [self reload];
}

@end
