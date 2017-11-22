//
//  DBHandler.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DB_NAME					@"danielnetworkbearsfeed.db"
#define documentPath			[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface DBHandler : NSObject {
@public
	sqlite3 *dbHandler;
}

@property(nonatomic, getter=getDbHandler) sqlite3 *dbHandler;

+ (id)connectDB;
- (void)disconnectDB;

@end
