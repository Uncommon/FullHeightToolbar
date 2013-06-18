#import "UUFullHeightToolbar.h"

@implementation UUFullHeightToolbar

- (void)setDisplayMode:(NSToolbarDisplayMode)displayMode
{
  [super setDisplayMode:NSToolbarDisplayModeIconOnly];
}

- (void)runCustomizationPalette:(id)sender
{
  [super runCustomizationPalette:sender];
  
  NSWindow *toolbarWindow = [NSApp mainWindow];
  NSWindow *sheet = [toolbarWindow attachedSheet];

  for (NSView *view in [[sheet contentView] subviews]) {
    if ([view isKindOfClass:[NSButton class]]) {
      const NSButtonType buttonType =
          [[[(NSButton*)view cell] valueForKey:@"buttonType"] integerValue];

      if (buttonType == NSSwitchButton)
        [view setHidden:YES];  // "Use small size" checkbox
    } else {
      // The mode popup and its label are inside a view. Ideally we should
      // look for more identifying marks, but since the button and the menu
      // items don't have targets there are few good options left.
      for (NSView *subview in view.subviews)
        if ([subview isKindOfClass:[NSPopUpButton class]]) {
          [view setHidden:YES];
          break;
        }
    }
  }
}

@end
