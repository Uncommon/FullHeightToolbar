#import "UUFullHeightToolbarDelegate.h"
#import "UUFullHeightToolbarItemView.h"

@implementation UUFullHeightToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
  // Problem: Though the docs indicate otherwise, this does not get called
  // for nib-based toolbars.
  return [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
}

- (void)toolbarWillAddItem:(NSNotification *)notification
{
  NSToolbarItem *item = (NSToolbarItem *)[notification userInfo][@"item"];

  if (![self isFullHeightItem:item])
    [UUFullHeightToolbarItemView customizeToolbarItem:item];
}

- (BOOL)isFullHeightItem:(NSToolbarItem *)item
{
  return NO;
}

@end
