
#import "BaseViewController.h"
#import "MobClick.h"

@interface BaseViewController (){
    
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self ios7Fix];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRemoteNotification:) name:kRemoteNotificationReceived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkError:) name:kNotificationNetworkError object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receivedRemoteNotification:(NSNotification*)notification{
    //TODO:handle remote notification
}
-(void)onNetworkError:(NSNotification*)notification{
    //TODO:handle remote notification
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];

}

-(void)logClickEvent:(NSString*)name data:(NSDictionary*)data{
    [MobClick event:name attributes:data];
}

@end
