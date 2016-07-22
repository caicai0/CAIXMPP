//
//  MessageViewController.m
//  CAIXmpp
//
//  Created by liyufeng on 16/4/23.
//  Copyright © 2016年 liyufeng. All rights reserved.
//

#import "MessageViewController.h"
#import "CAIXMPPManager.h"
#import "XMPPMessage.h"

@interface MessageViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)NSMutableArray * chatHistory;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSFetchedResultsController * fetchedResultsController;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getChatHistory];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getChatHistory
{
    XMPPMessageArchivingCoreDataStorage *storage = [CAIXMPPManager manager].xmppMessageArchivingCoreDataStorage;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.chatJID.bare];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[storage mainThreadManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
    
    [self.tableView reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"%s,%s",__FILE__,__FUNCTION__);
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    NSLog(@"%s,%s",__FILE__,__FUNCTION__);
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"%s,%s",__FILE__,__FUNCTION__);
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"%s,%s",__FILE__,__FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (nullable NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0){
    NSLog(@"%s,%s",__FILE__,__FUNCTION__);
    return nil;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cc"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cc"];
    }
    XMPPMessage *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = user.body;
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(XMPPMessage *)object {
    cell.textLabel.text = object.body;
}

@end
