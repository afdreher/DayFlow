#import <UIKit/UIKit.h>

@interface DFDatePickerView : UIView
@property (nonatomic, readwrite, strong) NSDate *selectedDate;

- (instancetype) initWithCalendar:(NSCalendar *)calendar;

- (void)scrollToDate:(NSDate *)date
      atScollPostion:(UICollectionViewScrollPosition)scrollPosition
            animated:(BOOL)animated;

- (void)clearSelectionAnimated:(BOOL)animated;

@end
