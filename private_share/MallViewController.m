//
//  MallViewController.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MallViewController.h"
#import "MerchandiseTableViewCell.h"
#import "MerchandiseService.h"
#import "ModalAnimation.h"
#import "MerchandiseDetailViewController2.h"
#import "ShoppingCartViewController.h"
#import "DateTimeUtil.h"
#import "Account.h"
#import "XXEventNameFilter.h"

#import "AccountPointsUpdatedEvent.h"
#import "ShoppingItemsChangedEvent.h"

@interface MallViewController ()

@end

@implementation MallViewController {
    ModalAnimation *modalAnimation;
    
    NSMutableArray *merchandises;
    NSInteger pageIndex;
    
    PullTableView *tblMerchandises;
//    UILabel *availablePointsLabel;
//    UILabel *remainPointsLabel;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        modalAnimation = [[ModalAnimation alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"mall_view_title", @"");
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ NSLocalizedString(@"chicked_recommend", @""), NSLocalizedString(@"all_merchandises", @"") ]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    CGRect frame = segmentedControl.frame;
    frame.size.width = 190;
    segmentedControl.frame = frame;
    self.navigationItem.titleView = segmentedControl;
    
    /*
    UIBarButtonItem *myExchangeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"my_exchange", @"") style:UIBarButtonItemStylePlain target:self action:@selector(showMyExchangeViewController)];
    self.navigationItem.rightBarButtonItem = myExchangeButton;
     */
    
    tblMerchandises = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    tblMerchandises.delegate = self;
    tblMerchandises.dataSource = self;
    tblMerchandises.pullDelegate = self;
    [self.view addSubview:tblMerchandises];
    
    /*
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 40, self.view.bounds.size.width, 40)];
    bottomBar.backgroundColor = [UIColor appSilver];
    
    UILabel *availablePointsLabelMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
    availablePointsLabelMessage.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"availablePoints", @"")];
    availablePointsLabelMessage.textColor = [UIColor darkGrayColor];
    availablePointsLabelMessage.backgroundColor = [UIColor clearColor];
    availablePointsLabelMessage.font = [UIFont systemFontOfSize:16.f];
    [bottomBar addSubview:availablePointsLabelMessage];
    availablePointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 80, 30)];
    availablePointsLabel.text = @"";
    availablePointsLabel.textColor = [UIColor darkGrayColor];
    availablePointsLabel.backgroundColor = [UIColor clearColor];
    availablePointsLabel.font = [UIFont systemFontOfSize:16.f];
    [bottomBar addSubview:availablePointsLabel];
     
    UIImageView *shoppingCartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 26, 26)];
    shoppingCartImageView.userInteractionEnabled = YES;
    shoppingCartImageView.image = [UIImage imageNamed:@"shopping_cart"];
    [bottomBar addSubview:shoppingCartImageView];
     
    remainPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 250, 30)];
    remainPointsLabel.text = @"";
    remainPointsLabel.textColor = [UIColor darkGrayColor];
    remainPointsLabel.backgroundColor = [UIColor clearColor];
    remainPointsLabel.font = [UIFont systemFontOfSize:15.f];
    remainPointsLabel.userInteractionEnabled = YES;
    [bottomBar addSubview:remainPointsLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [shoppingCartImageView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [remainPointsLabel addGestureRecognizer:tapGesture2];
    
    [self.view addSubview:bottomBar];
    */
    
    tblMerchandises.pullTableIsRefreshing = YES;
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.5f];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self.navigationController pushViewController:[[ShoppingCartViewController alloc] init] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // subscribe events
    XXEventNameFilter *filter = [[XXEventNameFilter alloc] initWithSupportedEventNames:[NSArray arrayWithObjects:kEventShoppingItemsChanged, kEventAccountPointsUpdated, nil]];
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:filter];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
    
    [self refreshAvailablePoints];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unsubscribe events
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)refresh {
    pageIndex = 0;
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getHentreStoreMerchandisesByPageIndex:pageIndex target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:) userInfo:[NSNumber numberWithInteger:pageIndex]];
}

- (void)loadMore {
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getHentreStoreMerchandisesByPageIndex:pageIndex + 1 target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:) userInfo:[NSNumber numberWithInteger:pageIndex + 1]];
}

- (void)refreshAvailablePoints {
    if([GlobalConfig defaultConfig].isLogin) {
        /*
        NSInteger availablePoints = [Account currentAccount].availablePoints;
//        if(availablePoints < 0) availablePoints = 0;
        availablePointsLabel.text = [NSString stringWithFormat:@"%d%@", availablePoints, NSLocalizedString(@"points_short", @"")];
         */
    }
    
    /*
    remainPointsLabel.text = [NSString stringWithFormat:@"总计: ￥%.1f%@     %@: %d%@",
                              payment.cash, NSLocalizedString(@"yuan", @""), NSLocalizedString(@"points", @""), payment.points, NSLocalizedString(@"points_short", @"")];
     */
}

- (void)getMerchandisesSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        NSInteger page = ((NSNumber *)resp.userInfo).integerValue;
        if(merchandises == nil) {
            merchandises = [NSMutableArray array];
        } else {
            if(page == 0) {
                [merchandises removeAllObjects];
            }
        }
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSUInteger lastIndex = merchandises.count;
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
                [merchandises addObject:[[Merchandise alloc] initWithDictionary:jsonObject]];
                if(page > 0) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:lastIndex + i inSection:0]];
                }
            }
        }
        
        if(page > 0) {
            if(jsonArray != nil && jsonArray.count > 0) {
                pageIndex++;
                [tblMerchandises beginUpdates];
                [tblMerchandises insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [tblMerchandises endUpdates];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
        } else {
            tblMerchandises.pullLastRefreshDate = [NSDate date];
            [tblMerchandises reloadData];
        }
        
        [self cancelRefresh];
        [self cancelLoadMore];
        
        return;
    }
    [self getMerchandisesfailure:resp];
}

- (void)getMerchandisesfailure:(HttpResponse *)resp {
    [self cancelRefresh];
    [self cancelLoadMore];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSLog(@"changed to %d", sender.selectedSegmentIndex);
}

#pragma mark -
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return merchandises == nil ? 0 : merchandises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    MerchandiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[MerchandiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.merchandise = [merchandises objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMerchandiseTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MerchandiseDetailViewController2 *controller = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:[merchandises objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
    /*
    controller.transitioningDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:^{ }];
     */
}


#pragma mark -
#pragma mark Pull Table View Delegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if(tblMerchandises.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if(tblMerchandises.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3f];
}

- (void)cancelRefresh {
    tblMerchandises.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    tblMerchandises.pullTableIsLoadingMore = NO;
}


#pragma mark -

/*
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    modalAnimation.modalAnimationType = ModalAnimationTypePresented;
    return modalAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    modalAnimation.modalAnimationType = ModalAnimationTypedismissed;
    return modalAnimation;
}
 */

#pragma mark -
#pragma mark XX Event Subscriber

- (NSString *)xxEventSubscriberIdentifier {
    return @"mallSubscriber";
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
#ifdef DEBUG
    NSLog(@"[Mall VC] Received [%@]", event.name);
#endif
    [self refreshAvailablePoints];
}

@end
