# M5ApplicationOpenURL

Respond to application open URL event on iOS *and* Mac *without owning/muddying the app delegate*. Easy. Decoupled.

## Usage

```objective-c
- (BOOL)applicationOpenURL:(NSURL *)URL fromApplication:(NSString *)sourceApplication {
	NSLog(@"Opened via %@ from source application %@.", URL.absoluteString, sourceApplication);
	
	if (/*some check against URL*/) {
		return YES;
	}
	
	return NO;
}

...

[M5ApplicationOpenURL addHandlerWithTarget:self selector:@selector(applicationOpenURL:fromApplication:)];

//OR

[M5ApplicationOpenURL addHandlerWithCallback:^BOOL(NSURL *URL, NSString *sourceApplication) {
	NSLog(@"Opened via %@ from source application %@.", URL.absoluteString, sourceApplication);
		
	if (/*some check against URL*/) {
		return YES;
	}
		
	return NO;
}];
```
