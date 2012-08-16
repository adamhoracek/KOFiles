//
//  KOFileTableViewCell.m
//  Kodiak
//
//  Created by Adam Horacek on 02.03.12.
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

#import "KOFileTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "KOLabel.h"
#import "KOAppDelegate.h"
#import "KOFilesViewController.h"

#define KOCOLOR_FILES_TITLE [UIColor colorWithRed:0.4 green:0.357 blue:0.325 alpha:1] /*#665b53*/
#define KOCOLOR_FILES_TITLE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define KOCOLOR_FILES_COUNTER [UIColor colorWithRed:0.608 green:0.376 blue:0.251 alpha:1] /*#9b6040*/
#define KOCOLOR_FILES_COUNTER_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35] /*#ffffff*/
#define KOCOLOR_FILES_SUBTITLE [UIColor colorWithRed:0.694 green:0.639 blue:0.6 alpha:1] /*#b1a399*/
#define KOCOLOR_FILES_SUBTITLE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define KOCOLOR_FILES_SUBTITLE_VALUE [UIColor colorWithRed:0.694 green:0.639 blue:0.6 alpha:1] /*#b1a399*/
#define KOCOLOR_FILES_SUBTITLE_VALUE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/

#define KOFONT_FILES_TITLE [UIFont fontWithName:@"HelveticaNeue" size:24.0f]
#define KOFONT_FILES_COUNTER [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]
#define KOFONT_FILES_SUBTITLE [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f]
#define KOFONT_FILES_SUBTITLE_VALUE [UIFont fontWithName:@"HelveticaNeue" size:13.0f]

@implementation KOFileTableViewCell

@synthesize backgroundImageView, swipeRecognizer;
@synthesize iconButton;
@synthesize isFile;
@synthesize titleTextField;
@synthesize createdLabel, createdValueLabel, sizeLabel, sizeValueLabel, changedLabel, changedValueLabel, countLabel;
@synthesize delegate;
@synthesize indexPath;
@synthesize fileObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
		backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-cell-short"]];
		[backgroundImageView setContentMode:UIViewContentModeTopRight];
		
		[self setBackgroundView:backgroundImageView];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		[self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		
		iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[iconButton setAdjustsImageWhenHighlighted:NO];
		[iconButton addTarget:self action:@selector(iconButtonAction:forEvent:) forControlEvents:UIControlEventTouchDown];
		
		[self.contentView addSubview:iconButton];
		
		titleTextField = [[UITextField alloc] init];
		[titleTextField setFont:KOFONT_FILES_TITLE];

		//	[titleTextField setTextColor:[UIColor colorWithHexString:@"665b53"]];
		[titleTextField setTextColor:KOCOLOR_FILES_TITLE];
		
		[titleTextField.layer setShadowColor:KOCOLOR_FILES_TITLE_SHADOW.CGColor];
		[titleTextField.layer setShadowOffset:CGSizeMake(0, 1)];
		[titleTextField.layer setShadowOpacity:1.0f];
		[titleTextField.layer setShadowRadius:0.0f];
		
		[titleTextField setUserInteractionEnabled:NO];
		[titleTextField setBackgroundColor:[UIColor clearColor]];
		[titleTextField sizeToFit];
		[titleTextField setFrame:CGRectMake(108, 14, titleTextField.frame.size.width, titleTextField.frame.size.height)];
		[self.contentView addSubview:titleTextField];
		
		
		
		createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 50, 54, 18)];
		[createdLabel setText:@"Created:"];
		[createdLabel setFont:KOFONT_FILES_SUBTITLE];
		[createdLabel setTextColor:KOCOLOR_FILES_SUBTITLE];
		[createdLabel setShadowColor:KOCOLOR_FILES_SUBTITLE_SHADOW];
		[createdLabel setShadowOffset:CGSizeMake(0, 1)];
		[createdLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:createdLabel];
		
		createdValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(168, 50, 70, 18)];
		[createdValueLabel setFont:KOFONT_FILES_SUBTITLE_VALUE];
		[createdValueLabel setTextColor:KOCOLOR_FILES_SUBTITLE_VALUE];
		[createdValueLabel setShadowColor:KOCOLOR_FILES_SUBTITLE_VALUE_SHADOW];
		[createdValueLabel setShadowOffset:CGSizeMake(0, 1)];
		[createdValueLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:createdValueLabel];
		
		sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(254, 50, 32, 18)];
		[sizeLabel setText:@"Size:"];
		[sizeLabel setFont:KOFONT_FILES_SUBTITLE];
		[sizeLabel setTextColor:KOCOLOR_FILES_SUBTITLE];
		[sizeLabel setShadowColor:KOCOLOR_FILES_SUBTITLE_SHADOW];
		[sizeLabel setShadowOffset:CGSizeMake(0, 1)];
		[sizeLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:sizeLabel];
		
		sizeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(298, 50, 44, 18)];
		[sizeValueLabel setFont:KOFONT_FILES_SUBTITLE_VALUE];
		[sizeValueLabel setTextColor:KOCOLOR_FILES_SUBTITLE_VALUE];
		[sizeValueLabel setShadowColor:KOCOLOR_FILES_SUBTITLE_VALUE_SHADOW];
		[sizeValueLabel setShadowOffset:CGSizeMake(0, 1)];
		[sizeValueLabel setBackgroundColor:[UIColor clearColor]];
        [sizeValueLabel setTextAlignment:UITextAlignmentRight];
		[self.contentView addSubview:sizeValueLabel];
		
		changedLabel = [[UILabel alloc] initWithFrame:CGRectMake(370, 50, 91, 18)];
		[changedLabel setText:@"Last changed:"];
		[changedLabel setFont:KOFONT_FILES_SUBTITLE];
		[changedLabel setTextColor:KOCOLOR_FILES_SUBTITLE];
		[changedLabel setShadowColor:KOCOLOR_FILES_SUBTITLE_SHADOW];
		[changedLabel setShadowOffset:CGSizeMake(0, 1)];
		[changedLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:changedLabel];
		
		changedValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(472, 50, 122, 18)];
		[changedValueLabel setFont:KOFONT_FILES_SUBTITLE_VALUE];
		[changedValueLabel setTextColor:KOCOLOR_FILES_SUBTITLE_VALUE];
		[changedValueLabel setShadowColor:KOCOLOR_FILES_SUBTITLE_VALUE_SHADOW];
		[changedValueLabel setShadowOffset:CGSizeMake(0, 1)];
		[changedValueLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:changedValueLabel];
		
		[self.layer setMasksToBounds:YES];
		
		countLabel = [[KOLabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 69, 0, 47, 28)];
		
		[countLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
		[countLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"item-counter"]]];
		[countLabel setTextAlignment:UITextAlignmentCenter];
		[countLabel setLineBreakMode:UILineBreakModeMiddleTruncation];
		[countLabel setFont:KOFONT_FILES_COUNTER];
		[countLabel setTextColor:KOCOLOR_FILES_COUNTER];
		[countLabel setShadowColor:KOCOLOR_FILES_COUNTER_SHADOW];
		[countLabel setShadowOffset:CGSizeMake(0, 1)];

		[countLabel setHidden:YES];
        [self.contentView addSubview:countLabel];
//		[self setAccessoryView:countLabel];
        
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRecognizer];
    }
    return self;
}

- (void)swipe:(id)sender
{
    [self iconButtonTap];
}

- (void)setIsFile:(BOOL)is {
	if (is) {
		[iconButton setImage:[UIImage imageNamed:@"item-icon-file"] forState:UIControlStateNormal];
		[iconButton setImage:[UIImage imageNamed:@"item-icon-file-selected"] forState:UIControlStateSelected];
		[iconButton setImage:[UIImage imageNamed:@"item-icon-file-selected"] forState:UIControlStateHighlighted];
		//			[iconButton setFrame:CGRectMake(50, 28, 28, 33)];
		[iconButton setFrame:CGRectMake(0, 0, 100, 85)];
		
	} else {
		[iconButton setImage:[UIImage imageNamed:@"item-icon-folder"] forState:UIControlStateNormal];
		[iconButton setImage:[UIImage imageNamed:@"item-icon-folder-selected"] forState:UIControlStateSelected];
		[iconButton setImage:[UIImage imageNamed:@"item-icon-folder-selected"] forState:UIControlStateHighlighted];
		//			[iconButton setFrame:CGRectMake(50, 28, 32, 26)];
		[iconButton setFrame:CGRectMake(0, 0, 100, 85)];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)iconButtonAction:(id)sender forEvent:(UIEvent *)event {
	if (delegate && [delegate respondsToSelector:@selector(fileTableViewCell:didTapIconAtIndexPath:)]) {
		[delegate fileTableViewCell:(KOFileTableViewCell *)self didTapIconAtIndexPath:(NSIndexPath *)indexPath];	
	}
}

- (void)iconButtonTap {
	if (delegate && [delegate respondsToSelector:@selector(fileTableViewCell:didTapIconAtIndexPath:)]) {
		[delegate fileTableViewCell:(KOFileTableViewCell *)self didTapIconAtIndexPath:(NSIndexPath *)indexPath];	
	}
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

@end
