#import "FHTDelegate.h"
#import "FHTItemView.h"
#import "FHTLCDStatusView.h"

@implementation FHTDelegate

- (id)init
{
  if ((self = [super init]) == nil)
    return nil;
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(beginMenuTracking:)
             name:NSMenuDidBeginTrackingNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(endMenuTracking:)
             name:NSMenuDidEndTrackingNotification
           object:nil];
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateContextMenu:(NSMenu *)menu hide:(BOOL)hide
{
  // Hide or show items that change the display mode or icons size, and any
  // separators that become redundant.
  NSMenu *mainMenu = [NSApp mainMenu];

  if ((menu == mainMenu) || ([menu supermenu] == mainMenu))
    return;

  BOOL changedPrevious = NO;

  for (NSMenuItem *item in menu.itemArray) {
    if (item.isSeparatorItem && changedPrevious)
      [item setHidden:hide];
    if ((item.action == @selector(changeToolbarDisplayMode:)) ||
        (item.action == @selector(toggleUsingSmallToolbarIcons:))) {
      [item setHidden:hide];
      changedPrevious = YES;
    } else {
      changedPrevious = NO;
    }
  }
}

- (void)beginMenuTracking:(NSNotification *)note
{
  [self updateContextMenu:[note object] hide:YES];
}

- (void)endMenuTracking:(NSNotification *)note
{
  [self updateContextMenu:[note object] hide:NO];
}

- (void)toolbarWillAddItem:(NSNotification *)notification
{
  NSToolbarItem *item = (NSToolbarItem *)[notification userInfo][@"item"];

  [FHTItemView customizeToolbarItem:item
                       isFullHeight:[self isFullHeightItem:item]];
}

- (BOOL)isFullHeightItem:(NSToolbarItem *)item
{
  if ([item.itemIdentifier isEqualToString:@"com.uncommonplace.lcditem"]) {
    NSRect frame = { { 0, 0 }, [item minSize] };
    FHTLCDStatusView *lcdView = [[FHTLCDStatusView alloc] initWithFrame:frame];

    item.view = lcdView;
    return YES;
  }
  return NO;
}

@end
