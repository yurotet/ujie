//
//  MTDatePickerView.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTDatePickerView.h"

#import "MTDatePickerView.h"

@interface MTDatePickerView ()

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) NSInteger dayRow;
@property (nonatomic, strong) NSArray * monthArray;

@end

@implementation MTDatePickerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)reset
{
    self.monthArray = [NSArray arrayWithObjects:@"01.",@"02.",@"03.", @"04.", @"05.", @"06.", @"07.", @"08.", @"09.", @"10.", @"11.",@"12.",nil];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    NSDateComponents *components = [self.calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    NSInteger month = [components month];
    NSInteger day = [components day];
    //    components.year -= 25;
    NSInteger year = [components year];
    
    self.date = [self.calendar dateFromComponents:components];
    
    [self.picker selectRow:(month-1) inComponent:0 animated:NO];
    [self.picker selectRow:(day-1) inComponent:1 animated:NO];
    [self.picker selectRow:year inComponent:2 animated:NO];

}

- (void)commonInit {
    [self setBackgroundColor:[UIColor colorWithBackgroundColorMark:10]];
    [self reset];
    [self addSubview:self.picker];
}

- (NSInteger)dayCount:(NSInteger)years month:(NSInteger)month
{
    NSInteger count = 0;
    
    if (2 == month) {
        if((years % 4 == 0 && years % 100!=0) || years % 400 == 0) //是闰年
        {
            count = 29;
        }
        else
        {
            count = 28;
        }
        
    }else if (4 == month || 6 == month || 9 == month || 11 == month){
        count = 30;
    }else{
        count = 31;
    }
    
    return count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return INT16_MAX;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 100;
            break;
        case 1:
            return 100;
            break;
        case 2:
            return 100;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:25.0]];
    [lblDate setTextColor:[UIColor blueColor]];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    if (component == 0) // Month
    {
        int max = (int)[self.calendar maximumRangeOfUnit:NSMonthCalendarUnit].length;
        [lblDate setText:[_monthArray objectAtIndex:(row % max)]]; // 02d = pad with leading zeros to 2 digits
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 1) // day
    {
        int max = (int)[self.calendar maximumRangeOfUnit:NSDayCalendarUnit].length;
        [lblDate setText:[NSString stringWithFormat:@"%02d",(((row+1) % max)==0)?max:((row+1) % max)]]; // 02d = pad with leading zeros to 2 digits
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 2) // year
    {
        int max = (int)[self.calendar maximumRangeOfUnit:NSYearCalendarUnit].length;
        [lblDate setText:[NSString stringWithFormat:@"%04d",(row % max)]];
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    return lblDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1) {
        _dayRow = row;
    }
    
    NSInteger month = ([pickerView selectedRowInComponent:0]+1) % ((int)[self.calendar maximumRangeOfUnit:NSMonthCalendarUnit].length);
    if (month == 0) {
        month = ([pickerView selectedRowInComponent:0]+1);
    }
    NSInteger day = ([pickerView selectedRowInComponent:1]+1) % ((int)[self.calendar maximumRangeOfUnit:NSDayCalendarUnit].length);
    if (day == 0) {
        day = ([pickerView selectedRowInComponent:1]+1);
    }
    NSInteger year = [pickerView selectedRowInComponent:2] % ((int)[self.calendar maximumRangeOfUnit:NSYearCalendarUnit].length);
    
    // Build date out of the components we got
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.month = month;
    components.day = day;
    components.year = year;
    components.hour = 18;
    components.minute = 0;
    components.second = 0;
    
    if (components.day>[self dayCount:year month:month]) {
        components.day = [self dayCount:year month:month];
        [pickerView selectRow:(--_dayRow) inComponent:1 animated:YES];
        [self pickerView:pickerView didSelectRow:_dayRow inComponent:1];
    }
    
    self.date = [self.calendar dateFromComponents:components];
    
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(dateChanged:)])) {
        [self.delegate dateChanged:self];
    }
}
@end
