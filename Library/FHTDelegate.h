#import <Foundation/Foundation.h>

@interface FHTDelegate : NSObject<NSToolbarDelegate>

- (BOOL)isFullHeightItem:(NSToolbarItem *)item;

@end
