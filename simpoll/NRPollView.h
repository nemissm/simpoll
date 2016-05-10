//
//  NRPollView.h
//  simpoll
//
//  Created by Mikhail Naryshkin on 07/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRAnswerVotes.h"

@protocol NRPollViewDataSource;
@protocol NRPollViewDelegate;

@interface NRPollView : UIView

@property (weak, nonatomic) id <NRPollViewDataSource> dataSource;
@property (weak, nonatomic) id <NRPollViewDelegate> delegate;

- (instancetype)initBelowNavigationBar;
- (void)reload;
- (void)showResults;
@end

@protocol NRPollViewDataSource <NSObject>
@required

// Question
- (NSString *)titleForQuestionInPollView:(NRPollView *)pollView;
// Answers. Minimal answer number - 2, maximum - 7

- (NSUInteger)numberOfAnswersInPollView:(NRPollView *)pollView;
- (NSString *)pollView:(NRPollView *)pollView answerTitleAtIndex:(NSUInteger)index;
- (NRAnswerVotes *)pollView:(NRPollView *)pollView answerVotesAtIndex:(NSUInteger)index;
@end

@protocol NRPollViewDelegate <NSObject>
@required

// Inform the delegate what answer has been chosen
- (void)pollView:(NRPollView *)pollView clickedAnswerButtonAtIndex:(NSUInteger)index;
@end

// UITableView