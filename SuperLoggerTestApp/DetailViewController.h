//
//  DetailViewController.h
//  SuperLoggerTestApp
//
//  Created by Joel Fischer on 7/24/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

