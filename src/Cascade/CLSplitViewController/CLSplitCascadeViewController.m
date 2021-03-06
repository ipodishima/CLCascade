//
//  CLSplitCascadeViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLSplitCascadeViewController.h"
#import "CLSplitCascadeView.h"

#import "CLCategoriesViewController.h"
#import "CLCascadeNavigationController.h"

@implementation CLSplitCascadeViewController

@synthesize cascadeNavigationController = _cascadeNavigationController;
@synthesize categoriesViewController = _categoriesViewController;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    _categoriesViewController = nil;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadView {
    NSString *nib = self.nibName;
    if (nib) {
        NSBundle *bundle = self.nibBundle;
        if(!bundle) bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:nib ofType:@"nib"];
        
        if(path) {
            self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
            CLSplitCascadeView* view_ = (CLSplitCascadeView*)self.view;
            [view_ setCategoriesView: self.categoriesViewController.view];
            [view_ setCascadeView: self.cascadeNavigationController.view];

            return;
        }
    }
    
    CLSplitCascadeView* view_ = [[CLSplitCascadeView alloc] init];
    self.view = view_;
    
    [view_ setCategoriesView: self.categoriesViewController.view];
    [view_ setCascadeView: self.cascadeNavigationController.view];
    [view_ setSplitCascadeViewController:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.cascadeNavigationController = nil;
    self.categoriesViewController = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    [(CLSplitCascadeView*)self.view setIsRotating:YES];

    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if ([_cascadeNavigationController respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)]) {
        [_cascadeNavigationController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    }
    if ([_categoriesViewController respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)]) {
        [_categoriesViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [_cascadeNavigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [_categoriesViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [(CLSplitCascadeView*)self.view setIsRotating:NO];
}
#pragma mark - Present Controller


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) presentModalControllerFromMiddle:(UIViewController*)controller {
    [(CLSplitCascadeView*)self.view presentModalControllerFromMiddle:controller];  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dismissMiddleViewController {
   [(CLSplitCascadeView*)self.view dismissMiddleViewController];  
}

#pragma mark -
#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setBackgroundView:(UIView*)backgroundView {
    [(CLSplitCascadeView*)self.view setBackgroundView: backgroundView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setDividerImage:(UIImage*)image {
    [(CLSplitCascadeView*)self.view setVerticalDividerImage: image];
    
}


#pragma mark -
#pragma mark Setters 

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setCategoriesViewController:(CLCategoriesViewController *)viewController {
    if (viewController != _categoriesViewController) {
        _categoriesViewController = viewController;
        [(CLSplitCascadeView*)self.view setCategoriesView: viewController.view];
        
        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        #endif
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setCascadeNavigationController:(CLCascadeNavigationController *)viewController {
    if (viewController != _cascadeNavigationController) {
        _cascadeNavigationController = viewController;
        [(CLSplitCascadeView*)self.view setCascadeView: viewController.view];
    
        viewController.splitCascadeController = self;
        
        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        #endif
    }
}


@end
