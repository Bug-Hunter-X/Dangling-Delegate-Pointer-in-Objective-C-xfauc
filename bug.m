In Objective-C, a common yet subtle error arises when dealing with memory management and object lifecycles, particularly with delegate patterns.  Consider this scenario:

```objectivec
@interface MyViewController : UIViewController <MyDelegate>
@property (nonatomic, strong) MyObject *myObject;
@end

@implementation MyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myObject = [[MyObject alloc] init];
    self.myObject.delegate = self;
}

- (void)myObjectDidSomething:(MyObject *)object {
    // ... use object ...
}

- (void)dealloc {
    self.myObject.delegate = nil; // Crucial step often missed!
    [super dealloc];
}
@end
```

If `MyObject` holds a weak reference to its delegate (`__weak MyViewController *delegate;`), and `MyViewController` is deallocated without setting `self.myObject.delegate = nil;`, a dangling pointer results. When `MyObject` attempts to use the delegate later, a crash occurs because the delegate memory is already freed. This is especially insidious as it doesn't always lead to immediate crashes, but rather sporadic and hard-to-debug runtime errors.