#import "DFDatePickerDayCell.h"

@interface DFDatePickerDayCell ()
+ (NSCache *) imageCache;
+ (id) cacheKeyForPickerDate:(DFDatePickerDate)date;
+ (id) fetchObjectForKey:(id)key withCreator:(id(^)(void))block;
@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, readonly, strong) UIView *overlayView;
@property (nonatomic) CALayer *cellLayer;

// Although we store the NSString value, I don't want to compare too often.
@property (nonatomic, assign) BOOL cellBorderThicknessUseThin;
@property (nonatomic, assign) CGFloat cellBorderThicknessFloatValue;
@end

@implementation DFDatePickerDayCell
@synthesize imageView = _imageView;
@synthesize overlayView = _overlayView;
@synthesize textColor = _textColor;
@synthesize cellColor = _cellColor;
@synthesize activityColor = _activityColor;
@synthesize cellBorderColor = _cellBorderColor;
@synthesize cellBorderThickness = _cellBorderThickness;
@synthesize cellBorderThicknessUseThin = _cellBorderThicknessUseThin;
@synthesize cellBorderThicknessFloatValue = _cellBorderThicknessFloatValue;

@synthesize cellLayer = _cellLayer;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
    
    self.textColor = [UIColor whiteColor];
    self.cellColor = [UIColor colorWithRed:53.0f/256.0f
                                     green:145.0f/256.0f
                                      blue:195.0f/256.0f
                                     alpha:1.0f];
    self.cellBorderColor = nil;
	}
	return self;
}

- (void) setDate:(DFDatePickerDate)date {
	_date = date;
	[self setNeedsLayout];
}

- (void) setEnabled:(BOOL)enabled {
	_enabled = enabled;
	[self setNeedsLayout];
}

- (void) setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsLayout];
}
- (void) setSelected:(BOOL)selected {
	[super setSelected:selected];
	[self setNeedsLayout];
}

- (void) setHasActivity:(BOOL)hasActivity{
  if (_hasActivity != hasActivity) {
    _hasActivity = hasActivity;
  }
  [self setNeedsLayout];
}

- (void) layoutSubviews {
	
	[super layoutSubviews];
	
	//	Instead of using labels, use images keyed by day.
	//	This avoids redrawing text within labels, which involve lots of parts of
	//	WebCore and CoreGraphics, and makes sure scrolling is always smooth.
	
	//	Reason: when the view is first shown, all common days are drawn once and cached.
	//	Memory pressure is also low.
	
	//	Note: Assumption! If there is a calendar with unique day names
	//	we will be in big trouble. If there is one odd month with 1000 days we will
	//	also be in some sort of trouble. But for most use cases we are probably good.
	
	//	We still have DFDatePickerMonthHeader take a NSDateFormatter formatted title
	//	and draw it, but since that’s only one bitmap instead of 35-odd (7 weeks)
	//	that’s mostly okay.
  
  // Disable animation to avoid flicker with CALayer
  [CATransaction begin];
  [CATransaction setDisableActions: YES];
  self.cellLayer.bounds = self.bounds;
  self.cellLayer.opacity = self.enabled ? 1.0f : 0.25f;
  
  if (self.hasActivity) {
    self.cellLayer.borderWidth = 2.0;
    self.cellLayer.borderColor = self.activityColor.CGColor;
  } else {
    if (self.cellBorderColor) {
      self.cellLayer.borderColor = self.cellBorderColor.CGColor;
      if (self.cellBorderThicknessUseThin) {
        self.cellLayer.borderWidth = 1.0 / self.contentScaleFactor;
      } else {
        self.cellLayer.borderWidth = self.cellBorderThicknessFloatValue;
      }
    } else {
      self.cellLayer.borderWidth = 0.0;
    }
  }
  self.imageView.alpha = self.cellLayer.opacity;
  [CATransaction commit];

	self.imageView.image =
      [[self class] fetchObjectForKey:[[self class] cacheKeyForPickerDate:self.date active:self.hasActivity]
                          withCreator:^{
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		UIFont *font = [UIFont boldSystemFontOfSize:20.0f];
		CGRect textBounds = (CGRect){ 0.0f, 10.0f, 44.0f, 24.0f };
		
    if (self.hasActivity) {
		  CGContextSetFillColorWithColor(context, self.activityColor.CGColor);
    } else {
      CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    }
		[[NSString stringWithFormat:@"%i", self.date.day] drawInRect:textBounds
                                                        withFont:font
                                                   lineBreakMode:NSLineBreakByCharWrapping
                                                       alignment:NSTextAlignmentCenter];
    
		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return image;
	}];
	
	self.overlayView.hidden = !(self.selected || self.highlighted);
}

- (UIView *) overlayView {
	if (!_overlayView) {
		_overlayView = [[UIView alloc] initWithFrame:self.contentView.bounds];
		_overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.alpha = 0.25f;
		[self.contentView addSubview:_overlayView];
	}
	return _overlayView;
}

- (UIImageView *) imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
		_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_imageView];
	}
	return _imageView;
}

+ (NSCache *) imageCache {
	static NSCache *cache;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cache = [NSCache new];
	});
	return cache;
}

+ (id) cacheKeyForPickerDate:(DFDatePickerDate)date {
	return @(date.day);
}

+ (id)cacheKeyForPickerDate:(DFDatePickerDate)date active:(BOOL)active {
  return [NSString stringWithFormat:@"%d-%d", date.day, (active ? 0 : 1)];
}

+ (id) fetchObjectForKey:(id)key withCreator:(id(^)(void))block {
	id answer = [[self imageCache] objectForKey:key];
	if (!answer) {
		answer = block();
		[[self imageCache] setObject:answer forKey:key];
	}
	return answer;
}

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor {
  [super setContentScaleFactor:contentScaleFactor];
  self.cellLayer.contentsScale = contentScaleFactor; // Allow for retina
  [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
  if (_textColor != textColor) {
    _textColor = textColor;
    [[[self class] imageCache] removeObjectForKey:[[self class] cacheKeyForPickerDate:self.date active:NO]];
  }
}

- (void)setCellColor:(UIColor *)cellColor {
  if (_cellColor != cellColor) {
    _cellColor = cellColor;
    self.cellLayer.backgroundColor = cellColor.CGColor;
  }
}

- (void)setActivityColor:(UIColor *)activityColor {
  if (!_activityColor || _activityColor != activityColor) {
    _activityColor = activityColor;
    [[[self class] imageCache] removeObjectForKey:[[self class] cacheKeyForPickerDate:self.date active:YES]];
    [self setNeedsLayout];
  }
}

- (CALayer *)cellLayer {
  if (!_cellLayer) {
    _cellLayer = [CALayer layer];
    _cellLayer.anchorPoint = CGPointZero;
    _cellLayer.backgroundColor = self.cellColor.CGColor;
    [self.layer insertSublayer:_cellLayer below:self.contentView.layer];
  }
  return _cellLayer;
}

- (void)setCellBorderColor:(UIColor *)cellBorderColor {
  if (_cellBorderColor != cellBorderColor) {
    _cellBorderColor = cellBorderColor;
    [self setNeedsLayout];
  }
}

- (void)setCellBorderThickness:(NSString *)cellBorderThickness {
  if (!_cellBorderThickness ||
      [_cellBorderThickness caseInsensitiveCompare:cellBorderThickness] != NSOrderedSame) {
    _cellBorderThickness = cellBorderThickness;
    if ([cellBorderThickness caseInsensitiveCompare:@"thin"] == NSOrderedSame) {
      self.cellBorderThicknessUseThin = YES;
    } else {
      self.cellBorderThicknessUseThin = NO;
      self.cellBorderThicknessFloatValue = [cellBorderThickness floatValue];
    }
    [self setNeedsLayout];
  }
}

@end
