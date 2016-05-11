//
//  NRAnswerVotes.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 10/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRAnswerVotes.h"

@implementation NRAnswerVotes

- (instancetype)initWithIndex:(NSUInteger)index count:(NSUInteger)count {
  
  self = [super init];
  if (self) {
    _index = index;
    _count = count;
  }
  return self;
}

+ (NRAnswerVotes *)answerVotesWithIndex:(NSUInteger)index count:(NSUInteger)count {
  return [[self alloc] initWithIndex:index count:count];
}

- (void)calculateShareWithTotalCount:(NSUInteger)totalCount {
  self.share = (CGFloat)self.count / totalCount;
}

- (void)vote {
  self.count++;
}

@end

//UIColor
