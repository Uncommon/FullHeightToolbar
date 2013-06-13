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
    }
  }
}

@end
