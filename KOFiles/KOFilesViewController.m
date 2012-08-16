//
//  ViewController.m
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

#import "KOFilesViewController.h"
#import "KOFileTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "KOAppDelegate.h"
#import "KOData.h"
#import "KOFileObject.h"
#import "KOMenuObject.h"
#import "KOSegmentedControl.h"

@implementation KOFilesViewController

@synthesize fileTableView;
@synthesize fileSegmentedControl;
@synthesize shadowViewBottom, shadowViewTop;

@synthesize fileObject, fileObjects, selectedFileObjects;

#pragma mark - View lifecycle

- (KOFilesViewController *)initWithFileObject:(KOFileObject *)myDir
{
    self = [super init];
    self.fileObject = myDir;
    return self;
}

- (void)secondAnimate {
	KOFileTableViewCell *cell = (KOFileTableViewCell *)[fileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	[cell iconButtonTap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.fileObjects = [[KOData sharedInstance] listDirectory];
	self.selectedFileObjects = [NSMutableArray array];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.976 blue:0.957 alpha:1]]; /*#fff9f4*/
	
	fileTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	[fileTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[fileTableView setBackgroundColor:[UIColor clearColor]];
	[fileTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[fileTableView setDelegate:(id<UITableViewDelegate>)self];
	[fileTableView setDataSource:(id<UITableViewDataSource>)self];
	[fileTableView setShowsHorizontalScrollIndicator:NO];
	[self.view addSubview:fileTableView];
	
	CGRect rect = self.view.bounds;
	rect.origin.y = 0;
    rect.size.height = 3;
    
    shadowViewBottom = [[UIView alloc] initWithFrame:rect];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowViewBottom.frame];
    [shadowViewBottom.layer setMasksToBounds:YES];
	[shadowViewBottom.layer setShadowColor:[UIColor blackColor].CGColor];
	[shadowViewBottom.layer setShadowOffset:CGSizeMake(0.0f, -2.0f)];
    [shadowViewBottom.layer setShadowOpacity:0.55f];
    [shadowViewBottom.layer setShadowRadius:5.0f];
    [shadowViewBottom.layer setShadowPath:shadowPath.CGPath];
	
    [fileTableView setTableFooterView:shadowViewBottom];
    
    rect = CGRectMake(0, -20, 1084, 20);
    shadowViewTop = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:shadowViewTop];
    
	rect.origin.y = 20;
    rect.size.height = 3;
    shadowPath = [UIBezierPath bezierPathWithRect:rect];
    [shadowViewTop.layer setMasksToBounds:YES];
	[shadowViewTop.layer setShadowColor:[UIColor blackColor].CGColor];
	[shadowViewTop.layer setShadowOffset:CGSizeMake(0.0f, -2.0f)];
	[shadowViewTop.layer setShadowOpacity:0.55f];
	[shadowViewTop.layer setShadowRadius:5.0f];
	[shadowViewTop.layer setShadowPath:shadowPath.CGPath];
    
    // down shadow from sortbar
    rect = CGRectMake(-20, 0, 1084, 20);
    UIView *shadowView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:shadowView];
	
    rect.origin.y = 0;
    rect.size.height = 3;
	
    shadowPath = [UIBezierPath bezierPathWithRect:rect];
    [shadowView.layer setMasksToBounds:NO];
	[shadowView.layer setShadowColor:[UIColor blackColor].CGColor];
	[shadowView.layer setShadowOffset:CGSizeMake(0.0f, -2.0f)];
	[shadowView.layer setShadowOpacity:0.55f];
	[shadowView.layer setShadowRadius:3.0f];
	[shadowView.layer setShadowPath:shadowPath.CGPath];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    [self scrollViewDidScroll:fileTableView];
}

#pragma mark - UITableViewDatasource

- (void)scrollViewDidScroll:(UIScrollView *)tableView {
    CGRect frame = shadowViewTop.frame;
    frame.origin.y = tableView.frame.origin.y - tableView.contentOffset.y - shadowViewTop.frame.size.height;
    shadowViewTop.frame = frame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.fileObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	KOFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileTableViewCell"];
	if (!cell)
		cell = [[KOFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileTableViewCell"];
    
    // reset background for reused cells
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-cell-short"]];
	[backgroundImageView setContentMode:UIViewContentModeTopRight];
	[cell setBackgroundView:backgroundImageView];
	
	KOFileObject *fileObject1 = [self.fileObjects objectAtIndex:indexPath.row];
	
	cell.fileObject = fileObject1;
	
	[cell.iconButton setSelected:[self.selectedFileObjects containsObject:cell.fileObject]];
    
    // show "tall" bg if selected
    if ([cell.iconButton isSelected]) {
		if ([self.selectedFileObjects count] == 1) {
            [self applyTallBgAndSegmentedControlToCell:cell];
        }
    }
	
	if ([fileObject1 isDirectory]) {
		[cell setIsFile:NO];
		
		[cell.countLabel setHidden:NO];
		
		[cell.changedLabel setHidden:YES];
		[cell.changedValueLabel setHidden:YES];
		[cell.sizeLabel setHidden:YES];
		[cell.sizeValueLabel setHidden:YES];
		
		if ([fileObject1 numberOfSubitems])
			[cell.countLabel setText:[NSString stringWithFormat:@"%d", [fileObject1 numberOfSubitems]]];
		else
			[cell.countLabel setText:@"-"];
	} else {
		[cell setIsFile:YES];
		
		[cell.countLabel setHidden:YES];
		
		[cell.changedLabel setHidden:NO];
		[cell.changedValueLabel setHidden:NO];
		[cell.sizeLabel setHidden:NO];
		[cell.sizeValueLabel setHidden:NO];
	}
	
	[cell.titleTextField setText:[fileObject1 base]];
	[cell.titleTextField sizeToFit];
	
	[cell.createdValueLabel setText:[fileObject1 createdString]];
	[cell.sizeValueLabel setText:[fileObject1 sizeString]];
	[cell.changedValueLabel setText:[fileObject1 modifiedString]];
	
	[cell setDelegate:(id<KOFileTableViewCellDelegate>)self];
	[cell setIndexPath:indexPath];
	
	[cell.accessoryView setAutoresizingMask:UIViewAutoresizingNone];
    
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.selectedFileObjects count] == 1)
		if ([self.selectedFileObjects containsObject:[self.fileObjects objectAtIndex:indexPath.row]])
			return 140;
	return 85;
}

- (void)tapOnFileObject:(KOFileObject *)fileObject {
	//
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	KOFileTableViewCell *cell = (KOFileTableViewCell *)[fileTableView cellForRowAtIndexPath:indexPath];

	[self tapOnFileObject:cell.fileObject];
}

#pragma mark - Actions

- (void)updateFooter {
	CGRect rect = fileTableView.tableFooterView.frame;
	rect.size.height = 20;
	fileTableView.tableFooterView.frame = rect;
}

- (void)iconButtonAction:(KOFileTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {	
    cell.clipsToBounds = YES;
	
	if ([self.selectedFileObjects containsObject:cell.fileObject]) {
		[cell.iconButton setSelected:NO];		
		[self.selectedFileObjects removeObject:cell.fileObject];
	} else {
		[cell.iconButton setSelected:YES];
		
//		[self.selectedFileObjects removeAllObjects];
		[self.selectedFileObjects addObject:cell.fileObject];
	}
	
    [self performSelector:@selector(showOrHideFSC:) withObject:cell afterDelay:0.0];
}

- (void)showOrHideFSC:(KOFileTableViewCell *)cell
{
    	
	[fileTableView beginUpdates];
    
	if ([cell.iconButton isSelected]) {
		if ([self.selectedFileObjects count] == 1) {
			UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-cell-tall"]];
			[backgroundImageView setContentMode:UIViewContentModeTopRight];
			[cell setBackgroundView:backgroundImageView];
			
			
		} else if ([cell.contentView.subviews containsObject:fileSegmentedControl]){
			//[fileSegmentedControl removeFromSuperview];
			//fileSegmentedControl = nil;
		}
        [self performSelector:@selector(selektor2:) withObject:nil afterDelay:0.3];
	} else {
		[self performSelector:@selector(selektor:) withObject:cell afterDelay:0.3];
	}
	
	
	[self performSelector:@selector(updateAllCells)];

    
    [fileTableView endUpdates];
}

- (KOSegmentedControl *)createFileSegmentedControlForCell:(UITableViewCell *)cell
{
    NSMutableArray *menuObjs = [NSMutableArray array];
    
    for (KOMenuObject *menuObject in [[KOData sharedInstance] getMenuObjectsForFile]) {
        [menuObjs addObject:[UIImage imageNamed:menuObject.iconOn]];
    }
    
    KOSegmentedControl *f = [[KOSegmentedControl alloc] initWithItems:menuObjs];
    CGFloat percentage = 0.80;
    [f setFrame:CGRectMake(cell.frame.size.width * (1-percentage) / 2, 84, cell.frame.size.width * percentage, 56)];
    
    [f setMomentary:YES];
    [f setMenuObjects:[[KOData sharedInstance] getMenuObjectsForFile]];
    
    [f setSegmentedControlStyle:UISegmentedControlStyleBordered];
	[f addTarget:self action:@selector(fileSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [f setDividerImage:[UIImage imageNamed:@"transparent"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [f setDividerImage:[UIImage imageNamed:@"transparent"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [f setDividerImage:[UIImage imageNamed:@"transparent"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [f setBackgroundImage:[[UIImage imageNamed:@"transparent"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [f setBackgroundImage:[[UIImage imageNamed:@"transparent"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [f setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    return f;
}

- (void)applyTallBgAndSegmentedControlToCell:(UITableViewCell *)cell {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-cell-tall"]];
    [backgroundImageView setContentMode:UIViewContentModeTopRight];
    [cell setBackgroundView:backgroundImageView];
    
    if (true) {
        fileSegmentedControl = [self createFileSegmentedControlForCell:cell];
        
        for (UIView *v in cell.contentView.subviews) {
            if ([v isKindOfClass:[KOSegmentedControl class]]) [v removeFromSuperview];
        }
        
        [cell.contentView addSubview:fileSegmentedControl];
    }
}

- (void)updateAllCells {
	for (int section = 0; section < [fileTableView numberOfSections]; section++) {
		for (int row = 0; row < [fileTableView numberOfRowsInSection:section]; row++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
			KOFileTableViewCell *cell = (KOFileTableViewCell *)[fileTableView cellForRowAtIndexPath:indexPath];
			
			if ([self.selectedFileObjects containsObject:cell.fileObject]) {
				if ([self.selectedFileObjects count] == 1) {
                    [self applyTallBgAndSegmentedControlToCell:cell];
				} else
					[self performSelector:@selector(selektor:) withObject:cell afterDelay:0.3];
			} else {
				[self performSelector:@selector(selektor:) withObject:cell afterDelay:0.3];
			}
		}
	}
}

- (void)selektor:(KOFileTableViewCell *)cell {
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-cell-short"]];
	[backgroundImageView setContentMode:UIViewContentModeTopRight];
	[cell setBackgroundView:backgroundImageView];
	
	if ([cell.contentView.subviews containsObject:fileSegmentedControl]){
		[fileSegmentedControl removeFromSuperview];
		fileSegmentedControl = nil;
	}
    
    shadowViewBottom.hidden = NO;
    [self scrollViewDidScroll:fileTableView];
}

- (void)selektor2:(id)sender
{
    shadowViewBottom.hidden = NO;
    [self scrollViewDidScroll:fileTableView];
}

- (void)deselectSegmentAtIndex:(NSNumber *)index {
	[fileSegmentedControl setImage:[UIImage imageNamed:[(KOMenuObject *)[[fileSegmentedControl menuObjects] objectAtIndex:[index intValue]] iconOn]] forSegmentAtIndex:[index intValue]];
}


- (void)fileSegmentedControlValueChanged:(id)sender {
	NSInteger i = [(KOSegmentedControl *)sender selectedSegmentIndex];
	
	[fileSegmentedControl setImage:[UIImage imageNamed:[(KOMenuObject *)[[fileSegmentedControl menuObjects] objectAtIndex:i] iconOff]] forSegmentAtIndex:i];
		
	[self performSelector:@selector(deselectSegmentAtIndex:) withObject:[NSNumber numberWithInt:i] afterDelay:0.30f];
}

#pragma mark - KOFileTableViewDelegate
- (void)fileTableViewCell:(KOFileTableViewCell *)cell didTapIconAtIndexPath:(NSIndexPath *)indexPath {
	[self iconButtonAction:cell indexPath:indexPath];
}

@end