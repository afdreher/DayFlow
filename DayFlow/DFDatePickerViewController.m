#import "DFDatePickerViewController.h"

//
// CONSTANTS
//

NSString * const SELECTED_DATE_KEYPATH = @"datePickerView.selectedDate";


@implementation DFDatePickerViewController
@synthesize datePickerView = _datePickerView;

//
//  VIEW LIFECYCLE
//

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:self.datePickerView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self addObserver:self
         forKeyPath:SELECTED_DATE_KEYPATH
            options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
            context:(void *)self];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

  id observationInfo = [self observationInfo];
  if (observationInfo != nil) {
    [self removeObserver:self forKeyPath:SELECTED_DATE_KEYPATH context:(void *)self];
  }
}


//
//  KEY VALUE OBSERVING
//

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
	if ([keyPath isEqualToString:SELECTED_DATE_KEYPATH]) {
		NSDate *toDate = change[NSKeyValueChangeNewKey];
		if ([toDate isKindOfClass:[NSDate class]]) {
			//	toDate might be NSNull
			[self.delegate datePickerViewController:self didSelectDate:toDate];
		}
	}
}


//
//  PROPERTY METHODS
//

- (DFDatePickerView *)datePickerView {
	if (!_datePickerView) {
		_datePickerView = [DFDatePickerView new];
		_datePickerView.frame = self.view.bounds;
		_datePickerView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	}
	return _datePickerView;
}

@end
