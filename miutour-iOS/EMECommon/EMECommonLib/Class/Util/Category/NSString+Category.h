
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Category) 

-(NSString*)encodeURL;

- (NSString *)stringToUTF8:(NSString *)aString;
- (NSString *)stringToGb2312:(NSString *)aString;
- (NSString *)stringFormatNumber;
@end
