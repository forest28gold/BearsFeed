//
//  DataModel.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize dbHandler;

+ (BOOL)createTable:(sqlite3 *)dbHandler {
	NSString* strQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);", TABLE_USER, FIELD_USER_ID, FIELD_DEVICE_ID, FIELD_USERNAME, FIELD_EMAIL, FIELD_PASSWORD, FIELD_BIO, FIELD_PHOTO_URL, FIELD_SIGNUP, FIELD_BEARS_SCORE, FIELD_USER_ROLE, FIELD_FB_ID];
    
	if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
		return NO;

	return YES;
}

- (id)initWithDBHandler:(sqlite3*)_dbHandler {
	self = [super init];
	
	if (self) {
		self.dbHandler = _dbHandler;
        
		NSString *strQuery_user = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_USER];
        sqlite3_stmt* stmt_user;
		
		if (sqlite3_prepare_v2(dbHandler, [strQuery_user UTF8String], -1, &stmt_user, NULL) == SQLITE_OK) {
			//int userId;
            [GlobalData sharedGlobalData].g_userData = [[UserData alloc] init];
			while(sqlite3_step(stmt_user) == SQLITE_ROW) {
               UserData * record = [[UserData alloc] init];
                record.userId = @"";
                record.deviceId = @"";
                record.userName = @"";
                record.email = @"";
                record.password = @"";
                record.bio = @"";
                record.photoUrl = @"";
                record.signup = @"";
                record.score = 0;
                record.socialRole = @"";
                record.fbId = @"";
                record.verificationCode = @"";
                
				char *userId = (char*)sqlite3_column_text(stmt_user, 0);
                char *deviceId = (char*)sqlite3_column_text(stmt_user, 1);
                char *userName = (char*)sqlite3_column_text(stmt_user, 2);
                char *email = (char*)sqlite3_column_text(stmt_user, 3);
                char *password = (char*)sqlite3_column_text(stmt_user, 4);
                char *verificationCode = (char*)sqlite3_column_text(stmt_user, 5);
                char *photoUrl = (char*)sqlite3_column_text(stmt_user, 6);
                char *signup = (char*)sqlite3_column_text(stmt_user, 7);
                char *score = (char*)sqlite3_column_text(stmt_user, 8);
                char *socialRole = (char*)sqlite3_column_text(stmt_user, 9);
                char *fbId = (char*)sqlite3_column_text(stmt_user, 10);
                
				if (userId != nil)
					record.userId = [NSString stringWithUTF8String:userId];
                
                if (deviceId != nil)
                    record.deviceId = [NSString stringWithUTF8String:deviceId];
                
                if (userName != nil)
                    record.userName = [NSString stringWithUTF8String:userName];
                
                if (email != nil)
                    record.email = [NSString stringWithUTF8String:email];
                
                if (password != nil)
                    record.password = [NSString stringWithUTF8String:password];
                
                if (verificationCode != nil)
                    record.verificationCode = [NSString stringWithUTF8String:verificationCode];
                
                if (photoUrl != nil)
                    record.photoUrl = [NSString stringWithUTF8String:photoUrl];
                
                if (signup != nil)
                    record.signup = [NSString stringWithUTF8String:signup];
                
                if (score != nil)
                    record.score = (int)[[NSString stringWithUTF8String:score] integerValue];
                
                if (socialRole != nil)
                    record.socialRole = [NSString stringWithUTF8String:socialRole];
                
                if (fbId != nil)
                    record.fbId = [NSString stringWithUTF8String:fbId];

                [GlobalData sharedGlobalData].g_userData = record;
                
			}
            sqlite3_finalize(stmt_user);
		}
        
	}
	return self;
}

- (BOOL)updateUserDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_USER];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;

    UserData* record = [[UserData alloc] init];
    record = [GlobalData sharedGlobalData].g_userData;
    strQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%d', '%@', '%@')",
                TABLE_USER,
                record.userId,
                record.deviceId,
                record.userName,
                record.email,
                record.password,
                record.verificationCode,
                record.photoUrl,
                record.signup,
                record.score,
                record.socialRole,
                record.fbId];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

@end
