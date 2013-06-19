#import "FHTLCDStatusView.h"

// Based on code from http://stackoverflow.com/a/5954705/310159

static NSShadow *kDropShadow = nil;
static NSShadow *kInnerShadow = nil;
static NSGradient *kiTunesGradient = nil;
static NSGradient *kXcodeGradient = nil;
static NSGradient *kInstrumentsGradient = nil;
static NSColor *kBorderColor = nil;

@interface NSBezierPath (PathExtras)

- (void)strokeInside;
- (void)fillWithInnerShadow:(NSShadow *)shadow;

@end

@implementation FHTLCDStatusView

+ (void)load
{
  const NSSize offset = NSMakeSize(0, -1.0);

  kDropShadow = [[NSShadow alloc] init];
  kDropShadow.shadowColor = [NSColor colorWithCalibratedWhite:0.863 alpha:0.75];
  kDropShadow.shadowOffset = offset;
  kDropShadow.shadowBlurRadius = 1.0;

  kInnerShadow = [[NSShadow alloc] init];
  kInnerShadow.shadowColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.52];
  kInnerShadow.shadowOffset = offset;
  kInnerShadow.shadowBlurRadius = 4.0;

  kBorderColor = [NSColor colorWithCalibratedWhite:0.569 alpha:1.0];

  kiTunesGradient = [[NSGradient alloc] initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:0.929 green:0.945 blue:0.882 alpha:1.0], 0.0,
      [NSColor colorWithCalibratedRed:0.902 green:0.922 blue:0.835 alpha:1.0], 0.5,
      [NSColor colorWithCalibratedRed:0.871 green:0.894 blue:0.78  alpha:1.0], 0.5,
      [NSColor colorWithCalibratedRed:0.949 green:0.961 blue:0.878 alpha:1.0], 1.0,
      nil];
  kXcodeGradient = [[NSGradient alloc] initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:0.957 green:0.976 blue:1.0   alpha:1.0], 0.0,
      [NSColor colorWithCalibratedRed:0.871 green:0.894 blue:0.918 alpha:1.0], 0.5,
      [NSColor colorWithCalibratedRed:0.831 green:0.851 blue:0.867 alpha:1.0], 0.5,
      [NSColor colorWithCalibratedRed:0.82  green:0.847 blue:0.89  alpha:1.0], 1.0,
      nil];
  kInstrumentsGradient = [[NSGradient alloc] initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:0.811 green:0.855 blue:0.811 alpha:1.0], 0.0,
      [NSColor colorWithCalibratedRed:0.729 green:0.792 blue:0.717 alpha:1.0], 0.5,
      [NSColor colorWithCalibratedRed:0.690 green:0.753 blue:0.678 alpha:1.0], 0.5,
      [NSColor colorWithCalibratedRed:0.784 green:0.855 blue:0.773 alpha:1.0], 1.0,
      nil];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {  
  NSRect bounds = [self bounds];
  bounds.size.height -= 1.0;
  bounds.origin.y += 1.0;
  
  NSBezierPath *path =
      [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:3.5 yRadius:3.5];
  
  [NSGraphicsContext saveGraphicsState];
  [kDropShadow set];
  [path fill];
  [NSGraphicsContext restoreGraphicsState];
  
  [kXcodeGradient drawInBezierPath:path angle:-90.0];
  
  [kBorderColor setStroke];
  [path strokeInside];
  
  [path fillWithInnerShadow:kInnerShadow];
}

@end

@implementation NSBezierPath (PathExtras)

- (void)strokeInside
{
  NSGraphicsContext *thisContext = [NSGraphicsContext currentContext];
  float lineWidth = [self lineWidth];
  
  [thisContext saveGraphicsState];
  
  [self setLineWidth:(lineWidth * 2.0)];
  
  [self setClip];
  [self stroke];
  
  [thisContext restoreGraphicsState];
  [self setLineWidth:lineWidth];
}

- (void)fillWithInnerShadow:(NSShadow *)shadow
{
	[NSGraphicsContext saveGraphicsState];
	
	NSSize offset = shadow.shadowOffset;
	const NSSize originalOffset = offset;
	const CGFloat radius = shadow.shadowBlurRadius;
	NSRect bounds = NSInsetRect(self.bounds,
                              -(ABS(offset.width) + radius),
                              -(ABS(offset.height) + radius));

	offset.height += bounds.size.height;
	shadow.shadowOffset = offset;

	NSAffineTransform *transform = [NSAffineTransform transform];

	if ([[NSGraphicsContext currentContext] isFlipped])
		[transform translateXBy:0 yBy:bounds.size.height];
	else
		[transform translateXBy:0 yBy:-bounds.size.height];
	
	NSBezierPath *drawingPath = [NSBezierPath bezierPathWithRect:bounds];

	[drawingPath setWindingRule:NSEvenOddWindingRule];
	[drawingPath appendBezierPath:self];
	[drawingPath transformUsingAffineTransform:transform];
	
	[self addClip];
	[shadow set];
	[[NSColor blackColor] set];
	[drawingPath fill];
	
	shadow.shadowOffset = originalOffset;
	
	[NSGraphicsContext restoreGraphicsState];
}

@end