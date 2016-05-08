//
//  NRPollView.h
//  simpoll
//
//  Created by Mikhail Naryshkin on 07/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NRPollViewDataSource;

@interface NRPollView : UIView

@property (weak, nonatomic) id <NRPollViewDataSource> dataSource;

- (instancetype)initBelowNavigationBar;
- (void)reload;
@end

@protocol NRPollViewDataSource <NSObject>

@required

// Question
- (NSString *)titleForQuestionInPollView:(NRPollView *)pollView;
// Answers. Minimal answer number - 2, maximum - 7

//- (NSUInteger)numberOfAnswersInPollView:(NRPollView *)pollView;
//- (NSString *)pollView:(NRPollView *)pollView titileForAnswerAtIndex:(NSUInteger)index;
//- (NSUInteger)pollView:(NRPollView *)pollView numberOfExistingVotesAtIndex:(NSUInteger)index;


@end

// UITableView