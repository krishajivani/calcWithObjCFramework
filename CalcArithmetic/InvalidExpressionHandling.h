//
//  InvalidExpressionHandling.h
//  CalcArithmetic
//
//  Created by Family Jivani on 7/6/21.
//

#import <Foundation/Foundation.h>
#import "CoreLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvalidExpressionHandling : NSObject

- (instancetype) initWithExpression:(NSString *)expression;
- (NSString*) equalParen;
- (NSString*) divideByZero;

@end

NS_ASSUME_NONNULL_END
