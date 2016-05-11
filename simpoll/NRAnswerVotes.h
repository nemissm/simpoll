//
//  NRAnswerVotes.h
//  simpoll
//
//  Created by Mikhail Naryshkin on 10/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@interface NRAnswerVotes : NSObject

// Answer index
@property (assign, nonatomic) NSUInteger index;
// Votes count for answer
@property (assign, nonatomic) NSUInteger count;
// Share in total votes
@property (assign, nonatomic) CGFloat share;

- (instancetype)initWithIndex:(NSUInteger)index count:(NSUInteger)count;
+ (NRAnswerVotes *)answerVotesWithIndex:(NSUInteger)index count:(NSUInteger)count;
- (void)calculateShareWithTotalCount:(NSUInteger)totalCount;
- (void)vote;
@end
