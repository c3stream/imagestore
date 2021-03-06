// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import "Status.h"


@implementation Status

@synthesize statusId;
@synthesize text;
@synthesize user;
@synthesize cellHeight;
@synthesize nameRect;
@synthesize textRect;

- (Status*)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        statusId = [[dic objectForKey:@"id"] longLongValue];
        text = [[dic objectForKey:@"text"] retain];
        
        NSDictionary* userDic = [dic objectForKey:@"user"];
        if (userDic) {
            user = [[User userWithDictionary:userDic] retain];
        }
    }
    return self;
}

- (void)dealloc
{
    [text release];
    [user release];
    [super dealloc];
}

+ (Status*)statusWithDictionary:(NSDictionary*)dic
{
    return [[[Status alloc] initWithDictionary:dic] autorelease];
}

- (void)calculateGeometries
{
    if (cellHeight > 0) return;
    
    float y = CELL_V_MARGIN;
    NSString* s;
    CGSize size;
    CGSize bounds;
    
    s = user.name;
    size = [s sizeWithFont:[UIFont boldSystemFontOfSize:CELL_NAME_FONT_SIZE] forWidth:CELL_CONTENT_WIDTH lineBreakMode:UILineBreakModeTailTruncation];
    nameRect = CGRectMake(CELL_LEFT, y, size.width, size.height);
    
    y += size.height;
    y += CELL_NAME_BOTTOM_MARGIN;
    
    bounds = CGSizeMake(CELL_CONTENT_WIDTH, CELL_TEXT_MAX_HEIGHT);
    
    s = text;
    size = [s sizeWithFont:[UIFont systemFontOfSize:CELL_TEXT_FONT_SIZE] constrainedToSize:bounds lineBreakMode:UILineBreakModeWordWrap];
    textRect = CGRectMake(CELL_LEFT, y, size.width, size.height);
    
    y += size.height;
    y += CELL_V_MARGIN;
    
    if (y < CELL_MIN_HEIGHT) y = CELL_MIN_HEIGHT;
    
    cellHeight = y;
}

@end
