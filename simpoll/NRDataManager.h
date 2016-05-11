//
//  NRDataManager.h
//  simpoll
//
//  Created by Mikhail Naryshkin on 11/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRDataManager : NSObject

+ (NRDataManager *)sharedManager;

- (NSString *)getTitleForQuestionAtIndex:(NSUInteger)index;
- (NSArray *)getAnswerTitlesForQuestionAtIndex:(NSUInteger)index;
- (void)voteForAnswerAtIndex:(NSUInteger)answerIndex
             questionAtIndex:(NSUInteger)questionIndex
                  completion:(void (^)(NSArray *answerVotesArray))completion;

@end
