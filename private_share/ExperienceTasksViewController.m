//
//  ExperienceTasksViewController.m
//  private_share
//
//  Created by Zhao yang on 6/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ExperienceTasksViewController.h"
#import "YouMiWall.h"
#import <Escore/YJFIntegralWall.h>
#import "PBOfferWall.h"
#import "DMOfferWallManager.h"
#import "GlobalConfig.h"

@implementation ExperienceTasksViewController {
    UITableView *taskTableView;
    
    DMOfferWallManager *domobOfferWall;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"体验类任务";
    
    taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStylePlain];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    [self.view addSubview:taskTableView];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    if(indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"youmi", @"");
        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
    } else if(indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"domob", @"");
        cell.imageView.image = [UIImage imageNamed:@"icon_domob"];
    } else if(indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"cocounion", @"");
        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
    } else if(indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"yijifen", @"");
        cell.imageView.image = [UIImage imageNamed:@"icon_yijifen"];
    }
    /*
    else if(indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"domob", @"");
        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
    }
    */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        [YouMiWall showOffers:YES didShowBlock:^{
        } didDismissBlock:^{
        }];
    } else if(indexPath.row == 1) {
        if(domobOfferWall == nil) {
            domobOfferWall = [[DMOfferWallManager alloc] initWithPublisherID:kDomobSecretKey andUserID:[GlobalConfig defaultConfig].userName];
            domobOfferWall.disableStoreKit = YES;
        }
        [domobOfferWall presentOfferWallWithType:eDMOfferWallTypeList];
    } else if(indexPath.row == 2) {
        [[PBOfferWall sharedOfferWall] loadOfferWall:[PBADRequest request]];
        [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
    } else if(indexPath.row == 3) {
        YJFIntegralWall *integralWall = [[YJFIntegralWall alloc]init]; if([integralWall isScoreShow]){
            //    integralWall.delegate = self;
            [self presentViewController:integralWall animated:YES completion:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

@end
