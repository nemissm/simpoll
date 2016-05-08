//
//  NRPollView.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 07/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRPollView.h"
#import "UIColor+NRAppConfig.h"

@implementation NRPollView

static NSUInteger const paddingTop = 15;

static NSUInteger const questionTitlePaddingLeft = 16;
static NSUInteger const questionTitleFontSize = 14;

static NSUInteger const answerPaddingLeft = 15;

static NSUInteger const buttonPaddingBetween = 10;
static NSUInteger const buttonPaddingBottom = 15;
static NSUInteger const buttonHeight = 36;
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
  
  // Baisic view is a question with background
  
  // Calculate space for label
  // TODO: Find out, is it possible to calculate height on constraints
  CGSize questionTitleSize = [@"" sizeWithAttributes:
    @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
  CGFloat viewHeight = questionTitleSize.height + paddingTop * 2;
  
  self = [super initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, viewHeight)];
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor veryLightGrayColor];
  }
  return self;
}

- (void)reload {
  
  // Return if there is no data source
  if (!self.dataSource)
    return;
  
  // Add Question
  NSString *questionTitleString = [self.dataSource titleForQuestionInPollView:self];
  
  UILabel *questionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  questionTitleLabel.font = [UIFont systemFontOfSize:questionTitleFontSize];
  questionTitleLabel.textColor = [UIColor blackColor];
  questionTitleLabel.text = questionTitleString;
  questionTitleLabel.backgroundColor = [UIColor redColor];
  [questionTitleLabel sizeToFit];
  
  [self addSubview:questionTitleLabel];
  
  questionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
//  NSLayoutConstraint *questionTitleLabelWidthConstraint =
//    [NSLayoutConstraint constraintWithItem:questionTitleLabel
//                                 attribute:NSLayoutAttributeWidth
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:self
//                                 attribute:NSLayoutAttributeWidth
//                                multiplier:1.0
//                                  constant:0];
//  
//  NSLayoutConstraint *questionTitleLabelHeightConstraint =
//    [NSLayoutConstraint constraintWithItem:questionTitleLabel
//                                 attribute:NSLayoutAttributeHeight
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:self
//                                 attribute:NSLayoutAttributeHeight
//                                multiplier:1.0
//                                  constant:0];
  
  NSLayoutConstraint *questionTitleLabelLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:questionTitleLabel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:questionTitlePaddingLeft];
  
  NSLayoutConstraint *questionTitleLabelTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:questionTitleLabel
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:questionTitlePaddingLeft];
  
  NSLayoutConstraint *questionTitleLabelYConstraint =
    [NSLayoutConstraint constraintWithItem:questionTitleLabel
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0];
  
//  [self addConstraint:questionTitleLabelWidthConstraint];
//  [self addConstraint:questionTitleLabelHeightConstraint];
  [self addConstraint:questionTitleLabelLeadingConstraint];
  [self addConstraint:questionTitleLabelTrailingConstraint];
  [self addConstraint:questionTitleLabelYConstraint];
  
  // Add view with answer buttons
  NSUInteger numberOfAnswers = 3;
  CGFloat answerButtonsViewHeight = (buttonHeight * numberOfAnswers) +
    (buttonPaddingBetween * (numberOfAnswers - 1)) + buttonPaddingBottom;
  
  UIView *answerButtonsView = [[UIView alloc]
    initWithFrame:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width, answerButtonsViewHeight)];
  answerButtonsView.backgroundColor = [UIColor veryLightGrayColor];
  
  UIButton *testButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [testButton setTitle:@"Calibration" forState:UIControlStateNormal];
  testButton.frame = CGRectMake(0, 0, 100, 50);
  
  [answerButtonsView addSubview:testButton];
  
  for (NSUInteger i = 0; i < numberOfAnswers; i++) {
    
  }
  
  
  [self addSubview:answerButtonsView];
  
}

- (void)didMoveToSuperview {
    [self reload];
}

@end
