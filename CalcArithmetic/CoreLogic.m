//
//  CoreLogic.m
//  CalcArithmetic
//
//  Created by Krisha Jivani on 7/2/21.
// Implementation file-- where the core arithmetic logic will be.

//NOTE: alternative way to evaluate any given expression-- add an extension to NSExpression to evaluate trigonometric functions. Note that we choose not to do this to illustrate how creating an arithmetic logic framework from "scratch" would look like.

//OTHER POSSIBLE APPLICATIONS OF THIS FRAMEWORK? A homework solver app that shows solving an equation step-by-step with order of operations

#import "CoreLogic.h"

@implementation CoreLogic

- (instancetype) initWithExpression:(NSString *)expression { //initalizer with parameter of type NSString
    if (self = [super init]){
        
        _expressionArray = [NSMutableArray new];
        
        for (int i=0; i<expression.length; i++) { //intializes expressionArray with each object as one character of expression
            
            NSString *singleChar = [NSString stringWithFormat:@"%c", [expression characterAtIndex:i]];
            [_expressionArray addObject:singleChar];
        }
        
        [self concatDigitsInArray];
        [self concatTrigInArray];
  
        
        NSLog(@"INITIALIZER%@", _expressionArray);
    }
    
    return self;
}

+ (BOOL) isNumber: (NSString *) inputString { //checks whether a string consists of only numbers; ex://"4.3" returns YES, ")" returns NO
    NSString *firstChar = [NSString stringWithFormat:@"%c", [inputString characterAtIndex:0]];
    
    if ([firstChar isEqualToString:@"-"] && inputString.length>1){ //negative number
        inputString = [inputString substringFromIndex:1];
    }
    else if ([inputString isEqualToString:@"-"]) {
        return NO;
    }
    
    NSCharacterSet* notDigits = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    if ([inputString rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        return YES;
    }
    
    return NO;
}

+ (BOOL) isAlpha: (NSString *) inputString { //checks whether a string consists of only letters; ex://"c" returns YES, "2" returns NO
    
    NSCharacterSet *notLetters = [[NSCharacterSet lowercaseLetterCharacterSet] invertedSet];
    NSRange range = [inputString rangeOfCharacterFromSet:notLetters];
    if (NSNotFound == range.location) {
        return YES;
    }
    
    return NO;
}

+ (BOOL) isOperator: (NSString *) inputString { //checks whether a string is an operator; ex://"+" returns YES, "5" returns NO
    NSMutableArray *operatorArray = [[NSMutableArray alloc] initWithArray:@[@"+",@"-",@"*",@"/"]];
    
    for (int i=0; i<operatorArray.count; i++) {
        if ([inputString isEqualToString:operatorArray[i]]) {
            return YES;
        }
    }
    
    return NO;
}

- (void) concatDigitsInArray { //concatenates consecutive digits in the array; ex:// ["2", "2", "+", "5"] becomes ["22", "+", "5"]
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString *tempStr = @"";
    
    for (int i=0; i<_expressionArray.count; i++) {
        
        if (![[self class] isNumber:_expressionArray[i]]) { //if char is not a digit
            if (![tempStr isEqualToString:@""]) { //if tempStr is not an empty string
                [tempArray addObject:tempStr];
                tempStr = @"";
            }
            [tempArray addObject:_expressionArray[i]];
        }
        else {
            tempStr = [NSString stringWithFormat:@"%@%@", tempStr, _expressionArray[i]];
            
            if (i == _expressionArray.count-1) {
                [tempArray addObject:tempStr];
            }
        }
        
    }
    _expressionArray = tempArray;
}

- (void) concatTrigInArray { //concatenates the letters forming sin, cos, and tan in the array; ex:// ["s", "i", "n", "(", "30", ")"] becomes ["sin", "(", "30", ")"]
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString *tempStr = @"";
    
    for (int i=0; i<_expressionArray.count; i++) {
        if ([[self class] isAlpha:_expressionArray[i]]) {
            tempStr = [NSString stringWithFormat:@"%@%@%@", _expressionArray[i],_expressionArray[i+1],_expressionArray[i+2]];
            [tempArray addObject:tempStr];
            i = i+2;
        }
        else {
            [tempArray addObject:_expressionArray[i]];
        }
    }
    
    _expressionArray = tempArray;
}


- (NSString*) evaluate {
    NSMutableArray *tempArray = [NSMutableArray new];
    [tempArray addObjectsFromArray:_expressionArray];

    while ([tempArray containsObject:@"("]) {
        int openParenIndex = 0;
        int closeParenIndex = 0;
        for (int i=0; i<tempArray.count; i++) {
            if ([tempArray[i] isEqualToString:@"("] && (i > openParenIndex)) {
                openParenIndex = i;
            }
            else if ([tempArray[i] isEqualToString:@")"]) {
                closeParenIndex = i;

                //take expression in between the set of parenthesis
                NSMutableArray *subArray = [[tempArray subarrayWithRange:NSMakeRange(openParenIndex+1, closeParenIndex-openParenIndex-1)] mutableCopy];
                
                if ([self isBasicExpression:subArray]) {
                    if (subArray.count == 1 && openParenIndex > 0 && [[self class] isAlpha:tempArray[openParenIndex-1]]) { //expression is the interior of a trig function
                        subArray = [[tempArray subarrayWithRange:NSMakeRange(openParenIndex-1, 4)] mutableCopy];
                        [tempArray insertObject:[self evaluateBasicExpression:subArray] atIndex:openParenIndex-1];
                        [tempArray removeObjectsInRange:NSMakeRange(openParenIndex, 4)];

                    }
                    else if (openParenIndex > 0 && [[self class] isNumber:tempArray[openParenIndex-1]]) {
                        [tempArray insertObject:@"*" atIndex:openParenIndex];
                    }
                    else {
                        [tempArray insertObject:[self evaluateBasicExpression:subArray] atIndex:openParenIndex];
                        [tempArray removeObjectsInRange:NSMakeRange(openParenIndex+1, closeParenIndex-openParenIndex+1)];
                    }
                }
                else {
                    NSString* inner = [self simplifyNonParenExpression:subArray];
                    
                    if ([[self class] isAlpha:tempArray[openParenIndex-1]] || [tempArray[openParenIndex-1] isEqualToString:@"-"]) { //expression is enclosed in a trig function, do not remove parentheses
                        [tempArray removeObjectsInRange:NSMakeRange(openParenIndex+1, closeParenIndex-openParenIndex-1)];
                        [tempArray insertObject:inner atIndex:openParenIndex+1];
                    }
                    else { //remove parentheses when inserting the sub-expression's simplification
                        [tempArray removeObjectsInRange:NSMakeRange(openParenIndex+1, closeParenIndex-openParenIndex+1)];
                        [tempArray insertObject:inner atIndex:openParenIndex];
                    }
                    
                }
                
                i = -1;
                openParenIndex = 0;
                closeParenIndex = 0;
          
            }
        }
    }
    
    return [self simplifyNonParenExpression:tempArray];
}

- (NSString*) simplifyNonParenExpression: (NSMutableArray*) tempArray { //evaluates expression, represented by an array, that does not contain any set of parenthesis
    while (tempArray.count > 1) {
        for (int i=0; i<tempArray.count; i++) {
            if ([tempArray[i] isEqualToString:@"*"] || [tempArray[i] isEqualToString:@"/"]) {
                NSMutableArray *basicArray = [[tempArray subarrayWithRange:NSMakeRange(i-1,3)] mutableCopy];
                
                [tempArray insertObject:[self evaluateBasicExpression:basicArray] atIndex:i-1];
                [tempArray removeObjectsInRange:NSMakeRange(i,3)];
                i = i-1;
                
            }
        }
        
        BOOL hasLeadingNeg = NO;
        for (int k=1; k<tempArray.count; k++) { //accounts for negative numbers; concatenates leading negative and number into one object in array
            if (k == 1) {
                if ([[self class] isNumber:tempArray[k]] && ([tempArray[k-1] isEqualToString:@"-"])) {
                    hasLeadingNeg = YES;
                }

            }
            else {
                if ([[self class] isNumber:tempArray[k]] && ([tempArray[k-1] isEqualToString:@"-"]) && ![[self class] isNumber:tempArray[k-2]]) {
                    hasLeadingNeg = YES;
                }
            }

            if (hasLeadingNeg) {
                NSMutableArray *computeArray = [NSMutableArray new];
                [computeArray addObjectsFromArray:@[@"-1",@"*",tempArray[k]]];

                NSString* tempStr = [self evaluateBasicExpression:computeArray];
                [tempArray replaceObjectAtIndex:k withObject:tempStr];
                [tempArray removeObjectAtIndex:k-1];

                hasLeadingNeg = NO;
                k = 0;
            }
        }
        for (int k=0; k<tempArray.count; k++) {
            if ([tempArray[k] isEqualToString:@"+"] || [tempArray[k] isEqualToString:@"-"]) {
                NSMutableArray *basicArray = [[tempArray subarrayWithRange:NSMakeRange(k-1,3)] mutableCopy];
                
                [tempArray insertObject:[self evaluateBasicExpression:basicArray] atIndex:k-1];
                [tempArray removeObjectsInRange:NSMakeRange(k,3)];
                k = k-1;
                
            }
        }
        
    }
    return tempArray[0];
}

- (BOOL) isBasicExpression { //evaluates whether the user-inputted expression is a basic expression; i.e. an expression that has 2 numbers with an operator in between or an expression with one number enclosed in sin, cos, or tan.
    //ex://2+3, 7*56.2, sin(30)
//    if (_expressionArray.count == 1 && [[self class] isNumber:_expressionArray[0]]) { //array contains a single number
//        return YES;
//    }
    
    return [self isBasicExpression:_expressionArray];
}

- (BOOL) isBasicExpression: (NSMutableArray *) inputArray { //evaluates whether the argument array, which represents an expression, is a basic expression.
    if (inputArray.count == 1 && [[self class] isNumber:inputArray[0]]) { //array contains a single number
        return YES;
    }
    else if (inputArray.count == 3 && [[self class] isNumber:inputArray[0]] && [[self class] isOperator:inputArray[1]] && [[self class] isNumber:inputArray[2]]) { //array is of the form: number, operator, number
        return YES;
    }
    else if (inputArray.count == 4 && [[self class] isAlpha:inputArray[0]] && [@"(" isEqualToString:inputArray[1]] && [[self class] isNumber:_expressionArray[2]] && [@")" isEqualToString:inputArray[3]]) { //array is of the form: trig function, parenthesis, number, parenthesis
        return YES;
    }
    return NO;
}

- (NSString*) evaluateBasicExpression { //can be directly accessed by framework user
    if ([self isBasicExpression]){
        return [self evaluateBasicExpression:_expressionArray];
    }
    else {
        return @"This expression is not a basic expression.";
    }
    
}
- (NSString*) evaluateBasicExpression: (NSMutableArray *) inputArray { //evaluates the user-inputted basic expression; i.e. an expression that has 2 numbers with an operator in between OR an expression with one number enclosed in sin, cos, or tan.
    //ex://2+3, 7*56.2, sin(30)
    
    if (inputArray.count == 3) {
        NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:inputArray[0]];
        NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:inputArray[2]];
        
        if ([inputArray containsObject:@"+"]) {
            return [[num1 decimalNumberByAdding:num2] stringValue];
        }
        else if ([inputArray containsObject:@"-"]) {
            return [[num1 decimalNumberBySubtracting:num2] stringValue];
        }
        else if ([inputArray containsObject:@"*"]) {
            return [[num1 decimalNumberByMultiplyingBy:num2] stringValue];
        }
        else if ([inputArray containsObject:@"/"]) {
            return [[num1 decimalNumberByDividingBy:num2] stringValue];
        }
    }
    else if (inputArray.count == 4) {
        double num = [inputArray[2] doubleValue];
        if ([inputArray containsObject:@"sin"]) {
            return [NSString stringWithFormat:@"%f",sin(num)];
        }
        else if ([inputArray containsObject:@"cos"]) {
            return [NSString stringWithFormat:@"%f",cos(num)];
        }
        else if ([inputArray containsObject:@"tan"]) {
            return [NSString stringWithFormat:@"%f",tan(num)];
        }
        
    }
    else if (inputArray.count == 1) {
        return inputArray[0];
    }
    
    return @"invalid basic expression";
}





@end
