//
//  ViewController.m
//  BeaconsFind
//
//  Created by Giovane Possebon on 6/27/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ViewController.h"
#import "CellTableViewCell.h"

@interface ViewController ()

@property(nonatomic, strong) NSArray *beaconArray;

@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"INSERT UUID HERE"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"IDENTIFIER"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];

}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSArray *filteredBeacons = beacons;
    
    NSLog(@"%@", filteredBeacons);
    
    self.beaconArray = filteredBeacons;
    
    NSLog(@"%@", self.beaconArray);
    
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.beaconArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    CLBeacon *beacon = self.beaconArray[indexPath.row];
    
    NSLog(@"%@", beacon);
    
    cell.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
    cell.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    cell.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    cell.accuracyLabel.text = [NSString stringWithFormat:@"%f",beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
        cell.distanceLabel.text = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        cell.distanceLabel.text = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        cell.distanceLabel.text = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        cell.distanceLabel.text = @"Far";
    }
    cell.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
    
    return cell;
}

@end
