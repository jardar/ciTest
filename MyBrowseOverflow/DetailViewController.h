//
//  DetailViewController.h
//  MyBrowseOverflow
//
//  Created by JarDar on 13/8/30.
//  Copyright (c) 2013年 JarDar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
