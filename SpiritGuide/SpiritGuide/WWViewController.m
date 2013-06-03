//
//  WWViewController.m
//  SpiritGuide
//
//  Created by Mason on 5/12/13.
//  Copyright (c) 2013 Wu Wei Wu. All rights reserved.
//

#import "WWViewController.h"
#import "WWSensorium.h"

@interface WWViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UITextView *glass;

- (IBAction)spectrum:(id)sender;

@end

@implementation WWViewController

WW_INIT_VIEW_CONTROLLER

- (void) setup {
        
    [[WWSensorium instance] setMedium:^(NSString *message) {
        CGPoint bottom = CGPointMake(0, self.glass.contentSize.height - self.glass.bounds.size.height);
        CGPoint offset = self.glass.contentOffset;
        BOOL scroll = bottom.y - offset.y < 50.0f;
        [self.glass setText:[self.glass.text stringByAppendingFormat:@"%@\n\n", message]];
        if (scroll) {
            [self.glass scrollRangeToVisible:NSMakeRange(self.glass.text.length, 0)];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    CALayer* layer = self.glass.layer;
    [layer setCornerRadius:10.0f];
}

- (void) viewDidAppear:(BOOL)animated {
    [[WWSensorium instance] sense];
}

- (IBAction)spectrum:(id)sender {
    
    UISegmentedControl* filter = (UISegmentedControl*)sender;
    
    [[WWSensorium instance] setMode:filter.selectedSegmentIndex];
    
}

@end
