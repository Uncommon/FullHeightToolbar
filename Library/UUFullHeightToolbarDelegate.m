#import "UUFullHeightToolbarDelegate.h"
#import "UUFullHeightToolbarItemView.h"
#import "UULCDStatusView.h"

@implementation UUFullHeightToolbarDelegate

- (void)toolbarWillAddItem:(NSNotification *)notification
{
  NSToolbarItem *item = (NSToolbarItem *)[notification userInfo][@"item"];

  if (![self isFullHeightItem:item])
    [UUFullHeightToolbarItemView customizeToolbarItem:item];
}

- (BOOL)isFullHeightItem:(NSToolbarItem *)item
{
  if ([item.itemIdentifier isEqualToString:@"com.uncommonplace.lcditem"]) {
    NSRect frame = { { 0, 0 }, [item minSize] };
    UULCDStatusView *lcdView = [[UULCDStatusView alloc] initWithFrame:frame];

    item.view = lcdView;
    return YES;
  }
  return NO;
}

@end
