//
//  InvalidExpressionHandling.m
//  CalcArithmetic
//
//  Created by Family Jivani on 7/6/21.
//

#import "InvalidExpressionHandling.h"

@interface InvalidExpressionHandling ()

@property (nonatomic, strong) NSMutableArray *expressionArray;

@end

@implementation InvalidExpressionHandling

- (instancetype) initWithExpression:(NSString *)expression { //initalizer with parameter of type NSString
    if (self = [super init]){
    
        CoreLogic* coreLogic = [[CoreLogic alloc] initWithExpression:expression];
        _expressionArray = coreLogic.expressionArray;
        

    }
    
    return self;
}

- (NSString*) equalParen { //checks if the number of ( and ) are equal
    int openParenCount = 0;
    int closeParenCount = 0;
    for (NSString* obj in _expressionArray) {
        if ([obj isEqualToString:@"("]) {
            openParenCount++;
        }
        else if ([obj isEqualToString:@")"]) {
            closeParenCount++;
        }
    }
    
    if (openParenCount != closeParenCount) {
        return @"ERROR WITH PARENTHETICAL PAIRINGS";
    }
    return @"NO ERROR";
}

- (NSString*) divideByZero { //checks if there is a divide by zero error
    for (int i=0; i<_expressionArray.count-1; i++) {
        if ([_expressionArray[i] isEqualToString:@"/"] && [[CoreLogic class] isNumber:_expressionArray[i+1]]) {
            NSDecimalNumber* tempNum = [NSDecimalNumber decimalNumberWithString:_expressionArray[i+1]];
            NSLog(@"tempNum %@", tempNum);
            if ([tempNum doubleValue] == 0){
                NSLog(@"inside");
                return @"DIVIDE BY ZERO ERROR";
            }
            
        }
    }
    return @"NO ERROR";
}

//although not implemented here, it is a good idea to add more safeguards. For example, a method that makes sure no two operators (besides --) are next to one another in the given expression.

@end
