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
  
  // Add Question view
  self.questionTitleView = [[UIView alloc] init];
  self.questionTitleView.backgroundColor = [UIColor veryLightGrayColor];
  [self addSubview:self.questionTitleView];
  
  self.questionTitleView.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Add Question title
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
  
  // questionTitleView position
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
  // questionTitleView size
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
  NSUInteger numberOfAnswers = 3;
  CGFloat answerButtonsViewHeight = (buttonHeight * numberOfAnswers) +
    (buttonPaddingBetween * (numberOfAnswers - 1)) + buttonPaddingBottom;
  
  UIView *answerButtonsView = [[UIView alloc]
    initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, answerButtonsViewHeight)];
  answerButtonsView.backgroundColor = [UIColor veryLightGrayColor];
  
  UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
  //UIButton *testButton = [[UIButton alloc] init];
  
//  [testButton setTitle:@"Calibration" forState:UIControlStateNormal];
  UIImage *testButtonNormalImage = [UIImage imageNamed:@"answer-button-normal"];
  UIImage *testButtonHighlightedImage = [UIImage imageNamed:@"answer-button-highlighted"];
  //testButton.frame = CGRectMake(0, 0, 100, testButtonNormalImage.size.height);
  
  // One pixel stretching zone
  CGFloat testButtonLeftEdgeInset = floorf(testButtonNormalImage.size.width / 2) - 1;
  CGFloat testButtonRightEdgeInset = ceilf(testButtonNormalImage.size.width / 2);
  
  UIEdgeInsets testButtonImageEdgeInsets =
    UIEdgeInsetsMake(0, testButtonLeftEdgeInset, 0, testButtonRightEdgeInset);
  
  [testButton setBackgroundImage:[testButtonNormalImage resizableImageWithCapInsets:testButtonImageEdgeInsets]
                        forState:UIControlStateNormal];
  [testButton setBackgroundImage:[testButtonHighlightedImage resizableImageWithCapInsets:testButtonImageEdgeInsets]
                        forState:UIControlStateHighlighted];
  //testButton.backgroundColor = [UIColor redColor];
  [testButton addTarget:self
                 action:@selector(goPreviousViewController)
       forControlEvents:UIControlEventTouchUpInside];
  
  [answerButtonsView addSubview:testButton];

//  UIImageView *testImgView = [[UIImageView alloc] initWithImage:[testButtonNormalImage resizableImageWithCapInsets:testButtonNormalImageEdgeInsets]];
//  testImgView.frame = CGRectMake(0, 0, 100, testButtonNormalImage.size.height);
//  [answerButtonsView addSubview:testImgView];
  CGFloat testButtonHeight = testButtonNormalImage.size.height;
  
  testButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSLayoutConstraint *testButtonTopConstraint =
    [NSLayoutConstraint constraintWithItem:testButton
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:answerButtonsView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0];
  
  NSLayoutConstraint *testButtonHeightConstraint =
    [NSLayoutConstraint constraintWithItem:testButton
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:testButtonHeight];
  
  NSLayoutConstraint *testButtonLeadingConstraint =
    [NSLayoutConstraint constraintWithItem:testButton
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:answerButtonsView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:buttonPaddingLeft];
  
  NSLayoutConstraint *testButtonTrailingConstraint =
    [NSLayoutConstraint constraintWithItem:answerButtonsView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:testButton
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:buttonPaddingRight];
  
  [answerButtonsView addConstraint:testButtonTopConstraint];
  [answerButtonsView addConstraint:testButtonHeightConstraint];
  [answerButtonsView addConstraint:testButtonLeadingConstraint];
  [answerButtonsView addConstraint:testButtonTrailingConstraint];

  for (NSUInteger i = 0; i < numberOfAnswers; i++) {
    
  }
  
  
  [self addSubview:answerButtonsView];
  
  
}

- (void)goPreviousViewController {
  NSLog(@"Pressed");
}

- (void)didMoveToSuperview {
    [self reload];
}

@end
