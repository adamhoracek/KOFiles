//
//  KOData.m
//  Kodiak
//
//  Created by Adam Horacek on 09.01.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOFiles
//	Twitter: http://twitter.com/becomekodiak
//  Mail: adam@becomekodiak.com, kuba@becomekodiak.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "KOData.h"
#import "KOFileObject.h"
#import "KOMenuObject.h"
#import "KOAppDelegate.h"

@implementation KOData

// Get the shared instance and create it if necessary.

+ (KOData *)sharedInstance {
    static KOData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KOData alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - Directory methods

- (NSMutableArray *)listDirectory {
	NSMutableArray *returnedArray = [NSMutableArray array];

	for (int i = 0; i < 12; i++) {
		KOFileObject *fileObject = [[KOFileObject alloc] init];
		[fileObject setBase:[NSString stringWithFormat:@"Item %d", i]];
		[fileObject setPath:@"/"];
		[fileObject setAncestorFileObjects:[NSMutableArray array]];
		[fileObject setSizeNumber:[NSNumber numberWithUnsignedLongLong:0]];
		[fileObject setCreatedDate:[NSDate date]];
		[fileObject setModifiedDate:[NSDate date]];
		[fileObject setDirectory:(i%2)];
		[fileObject setSizeNumber:[NSNumber numberWithInt:i]];
		[fileObject setNumberOfSubitems:i];
		[fileObject setSizeString:[NSString stringWithFormat:@"0 B"]];
		[fileObject setCreatedString:@"2012/08/13"];
		[fileObject setModifiedString:@"0 seconds ago"];
		
		[returnedArray addObject:fileObject];
	}
	return returnedArray;
}


- (NSArray *)getMenuObjectsForFile {
	KOMenuObject *runObject = [[KOMenuObject alloc] init];
	[runObject setTitle:@"Run"];
	[runObject setIconOn:@"icon-play2"];
	[runObject setIconOff:@"icon-play1"];
		
	KOMenuObject *viewObject = [[KOMenuObject alloc] init];
	[viewObject setTitle:@"View"];
	[viewObject setIconOn:@"icon-view2"];
	[viewObject setIconOff:@"icon-view1"];
		
	KOMenuObject *copyObject = [[KOMenuObject alloc] init];
	[copyObject setTitle:@"Copy"];
	[copyObject setIconOn:@"icon-copy2"];
	[copyObject setIconOff:@"icon-copy1"];
	
	KOMenuObject *moveObject = [[KOMenuObject alloc] init];
	[moveObject setTitle:@"Move"];
	[moveObject setIconOn:@"icon-move2"];
	[moveObject setIconOff:@"icon-move1"];
	
	KOMenuObject *renameObject = [[KOMenuObject alloc] init];
	[renameObject setTitle:@"Rename"];
	[renameObject setIconOn:@"icon-rename2"];
	[renameObject setIconOff:@"icon-rename1"];
	
	KOMenuObject *deleteObject = [[KOMenuObject alloc] init];
	[deleteObject setTitle:@"Delete"];
	[deleteObject setIconOn:@"icon-trash2"];
	[deleteObject setIconOff:@"icon-trash1"];
	
	KOMenuObject *exportObject = [[KOMenuObject alloc] init];
	[exportObject setTitle:@"Export"];
	[exportObject setIconOn:@"icon-export2"];
	[exportObject setIconOff:@"icon-export1"];
	
	return [NSArray arrayWithObjects:viewObject, copyObject, moveObject, renameObject, deleteObject, exportObject, nil];
}


@end
