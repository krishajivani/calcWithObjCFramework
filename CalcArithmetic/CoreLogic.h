//
//  CoreLogic.h
//  CalcArithmetic
//
//  Created by Krisha Jivani on 7/2/21.
// Header file-- where public methods of the class will be exposed.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreLogic : NSObject

@property (nonatomic, strong) NSMutableArray *expressionArray;

- (instancetype)initWithExpression:(NSString *)expression;
+ (BOOL) isNumber: (NSString *) inputString;
+ (BOOL) isAlpha: (NSString *) inputString;
+ (BOOL) isOperator: (NSString *) inputString;
- (BOOL) isBasicExpression;
- (NSString*) evaluateBasicExpression;
- (NSString*) evaluate;

@end

NS_ASSUME_NONNULL_END

//list only things you want to be public in this file. If you want it to be private, don't list it in .h, just .m.
