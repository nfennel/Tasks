//
//  TasksListController.m
//  Tasks
//
//  Created by Nathan Fennel on 1/19/14.
//  Copyright (c) 2014 Nathan Fennel. All rights reserved.
//

#import "TasksListController.h"
#import "TasksListCell.h"


@interface TasksListController ()

@end

@implementation TasksListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _blueAppColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f];
    _lightGrayAppColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f];
    _mediumGrayAppColor = [UIColor colorWithRed:122/255.0f green:122/255.0f blue:122/255.0f alpha:1.0f];
    
    _currentlySelectedListCell = -1;
    
    // _tasks Content list key TITLE:String, AVATAR:String, ACCOUNT:String, COMPLETE:Boolean, TIME:String, ACCOUNT FLAG:String, MAIL:Boolean, CALENDAR:Boolean, TASKS:Boolean, NOTES:Boolean,
    
    _tasksContentList = @[
                            @[@"This is the text that fills out the space for what a subject of a task is, it could be rather long but should only fill a maximum of 3 lines. Hopefully this does the trick",
                              @"bgoss@incubate.co",
                              @"Account Type",
                              @false,
                              @"Time to be done by",
                              @"Brian Goss",
                              @"greenTri.png",
                              @false,
                              @true,
                              @false,
                              @false,
                              @true,
                              @false],
                            @[@"Quis aute iure reprehenderit in voluptate velit esse. Gallia est omnis divisa in partes tres, quarum. Morbi odio eros, volutpat ut pharetra vitae, lobortis sed nibh. Praeterea iter est quasdam res quas ex communi.",
                              @"bgoss@incubate.co",
                              @"Legos",
                              @false,
                              @"Never",
                              @"Bruce Springsteen",
                              @"orangeTri.png",
                              @true,
                              @false,
                              @true,
                              @false,
                              @true,
                              @false],
                            @[@"Confirm meeting with George to make sure the agenda is secure",
                              @"bgoss@incubate.co",
                              @"Work",
                              @false,
                              @"8:10p",
                              @"Brian Goss",
                              @"redTri.png",
                              @false,
                              @true,
                              @true,
                              @true,
                              @true],
                            @[@"Look up the new music app",
                              @"bgoss@incubate.co",
                              @"Home",
                              @false,
                              @"12a",
                              @"Brian Goss",
                              @"blueTri.png",
                              @true,
                              @true,
                              @true,
                              @true,
                              @false,
                              @true]
                         ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return _tasksContentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

-(void) handleLongPress: (UIGestureRecognizer *)longPress
{
    if (longPress.state==UIGestureRecognizerStateBegan)
    {
        CGPoint p = [longPress locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        // if another cell is currently being longpressed clear it
        NSInteger theCurrentCell = [self getCurrentlySelectedListCell];
        if(theCurrentCell >-1)
        {
            NSIndexPath *indexPath2 = [self getCurrentlySelectedListCellPath];
            [self updateLongpressView:indexPath2];
        }
        [self setCurrentlySelectedListCellPath:indexPath];
        [self setCurrentlySelectedListCell:indexPath.row];
        if (indexPath == nil)
        {
            NSLog(@"No Cell");
        }
        else
        {
            //static NSString *CellIdentifier = @"TasksListCell";
            //TasksListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            UIView *longPressView = (UIView*)[self.view viewWithTag:(indexPath.row*100)+TASKS_LONGPRESS_VIEW_TAG];
            [longPressView setAlpha:1.0];
            
            
            
        }
    }
}

- (void)updateLongpressView:(NSIndexPath *)tagField {
    // re-arrange cellse
}

- (NSIndexPath*) getCurrentlySelectedListCellPath
{
    return _currentlySelectedListCellPath;
}

- (void) setCurrentlySelectedListCellPath:(NSIndexPath *)cellValue
{
    _currentlySelectedListCellPath = cellValue;
}

- (NSInteger) getCurrentlySelectedListCell
{
    
    // Return the number of rows in the section.
    return _currentlySelectedListCell;
}

- (void) setCurrentlySelectedListCell:(int)cellValue
{
    _currentlySelectedListCell = cellValue;
}



// Details of cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TasksListCell";
    TasksListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    UILabel *tasksSubjectLine, *tasksTimeLine, *tasksPreview, *tasksCompleteIncomplete;
    UIImageView  *tasksAccountFlag, *alarm, *emailLink, *calendarLink, *tasksLink, *notesLink;
    
    
    // Configure the cell...
    
    
    NSInteger xpos = 10; //default x for title and names
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width; // screen width
    
    
    // tasks subject ----------------------------------------------------------------------
    tasksSubjectLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    tasksSubjectLine.tag = TASKS_SUBJECT_TAG;
    tasksSubjectLine.font = [UIFont boldSystemFontOfSize:15.0f];
    tasksSubjectLine.textColor = [UIColor blackColor];
    tasksSubjectLine.text = _tasksContentList[row][TASKS_VIEW_TITLE];
    
    // adjust preview size
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:tasksSubjectLine.text attributes:@{NSFontAttributeName: tasksSubjectLine.font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (rect.size.height <= 60 && rect.size.height >= 20)
    {
        tasksSubjectLine.numberOfLines = (rect.size.height / 20 ) + 2;
    }
    else if (rect.size.height > 60)
    {
        tasksSubjectLine.numberOfLines = 3;
        //tasksSubjectLine.
    }
    else if (rect.size.height < 20)
    {
        tasksSubjectLine.numberOfLines = 1;
    }
    [cell.contentView addSubview:tasksSubjectLine];
    
    NSInteger row2YPos = (tasksSubjectLine.numberOfLines > 1)  ? 40 : 30 ;
    //end tasks subject ----------------------------------------------------------------------
    
     
    //Only allow this when viewing all tasks
    // change background color and time color if the tasks has been completed
    if ([_tasksContentList[row][TASKS_VIEW_COMPLETE] isEqual: @true])
    {
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:234/255.0f alpha:1.0f];
        tasksTimeLine.textColor = _lightGrayAppColor;
        
    }
    else
    {
        tasksTimeLine.textColor = [UIColor blackColor];
    }
    
    [cell.contentView addSubview:tasksTimeLine];
    //end tasks time --------------------------------------------------------------------------------
    
    
    //tasks preview ---------------------------------------------------------------------------------
    tasksPreview = [[UILabel alloc] initWithFrame:CGRectMake(10, row2YPos, screenWidth-20, 20)];
    tasksPreview.tag = TASKS_PREVIEW_TAG;
    tasksPreview.textColor = _mediumGrayAppColor;
    tasksPreview.font = [UIFont systemFontOfSize:14.0f];
    tasksPreview.numberOfLines = 2;
    tasksPreview.text=_tasksContentList[row][TASKS_VIEW_PREVIEW];
    CGSize labelSize = [tasksPreview.text sizeWithFont:tasksPreview.font
                                     constrainedToSize:tasksPreview.frame.size
                                         lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labelHeight = labelSize.height;
    CGRect labelFrame = [tasksPreview frame];
    labelFrame.origin.y = row2YPos - 4;
    [tasksPreview setFrame:labelFrame];
    [cell.contentView addSubview:tasksPreview];
    
    attributedText =
    [[NSAttributedString alloc]
     initWithString:tasksPreview.text attributes:@{NSFontAttributeName: tasksPreview.font}];
    rect = [attributedText boundingRectWithSize:(CGSize){300, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    NSInteger alarmXPos = rect.size.width + 20;
    // end tasks preview -----------------------------------------------------------------------------
    
    
    
    
    
    // Links associated with Tasks -------------------------------------------------------------------
    NSInteger linkYPosition = row2YPos;
    NSInteger linkXPosition = 292;
    NSInteger linkXDelta = 20;
    
    if ([_tasksContentList[row][8] isEqual: @true])
    {
        notesLink = [[UIImageView alloc] initWithFrame:CGRectMake(linkXPosition, linkYPosition, CELL_ICON_WIDTH, CELL_ICON_HEIGHT)];
        notesLink.image = [UIImage imageNamed:@"PencilGrey@2x.png"];
        [cell.contentView addSubview: notesLink];
        linkXPosition -= linkXDelta;
    }

    if ([_tasksContentList[row][9] isEqual: @true])
    {
        emailLink = [[UIImageView alloc] initWithFrame:CGRectMake(linkXPosition, linkYPosition, CELL_ICON_WIDTH, CELL_ICON_HEIGHT)];
        emailLink.image = [UIImage imageNamed:@"MailGrey@2x.png"];
        [cell.contentView addSubview: emailLink];
        linkXPosition -= linkXDelta;
    }
    
    if ([_tasksContentList[row][10] isEqual:@true])
    {
        calendarLink = [[UIImageView alloc] initWithFrame:CGRectMake(linkXPosition, linkYPosition, CELL_ICON_WIDTH, CELL_ICON_HEIGHT)];
        calendarLink.image = [UIImage imageNamed:@"CalendarGrey@2x.png"];
        [cell.contentView addSubview: calendarLink];
        linkXPosition -= linkXDelta;
    }
    
    if ([_tasksContentList[row][10] isEqual:@true])
    {
        tasksLink = [[UIImageView alloc] initWithFrame:CGRectMake(linkXPosition, linkYPosition, CELL_ICON_WIDTH, CELL_ICON_HEIGHT)];
        tasksLink.image = [UIImage imageNamed:@"CheckGrey@2x.png"];
        [cell.contentView addSubview: tasksLink];
    }
    
    
    // end Links associated with Task ----------------------------------------------------------------
    
    
    // Alarm for task --------------------------------------------------------------------------------
    
    // Add check for if there is an alarm set
    
    alarm = [[UIImageView alloc] initWithFrame:CGRectMake(alarmXPos, row2YPos, 16, 16)];
    alarm.image = [UIImage imageNamed:@"AlarmClock@2x"];
    [cell.contentView addSubview:alarm];
    // End Alarm for task ----------------------------------------------------------------------------
    
    //tasks complete and incomplete ------------------------------------------------------------------
    tasksCompleteIncomplete = [[UILabel alloc] initWithFrame:CGRectMake(xpos, 12, 164, 21)];
    tasksCompleteIncomplete.tag = TASKS_INCOMPLETE_TAG;
    //tasksCompleteIncomplete.attributedText = tasksReadString;
    tasksCompleteIncomplete.font = [UIFont systemFontOfSize:14.0f];
    [cell.contentView addSubview:tasksCompleteIncomplete];
    //end tasks complete and incomplete --------------------------------------------------------------
    
    //tasks account flag ---------------------------------------------------------------------
    tasksAccountFlag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    tasksAccountFlag.image = [UIImage imageNamed:_tasksContentList[row][TASKS_VIEW_ACCOUNT_FLAG]];
    [cell.contentView addSubview:tasksAccountFlag];
    //end tasks account flag -----------------------------------------------------------------
    
    
    //tasks longpress overlay ----------------------------------------------------------------
    CGRect  viewRect = CGRectMake(0, 0, screenWidth, 98);
    UIView* longpressView = [[UIView alloc] initWithFrame:viewRect];
    longpressView.backgroundColor = _mediumGrayAppColor;
    longpressView.tag = 100*row+TASKS_LONGPRESS_VIEW_TAG;
    longpressView.alpha = 0.0f;
    
    NSInteger boxes = screenWidth/4;
    NSInteger padding = (boxes-36)/2;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 20, 36, 36)];
    imgView.image = [UIImage imageNamed:@"Trash@2x.png"];
    [longpressView addSubview: imgView];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(padding+boxes, 20, 36, 36)];
    imgView.image = [UIImage imageNamed:@"Spam@2x.png"];
    [longpressView addSubview: imgView];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(padding+(boxes*2), 20, 36, 36)];
    imgView.image = [UIImage imageNamed:@"LabelHome@2x.png"];
    [longpressView addSubview: imgView];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(padding+(boxes*3), 20, 36, 36)];
    imgView.image = [UIImage imageNamed:@"LinkHome@2x.png"];
    [longpressView addSubview: imgView];
    //draw the text labels for the icons
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, boxes, 16)];
    label.text = @"Delete";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [longpressView addSubview: label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(boxes, 60, boxes, 16)];
    label.text = @"Spam";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [longpressView addSubview: label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(boxes*2, 60, boxes, 16)];
    label.text = @"Label";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [longpressView addSubview: label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(boxes*3, 60, boxes, 16)];
    label.text = @"Link";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [longpressView addSubview: label];
    
    [cell.contentView addSubview:longpressView];
    //end longpress overlay ------------------------------------------------------------------
    
    //long press --------------------------------------------------------------------------
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.4;
    [cell addGestureRecognizer:longPress];
    //end long press ------------------------------------------------------------------------
    
    // taps
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [cell addGestureRecognizer:tapRecognizer];
    
    //end taps
    return cell;
}

- (void) tapped: (UIGestureRecognizer *)taps
{
    
    NSInteger theCurrentCell = [self getCurrentlySelectedListCell];
    CGPoint p = [taps locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    
    // a new cell was tapped when a cell was already in long hold
    if(theCurrentCell >= 0 && theCurrentCell != indexPath.row)
    {
        NSIndexPath *indexPath2 = [self getCurrentlySelectedListCellPath];
        [self updateLongpressView:indexPath2];
        
    }
    //a cell was tapped when no cell was in longpress mode
    else
    {
        
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"tasksTableCellController";
    /*
    TasksListCell *cell = (TasksListCell *)[(UITableView *)self.view cellForRowAtIndexPath:indexPath];
    NSInteger theCurrentCell = [self getCurrentlySelectedListCell];
    */
}

@end
