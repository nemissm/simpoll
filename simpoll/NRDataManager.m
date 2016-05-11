//
//  NRDataManager.m
//  simpoll
//
//  Created by Mikhail Naryshkin on 11/05/16.
//  Copyright © 2016 NERPA. All rights reserved.
//

#import "NRDataManager.h"
#import "NRAnswerVotes.h"

@interface NRDataManager ()

@property (strong, nonatomic) NSArray *questionsArray;
@property (strong, nonatomic) NSArray *answersTitlesArray;
@property (strong, nonatomic) NSArray *answersVotesArray;

@end

@implementation NRDataManager

static NSInteger const delayInSeconds = 2;

#pragma mark - Initialization

+ (NRDataManager *)sharedManager {
  
  static NRDataManager *sharedManager = nil;

  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    sharedManager = [[NRDataManager alloc] init];
  });
  
  return sharedManager;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _questionsArray = @[
      @"Вам нравится верстать под iOS?",
      @"Ваш любимый формат медиаконтента?",
      @"Ваш средний балл в школе?",
      @"Какой палец вы больше всего боитесь потерять?",
      @"Какая часть света является вашей родиной?",
      @"Ваш любимый день недели?"
    ];
    
    _answersTitlesArray = @[
      @[@"Да", @"Нет"],
      @[@"Аудио", @"Фото", @"Видео"],
      @[@"2", @"3", @"4", @"5"],
      @[@"Большой", @"Указательный", @"Средний", @"Безымянный", @"Мизинец"],
      @[@"Европа", @"Азия", @"Америка", @"Африка", @"Австралия", @"Антарктида"],
      @[@"Пн", @"Вт", @"Ср", @"Чт", @"Пт", @"Сб", @"Вс"]
    ];
    
    _answersVotesArray = @[
      @[
        [NRAnswerVotes answerVotesWithIndex:0 count:5736],
        [NRAnswerVotes answerVotesWithIndex:1 count:957]
        ],
      @[
        [NRAnswerVotes answerVotesWithIndex:0 count:3478],
        [NRAnswerVotes answerVotesWithIndex:1 count:2590],
        [NRAnswerVotes answerVotesWithIndex:2 count:4399],
        ],
      @[
        [NRAnswerVotes answerVotesWithIndex:0 count:27],
        [NRAnswerVotes answerVotesWithIndex:1 count:126],
        [NRAnswerVotes answerVotesWithIndex:2 count:174],
        [NRAnswerVotes answerVotesWithIndex:3 count:89],
        ],
      @[
        [NRAnswerVotes answerVotesWithIndex:0 count:139],
        [NRAnswerVotes answerVotesWithIndex:1 count:98],
        [NRAnswerVotes answerVotesWithIndex:2 count:208],
        [NRAnswerVotes answerVotesWithIndex:3 count:462],
        [NRAnswerVotes answerVotesWithIndex:4 count:859],
        ],
      @[
        [NRAnswerVotes answerVotesWithIndex:0 count:745],
        [NRAnswerVotes answerVotesWithIndex:1 count:4274],
        [NRAnswerVotes answerVotesWithIndex:2 count:959],
        [NRAnswerVotes answerVotesWithIndex:3 count:1124],
        [NRAnswerVotes answerVotesWithIndex:4 count:35],
        [NRAnswerVotes answerVotesWithIndex:5 count:2],
        ],
      @[
        [NRAnswerVotes answerVotesWithIndex:0 count:0],
        [NRAnswerVotes answerVotesWithIndex:1 count:0],
        [NRAnswerVotes answerVotesWithIndex:2 count:0],
        [NRAnswerVotes answerVotesWithIndex:3 count:0],
        [NRAnswerVotes answerVotesWithIndex:4 count:5],
        [NRAnswerVotes answerVotesWithIndex:5 count:100],
        [NRAnswerVotes answerVotesWithIndex:6 count:50],
        ]
    ];
    
    for (NSArray *answerVotesArray in _answersVotesArray) {
      [self calculateShareForQuestionAnswersWithVotesArray:answerVotesArray];
    }
    
  }
  return self;
}

#pragma mark - Additional

- (void)calculateShareForQuestionAnswersWithVotesArray:(NSArray *)answerVotesArray {
  
  NSUInteger totalCount = 0;
  for (NRAnswerVotes *answerVotes in answerVotesArray) {
    totalCount += answerVotes.count;
  }
  
  for (NRAnswerVotes *answerVotes in answerVotesArray) {
    [answerVotes calculateShareWithTotalCount:totalCount];
  }
}

#pragma mark - API

- (NSString *)getTitleForQuestionAtIndex:(NSUInteger)index {
  return [self.questionsArray objectAtIndex:index];
}

- (NSArray *)getAnswerTitlesForQuestionAtIndex:(NSUInteger)index {
  return [self.answersTitlesArray objectAtIndex:index];
}

- (void)voteForAnswerAtIndex:(NSUInteger)answerIndex
             questionAtIndex:(NSUInteger)questionIndex
                  completion:(void(^)(NSArray *answerVotesArray))completion {
  
  NSArray *answerVotesArray = [self.answersVotesArray objectAtIndex:questionIndex];
  NRAnswerVotes *answerVotes = [answerVotesArray objectAtIndex:answerIndex];
  [answerVotes vote];
  
  [self calculateShareForQuestionAnswersWithVotesArray:answerVotesArray];
  
  // Simulate request
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^{
    if (completion) {
      completion(answerVotesArray);
    }
  });
}

@end
