
#import "NSString+Category.h"
@implementation  NSString (Category)

- (NSString*)encodeURL
{
    NSString *newString = [self stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    if (newString) {
        return newString;
    }
    return @"";
}

- (NSString *)stringToUTF8:(NSString *)aString {

	NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																				  NULL, /* allocator */
																				  (CFStringRef)aString,
																				  NULL, /* charactersToLeaveUnescaped */
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8));
	return escaped_value ;
}

// Encode Chinese to GB2312 in URL
- (NSString *)stringToGb2312:(NSString *)aString {
	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
	NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)aString, CFSTR(""), kCFStringEncodingGB_18030_2000));        
	NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000))  ;
 	return newStr;
}

- (NSString *)stringFormatNumber{
    @try{
        if (self.length < 3)
        {
            return self;
        }
        NSString *numStr = self;
        NSArray *array = [numStr componentsSeparatedByString:@"."];
        NSString *numInt = [array objectAtIndex:0];
        if (numInt.length <= 3)
        {
            return self;
        }
        NSString *suffixStr = @"";
        if ([array count] > 1)
        {
            suffixStr = [NSString stringWithFormat:@".%@",[array objectAtIndex:1]];
        }
        
        NSMutableArray *numArr = [[NSMutableArray alloc] init];
        while (numInt.length > 3)
        {
            NSString *temp = [numInt substringFromIndex:numInt.length - 3];
            numInt = [numInt substringToIndex:numInt.length - 3];
            [numArr addObject:[NSString stringWithFormat:@",%@",temp]];//得到的倒序的数据
        }
        
        for (int i = 0; i < numArr.count; i++)
        {
            numInt = [numInt stringByAppendingFormat:@"%@",[numArr objectAtIndex:(numArr.count -1 -i)]];
        }
        numStr = [NSString stringWithFormat:@"%@%@",numInt,suffixStr];
     
        return numStr;
    }
    @catch (NSException *exception)
    {
        return self;
    }
    @finally
    {}
}


@end
