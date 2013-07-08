#import "FHTDocument.h"

@implementation FHTDocument

- (NSString *)windowNibName
{
  return @"FHTDocument";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  return [NSData data];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
  return YES;
}

@end
