//
//  ViewController.h
//  Tasks
//
//  Created by Nathan Fennel on 1/19/14.
//  Copyright (c) 2014 Nathan Fennel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksListController : UITableViewController

// define values for the tasks array object--------------------------------------------
#define TASKS_VIEW_TITLE 0
#define TASKS_VIEW_AVATAR 1
#define TASKS_VIEW_PREVIEW 2
#define TASKS_VIEW_READ 3
#define TASKS_VIEW_TIME 4
#define TASKS_VIEW_NAMES 5
#define TASKS_VIEW_ACCOUNT_FLAG 6
#define TASKS_VIEW_NEW_TASKS 7
#define TASKS_VIEW_TOTAL_TASKS 8
//-------------------------------------------------------------------------------------

//define tags for List View Cells------------------------------------------------------
#define TASKS_SUBJECT_TAG 1
#define TASKS_AVATAR_TAG 2
#define TASKS_TIME_TAG 3
#define TASKS_NAMES_TAG 4
#define TASKS_UNREAD_TAG 5
#define TASKS_BLUE_DOT_TAG 6
#define TASKS_PREVIEW_TAG 7
#define TASKS_ACCOUNT_FLAG_TAG 8
#define TASKS_LONGPRESS_VIEW_TAG 9

//-------------------------------------------------------------------------------------

@property (nonatomic,strong) NSArray *tasksContentList;
@property (nonatomic,strong) UIColor *blueAppColor, *lightGrayAppColor, *mediumGrayAppColor;
@property (nonatomic,strong) NSIndexPath *currentlySelectedListCellPath;
@property (nonatomic, assign) int currentlySelectedListCell;


@end
