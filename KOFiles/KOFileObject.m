//
//  KOFileObject.m
//  Kodiak
//
//  Created by Adam Horacek on 13.04.12.
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

#import "KOFileObject.h"

@implementation KOFileObject

@synthesize base, path, extension;
@synthesize directory;
@synthesize sizeNumber;
@synthesize sizeString;
@synthesize createdDate, modifiedDate;
@synthesize createdString, modifiedString;
@synthesize numberOfSubitems;
@synthesize numberOfLines;
@synthesize parentFileObject;
@synthesize ancestorFileObjects;
@synthesize submersionLevel;

- (BOOL)isDirectory {
	return directory;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToFileObject:other];
}

- (BOOL)isEqualToFileObject:(KOFileObject *)fileObject {
	if (self == fileObject)
        return YES;

	if ([base isEqualToString:fileObject.base])
		if ([path isEqualToString:fileObject.path])
			if ([extension isEqualToString:fileObject.extension])
				if (directory == fileObject.directory)
					if ([sizeNumber isEqualToNumber:fileObject.sizeNumber])
						if ([createdDate isEqualToDate:fileObject.createdDate])
							if ([modifiedDate isEqualToDate:fileObject.modifiedDate])
								if (numberOfSubitems == fileObject.numberOfSubitems)
									return YES;
	
	return NO;
}

@end
