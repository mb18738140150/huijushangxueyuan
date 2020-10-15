//
//  CourseNoteOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/15.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "CourseNoteOperation.h"

@interface CourseNoteOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CourseNoteProtocol> notifiedObject;

@end

@implementation CourseNoteOperation

- (NSMutableArray *)courseNoteList
{
    if (!_courseNoteList) {
        _courseNoteList = [NSMutableArray array];
    }
    return _courseNoteList;
}

- (void)getCourseNoteWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseNoteProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.courseNoteList removeAllObjects];
    
    NSArray * noteArray = [[successInfo objectForKey:@"result"] objectForKey:@"chapterList"];
    for (NSDictionary * chapterInfo in noteArray) {
        NSArray * videoArray = [chapterInfo objectForKey:@"videoNotes"];
        for (NSDictionary * videoNote in videoArray) {
            
            NSArray * noteArray = [videoNote objectForKey:@"noteInfo"];
            
            for (NSDictionary * noteInfo in noteArray) {
                NSMutableDictionary * mVideoNote = [[NSMutableDictionary alloc]initWithDictionary:noteInfo];
                NSString * name = [NSString stringWithFormat:@"%@ %@", [chapterInfo objectForKey:@"name"], [videoNote objectForKey:@"name"]];
                [mVideoNote setValue:name forKey:@"name"];
                [mVideoNote setObject:[videoNote objectForKey:@"chapterId"] forKey:@"chapterId"];
                [mVideoNote setObject:[videoNote objectForKey:@"courseId"] forKey:@"courseId"];
                [self.courseNoteList addObject:mVideoNote];
            }
            
        }
    }
    
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCourseNoteSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCourseNoteFailed:failInfo];
    }
}
@end
