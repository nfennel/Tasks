//
//  Tasks.m
//  Tasks
//
//  Created by Nathan Fennel on 1/21/14.
//  Copyright (c) 2014 Nathan Fennel. All rights reserved.
//

#import "Tasks.h"

@implementation Tasks

static NSMutableDictionary *allTask;
static NSString *currentKey;

+(NSMutableDictionary *)getAllTasks
{
    if (allTask == nil) {
        allTask = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[self filePath]]];
    }
    return allTask;
}

+(void)setCurrentKey:(NSString *)key
{
    currentKey = key;
}

+(NSString *)getCurrentKey
{
    return currentKey;
}

+(void)settaskForCurrentKey:(NSString *)task
{
    [self setTask:task forKey:currentKey];
}

+(void)setTask:(NSString *)task forKey:(NSString *)key
{
    [allTask setObject:task forKey:key];
}

+(void)removeTaskForKey:(NSString *)key
{
    [allTask removeObjectForKey:key];
}

+(void)saveTasks
{
    [allTask writeToFile:[self filePath] atomically:YES];
}

+(NSString *)filePath
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documents = [directories objectAtIndex:0];
    return [documents stringByAppendingString:allTask];
}

@end
