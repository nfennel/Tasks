//
//  Tasks.h
//  Tasks
//
//  Created by Nathan Fennel on 1/21/14.
//  Copyright (c) 2014 Nathan Fennel. All rights reserved.
//

#import <Foundation/Foundation.h>

#define allTasks @"tasks"
#define detailView @"showDetail"


@interface Tasks : NSObject

@property (nonatomic,strong) NSArray *tasksContentList;
@property (nonatomic,strong) NSDate *createdDate, *dueDate, *lastUpdate;
@property (nonatomic,strong) NSDate *alarmTime; // Time interval since 1970
@property (nonatomic,strong) NSString *taskSubject, *taskBody;

@property (nonatomic,strong) NSString *emailLink, *calendarLink, *tasklink, *noteLink;

@end