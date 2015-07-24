//
//  IKAppDelegate.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-9.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKHomeViewController.h"
#import "IKLoginViewController.h"
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <AdSupport/AdSupport.h>
#import "IKVisitCDSO.h"

@interface IKAppDelegate : UIResponder <UIApplicationDelegate,IKLoginViewControllerDelegate,IKClientsListDelegate,IKViewControllerDelegate,CLLocationManagerDelegate>{
    IKHomeViewController *vcHome;
    IKLoginViewController *vcLogin;
        
    //  Core Data
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIImagePickerController *imagePicker;
    
    //  GPS
    CLLocationManager *locationManager;
    BOOL invalidKeyDetected,networkFailed;
    
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong,readonly) UIImagePickerController *imagePicker;

//  Core Data
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong)IKVisitCDSO *visit;

@property UIBackgroundTaskIdentifier bgTask;
+ (BOOL)isTestVersion;

@end
