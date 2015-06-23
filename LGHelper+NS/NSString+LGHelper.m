//
//  NSString+LGHelper.m
//  LGHelper+NS
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGHelper-NS)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "NSString+LGHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LGHelper)

#pragma mark -

- (BOOL)containsString:(NSString *)string
{
    return [self rangeOfString:string].location != NSNotFound;
}

- (NSRange)fullRange
{
    return NSMakeRange(0, self.length);
}

#pragma mark -

- (NSString *)md5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15]];
}

- (NSString *)sha1Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15], result[16], result[17], result[18], result[19]];
}

#pragma mark -

+ (NSString *)stringWithObject:(id)object
{
    if (object && ![object isKindOfClass:[NSNull class]])
    {
        NSString *string = [NSString stringWithFormat:@"%@", object];
        
        if (!string.length) string = nil;
        
        return string;
    }
    else
        return nil;
}

+ (NSString *)stringWithObjectReturnNil:(id)object
{
    return [NSString stringWithObject:object];
}

+ (NSString *)stringWithObjectReturnEmpty:(id)object
{
    if (object && ![object isKindOfClass:[NSNull class]])
    {
        NSString *string = [NSString stringWithFormat:@"%@", object];
        
        if (!string) string = @"";
        
        return string;
    }
    else
        return @"";
}

#pragma mark -

- (NSString *)stringByCapitalizingFirstLetter
{
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[self substringToIndex:1].uppercaseString];
}

- (NSString *)stringByRemovingAllWhitespacesAndNewLine
{
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
}

- (NSString *)stringByRemovingAllNumbers
{
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] componentsJoinedByString:@""];
}

- (NSString *)stringByRemovingAllExeptNumbers
{
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
}

- (NSString *)stringByRemovingAllExeptPhoneSymbols
{
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"+1234567890"] invertedSet]] componentsJoinedByString:@""];
}

- (NSString *)stringByRemovingAllExeptSymbols:(NSString *)symbols
{
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:symbols] invertedSet]] componentsJoinedByString:@""];
}

#pragma mark - Crypto

- (NSString *)xorCryptedWithKey:(NSString *)key
{
    NSMutableData *result = [self dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    
    // Get pointer to data to obfuscate
    char *dataPtr = (char *)[result mutableBytes];
    
    // Get pointer to key data
    char *keyData = (char *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    // For each character in data, xor with current value in key
    for (int x = 0; x < self.length; x++)
    {
        // Replace current character in data with
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        // If at end of key data, reset count and
        // set key pointer back to start of key value
        if (++keyIndex == [key length])
            keyIndex = 0, keyPtr = keyData;
    }
    
    NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    return resultString;
}

@end
