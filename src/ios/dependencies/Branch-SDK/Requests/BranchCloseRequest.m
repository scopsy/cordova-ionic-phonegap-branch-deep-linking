//
//  BranchCloseRequest.m
//  Branch-TestBed
//
//  Created by Graham Mueller on 5/26/15.
//  Copyright (c) 2015 Branch Metrics. All rights reserved.
//

#import "BranchCloseRequest.h"
#import "BNCPreferenceHelper.h"
#import "BranchConstants.h"
#import "BranchContentDiscoveryManifest.h"

@implementation BranchCloseRequest

- (void)makeRequest:(BNCServerInterface *)serverInterface key:(NSString *)key callback:(BNCServerCallback)callback {
    BNCPreferenceHelper *preferenceHelper = [BNCPreferenceHelper preferenceHelper];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:preferenceHelper.identityID forKey:BRANCH_REQUEST_KEY_BRANCH_IDENTITY];
    [params setObject:preferenceHelper.sessionID forKey:BRANCH_REQUEST_KEY_SESSION_ID];
    [params setObject:preferenceHelper.deviceFingerprintID forKey:BRANCH_REQUEST_KEY_DEVICE_FINGERPRINT_ID];
    
    NSDictionary *branchAnalyticsObj = [preferenceHelper getBranchAnalyticsData];
    if (branchAnalyticsObj && branchAnalyticsObj.count > 0) {
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:branchAnalyticsObj
                                                                  format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];
        if ([data length] < [BranchContentDiscoveryManifest getInstance].maxPktSize) {
            [params setObject:branchAnalyticsObj forKey:BRANCH_CONTENT_DISCOVER_KEY];
        }
        [preferenceHelper clearBranchAnalyticsData];
    }
    [serverInterface postRequest:params url:[preferenceHelper getAPIURL:BRANCH_REQUEST_ENDPOINT_CLOSE] key:key callback:callback];
    
}

- (void)processResponse:(BNCServerResponse *)response error:(NSError *)error {
    // Nothing to see here
}

@end
