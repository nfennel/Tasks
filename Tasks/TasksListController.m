//
//  ViewController.m
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
    
    // _tasks Content list key TITLE:String, AVATAR:String, DESCRIPTION:String, READ:Boolean, TIME:String, ACCOUNT FLAG:String, New Email:int, Total Email:int
    
    _tasksContentList =@[@[@"How's it going",@"bgoss@incubate.co",@"Just wanted to see what you are up to and how things have been. is everything ok in your corner of the world. hit me up with what's going on this weekend",@false,@"8:10p",@"Brian Goss",@"redTri.png",@"4",@"7",],
                         @[@"Who went to the party last night",@"jgoss@incubate.co",@"If you went to the party did you see my keys?",@true,@"7:12p",@"Jeff Goss",@"redTri.png",@"0",@"4",],
                         @[@"Are you going to the meeting?",@"nfennel@incubate.co",@"Are you going to be here in time for the meeting? what time do you think you will get here if you are?",@false,@"5:14a",@"Nathan",@"blueTri.png",@"3",@"20"],
                         @[@"What Time is the Party?",@"nproulx@incubate.co",@"What time should I arrive?",@false,@"3:14a",@"Noel Proulx",@"blueTri.png",@"1",@"5"],
                         @[@"Hey Check this out",@"tchmieleski@incubate.co",@"I thought that this article was really useful. take a look and let me know what you think and if we should use this method",@true,@"Tue",@"Troy Chmieleski",@"blueTri.png",@"0",@"1"]];

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
    return 98;
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
            static NSString *CellIdentifier = @"TasksListCell";
            TasksListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            UIView *longPressView = (UIView*)[self.view viewWithTag:(indexPath.row*100)+TASKS_LONGPRESS_VIEW_TAG];
            [longPressView setAlpha:1.0];
            
            
            
        }
    }
}

- (void)updateLongpressView:(NSIndexPath *)tagField {
    UIView *longPressView = (UIView*)[self.view viewWithTag:(tagField.row*100)+TASKS_LONGPRESS_VIEW_TAG];
    [longPressView setAlpha:0.0];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TASKSListCell";
    TasksListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    UILabel *tasksSubjectLine, *tasksTimeLine, *tasksPreview, *tasksReadUnread;
    UIImageView  *tasksAccountFlag, *dotImgView;
    
    
    // Configure the cell...
    
    
    int xpos = 49; //default x for title and names
    int xpos2 = 0; // for the blue dot
    int screenWidth = [UIScreen mainScreen].bounds.size.width; // screen width
    
    NSString *defaultURL = @"default";
    /*
    NSURL *gravatarDefaultURL = [GravatarHelper getGravatarURL:defaultURL];
    
    NSData *imageDefaultData = [NSData dataWithContentsOfURL:gravatarDefaultURL];
    */
    
    //compile the unread/total taskss and names
    NSString *readUnreadPlaceholder =[NSString stringWithFormat:@"%@/%@ %@", _tasksContentList[row][TASKS_VIEW_NEW_TASKS],_tasksContentList[row][TASKS_VIEW_TOTAL_TASKS], _tasksContentList[row][TASKS_VIEW_NAMES]];
    NSMutableAttributedString *tasksReadString = [[NSMutableAttributedString alloc]initWithString:readUnreadPlaceholder];
    
    if([_tasksContentList[row][TASKS_VIEW_AVATAR] isEqual: @""])
    {
        xpos = 9;// if there is no avatar image drop the title and names to the left
    }
    
    //check if any emails are unread - if so add dot and change unread number to blue
    if([_tasksContentList[row][TASKS_VIEW_NEW_TASKS] isEqual: @"0"])
    {
        //no unread emails default to grey for the entire string
        [tasksReadString addAttribute:NSForegroundColorAttributeName value:_mediumGrayAppColor range:NSMakeRange(0, readUnreadPlaceholder.length)];
    }
    else{
        //add the dot
        dotImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xpos, 18, 10, 10)];
        dotImgView.image = [UIImage imageNamed:@"NewMail@2x.png"];
        [cell.contentView addSubview: dotImgView];
        xpos2 = 12;
        // to change the color of unread emails to blue
        NSString *getLength = _tasksContentList[row][TASKS_VIEW_NEW_TASKS];
        NSRange range = NSMakeRange (0, getLength.length);
        [tasksReadString addAttribute:NSForegroundColorAttributeName value:_mediumGrayAppColor range:NSMakeRange(0, readUnreadPlaceholder.length)];
        [tasksReadString addAttribute:NSForegroundColorAttributeName value:_blueAppColor range:range];
    }
    
    // tasks subject ----------------------------------------------------------------------
    tasksSubjectLine = [[UILabel alloc] initWithFrame:CGRectMake(xpos, 27, 243, 21)];
    tasksSubjectLine.tag = TASKS_SUBJECT_TAG;
    tasksSubjectLine.font = [UIFont boldSystemFontOfSize:15.0f];
    tasksSubjectLine.textColor = [UIColor blackColor];
    tasksSubjectLine.numberOfLines = 1;
    tasksSubjectLine.text = _tasksContentList[row][TASKS_VIEW_TITLE];
    [cell.contentView addSubview:tasksSubjectLine];
    //end tasks subject ----------------------------------------------------------------------
    
    
    //tasks time and if flagged as email read ------------------------------------------------
    tasksTimeLine = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-66, 12, 60, 21)];
    tasksTimeLine.tag = TASKS_TIME_TAG;
    tasksTimeLine.font = [UIFont systemFontOfSize:14.0f];
    tasksTimeLine.numberOfLines = 1;
    tasksTimeLine.text = _tasksContentList[row][TASKS_VIEW_TIME];
    tasksTimeLine.textAlignment = NSTextAlignmentRight;
    // change background color and time color if the tasks has been read
    if ([_tasksContentList[row][TASKS_VIEW_READ] isEqual: @true])
    {
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:234/255.0f alpha:1.0f];
        tasksTimeLine.textColor = _lightGrayAppColor;
        
    }
    else
    {
        tasksTimeLine.textColor = [UIColor blackColor];
    }
    
    [cell.contentView addSubview:tasksTimeLine];
    //end tasks time -------------------------------------------------------------------------
    
    
    //tasks preview --------------------------------------------------------------------------
    tasksPreview = [[UILabel alloc] initWithFrame:CGRectMake(9, 49, screenWidth-15, 35)];
    tasksPreview.tag = TASKS_PREVIEW_TAG;
    tasksPreview.textColor = _mediumGrayAppColor;
    tasksPreview.font = [UIFont systemFontOfSize:14.0f];
    tasksPreview.numberOfLines = 2;
    tasksPreview.text=_tasksContentList[row][TASKS_VIEW_PREVIEW];
    CGSize labelSize = [tasksPreview.text sizeWithFont:tasksPreview.font
                                     constrainedToSize:tasksPreview.frame.size
                                         lineBreakMode:UILineBreakModeWordWrap];
    CGFloat labelHeight = labelSize.height;
    if(labelHeight<18) //adjust y location if only one line of text in the preview
    {
        CGRect labelFrame = [tasksPreview frame];
        labelFrame.origin.y = 40;
        [tasksPreview setFrame:labelFrame];
    }
    [cell.contentView addSubview:tasksPreview];
    // end tasks preview ---------------------------------------------------------------------
    
    
    //tasks read and unread ------------------------------------------------------------------
    tasksReadUnread = [[UILabel alloc] initWithFrame:CGRectMake(xpos+xpos2, 12, 164, 21)];
    tasksReadUnread.tag = TASKS_UNREAD_TAG;
    tasksReadUnread.attributedText = tasksReadString;
    tasksReadUnread.font = [UIFont systemFontOfSize:14.0f];
    [cell.contentView addSubview:tasksReadUnread];
    //end tasks read and unread --------------------------------------------------------------
    
    
    /*email avatar ---------------------------------------------------------------------------
    UIImageView *emailAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 36, 36)];
    NSString *newURL = _emailContentList[row][TASKS_VIEW_AVATAR];
    NSURL *gravatarURL = [GravatarHelper getGravatarURL:newURL];
    NSData *imageData = [NSData dataWithContentsOfURL:gravatarURL];
    
    if(imageData !=nil)
    {
        emailAvatar.image = [UIImage imageWithData:imageData];
        emailAvatar.layer.cornerRadius = AVATAR_CORNER_RADIUS;
        emailAvatar.layer.masksToBounds = YES;
        [cell.contentView addSubview: emailAvatar];
    }
    else
    {
        
        CGRect avatarFrame = [emailSubjectLine frame];
        avatarFrame.origin.x=9;
        [emailSubjectLine setFrame:avatarFrame];
        avatarFrame = [emailReadUnread frame];
        avatarFrame.origin.x=9+xpos2;
        [emailReadUnread setFrame: avatarFrame];
        if(xpos2>0)
        {
            avatarFrame = [dotImgView frame];
            avatarFrame.origin.x = 9;
            [dotImgView setFrame:avatarFrame];
        }
    }
    //end email avatar -----------------------------------------------------------------------
    */
    
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
    
    int boxes = screenWidth/4;
    int padding = (boxes-36)/2;
    
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
    if(theCurrentCell > -1 && theCurrentCell != indexPath.row)
    {
        NSIndexPath *indexPath2 = [self getCurrentlySelectedListCellPath];
        [self updateLongpressView:indexPath2];
        
    }
    //is tapping inside a cell in longpress handle menu
    else if(theCurrentCell == indexPath.row)
    {
        
        int pointPressed = p.x, boxes=[UIScreen mainScreen].bounds.size.width/4,section=0;
        if(pointPressed<=boxes){section=1;} //delete
        else if(pointPressed >boxes && pointPressed<=(boxes*2)){section=2;}//spam
        else if(pointPressed >boxes && pointPressed<=(boxes*3)){section=3;}//label
        else {section=4;}//link
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"LONG HOLD REVISITED" message:[NSString stringWithFormat:@"area %i was tapped in longpress mode", section] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mes show];
    }
    //a cell was tapped when no cell was in longpress mode
    else
    {
        
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"tasksTableCellController";
    TasksListCell *cell = (TasksListCell *)[(UITableView *)self.view cellForRowAtIndexPath:indexPath];
    NSInteger theCurrentCell = [self getCurrentlySelectedListCell];
}

@end
