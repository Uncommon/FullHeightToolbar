#import "FHTItemView.h"

const CGFloat kLabelHeight = 17;
const CGFloat kLabelExtraWidth = 8;  // intrinsicContentSize is too small.

@interface FHTItemView ()

@property NSView *mainView;
@property NSTextField *label;

@end

@implementation FHTItemView

// Returns either the item's view, or a button to replace the icon.
+ (NSView *)mainViewForItem:(NSToolbarItem *)item
{
  NSView *mainView = nil;

  if ([item view] != nil) {
    mainView = [item view];
  } else if ([item image] != nil) {
    const NSRect frame = NSMakeRect(0, 0, 32, 32);
    NSButton *button = [[NSButton alloc] initWithFrame:frame];

    mainView = button;
    button.target = item.target;
    button.action = item.action;
    button.image = item.image;
    [button setBordered:NO];
    [button setButtonType:NSMomentaryChangeButton];
  }

  return mainView;
}

// Returns a view for the toolbar item's label.
+ (NSTextField *)labelForItem:(NSToolbarItem *)item
{
  const NSRect labelFrame =
      NSMakeRect(0, 0, [item minSize].width, kLabelHeight);
  NSShadow *shadow = [[NSShadow alloc] init];
  NSTextField *label = [[NSTextField alloc] initWithFrame:labelFrame];

  label.stringValue = [item label];
  label.font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
  [label setEditable:NO];
  [label setBordered:NO];
  label.drawsBackground = NO;
  label.textColor = [NSColor colorWithDeviceWhite:0.15 alpha:1.0];
  label.alignment = NSCenterTabStopType;
  shadow.shadowOffset = CGSizeMake(0, 1);
  shadow.shadowColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.6];
  label.wantsLayer = YES;
  label.shadow = shadow;
  // Dont' set autoresizingMask here because sizes will be adjusted first.
  return label;
}

// Gives a toolbar item a custom view with a label.
+ (void)customizeToolbarItem:(NSToolbarItem *)item
{
  NSView *mainView = [self mainViewForItem:item];

  if (mainView == nil)
    return;

  const NSRect viewFrame = NSMakeRect(0, 0, mainView.frame.size.width, 48);
  NSSize minSize = viewFrame.size;
  FHTItemView *view = [[self alloc] initWithFrame:viewFrame];

  NSLog(@"%@", [item itemIdentifier]);
  view.toolbarItem = item;
  view.mainView = mainView;

  minSize.width = fmax(minSize.width, mainView.frame.size.width);
  [view addSubview:mainView];
  [mainView setFrameOrigin:
      NSMakePoint(0, viewFrame.size.height - mainView.frame.size.height)];
  mainView.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin;

  NSTextField *label = [self labelForItem:item];

  view.label = label;
  [view addSubview:label];
  minSize.width =
      fmax(minSize.width, label.intrinsicContentSize.width + kLabelExtraWidth);
  [view setFrameSize:minSize];
  label.frame = NSMakeRect(0, 0, minSize.width, kLabelHeight);
  label.autoresizingMask = NSViewWidthSizable | NSViewMaxYMargin;

  [item setView:view];
  [item setMinSize:minSize];
  [item setMaxSize:minSize];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
  const NSRect mainViewFrame = self.mainView.frame;
  const NSSize mySize = self.frame.size;

  // Assume that if the window has no toolbar, then it must be the customize
  // sheet, so the fake label must be hidden.
  if (newWindow.toolbar != nil) {
    [self.label setHidden:NO];
    [self.mainView setFrameOrigin:NSMakePoint(
        mainViewFrame.origin.x,
        mySize.height - mainViewFrame.size.height)];
  } else {
    [self.label setHidden:YES];
    [self.mainView setFrameOrigin:NSMakePoint(
        mainViewFrame.origin.x,
        (mySize.height - mainViewFrame.size.height) / 2)];
  }
}

#pragma mark Forwarding
// NSToolbarItem forwards these attributes to its view, so we need to forward
// again to the main view.

- (SEL)action
{
  if ([self.mainView respondsToSelector:@selector(action)])
    return [(id)self.mainView action];
  return NULL;
}

- (void)setAction:(SEL)action
{
  if ([self.mainView respondsToSelector:@selector(setAction:)])
    [(id)self.mainView setAction:action];
}

- (NSImage *)image
{
  if ([self.mainView respondsToSelector:@selector(image)])
    return [(id)self.mainView image];
  return NULL;
}

- (void)setImage:(NSImage *)image
{
  if ([self.mainView respondsToSelector:@selector(setImage:)])
    [(id)self.mainView setImage:image];
}

- (BOOL)enabled
{
  if ([self.mainView respondsToSelector:@selector(enabled)])
    return [(id)self.mainView enabled];
  return NO;
}

- (void)setEnabled:(BOOL)enabled
{
  if ([self.mainView respondsToSelector:@selector(setEnabled:)])
    [(id)self.mainView setEnabled:enabled];
}

@end
