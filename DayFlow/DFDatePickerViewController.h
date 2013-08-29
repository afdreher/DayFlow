#import <UIKit/UIKit.h>
#import "DFDatePickerView.h"


OBJC_EXPORT NSString * const SELECTED_DATE_KEYPATH;


@class DFDatePickerViewController;
@protocol DFDatePickerViewControllerDelegate

- (void) datePickerViewController:(DFDatePickerViewController *)controller didSelectDate:(NSDate *)date;

@end

@interface DFDatePickerViewController : UIViewController

@property (nonatomic, readonly, strong) DFDatePickerView *datePickerView;
@property (nonatomic, readwrite, weak) id<DFDatePickerViewControllerDelegate> delegate;

@property (nonatomic) UIFont *monthHeaderFont;
@property (nonatomic) UIColor *monthHeaderColor;

@end
