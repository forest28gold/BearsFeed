//
//  Global.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#ifndef BEARSFEED_Global_h
#define BEARSFEED_Global_h

#define BACKEND_APP_ID                                              @"1AEBB---------------------------------AD6100"
#define BACKEND_SECRET_KEY                                          @"B9ACB---------------------------------F0A7400"
#define BACKEND_VERSION_NUM                                         @"v----"

#define TWITTER_CONSUMER_KEY                                        @"NWK---------------------JMp3SGIz"
#define TWITTER_CONSUMER_SECRET                                     @"GQl2U-----------------------------------jYgAqw9xvCjd"
#define TWITTER_ACCESS_TOKEN                                        @"8538---------------------------------------PQW7hkgGCC"
#define TWITTER_ACCESS_TOKEN_SECRET                                 @"iKvjsNC---------------------------7xNANyzPBv2GGI"

#define BEARSFEED_SHOPPING_LINK                                     @"https://www.berkshire-store.com/"
#define BEARSFEED_SNAPCHAT_LINK                                     @"https://www.snapchat.com/bearsfeed"
#define BEARSFEED_INSTAGRAM_LINK                                    @"https://www.instagram.com/bearsfeed"
#define BEARSFEED_FACEBOOK_LINK                                     @"https://www.facebook.com/bearsfeed"
#define BEARSFEED_WEBSITE_LINK                                      @"https://www.bearsfeed.com/"
#define BEARSFEED_TERMS_OF_USE_LINK                                 @"https://www.bearsfeed.com/termsofuse/"
#define BEARSFEED_PRIVACY_POLICY_LINK                               @"https://www.bearsfeed.com/privacypolicy/"
#define BEARSFEED_HELP_LINK                                         @"https://www.bearsfeed.com/help/"

#define BUTTON_RADIUS                                               8.0f
#define TABBAR_HEIGHT                                               50
#define LOAD_DATA_COUNT                                             15
#define RELOAD_TIME_INTERVAL                                        60

#define VIEW_MAIN                                                   @"BFMainViewController"

#define VIEW_SIGNUP_NAME                                            @"BFSignUpNameViewController"
#define VIEW_SIGNUP_EMAIL                                           @"BFSignUpEmailViewController"
#define VIEW_SIGNUP_PASSWORD                                        @"BFSignUpPasswordViewController"
#define VIEW_SIGNUP_BIO                                             @"BFSignUpBioViewController"
#define VIEW_SIGNUP_CONFIRM                                         @"BFSignUpConfirmViewController"
#define VIEW_LOGIN                                                  @"BFLoginViewController"
#define VIEW_FORGET_PASSWORD                                        @"BFForgetPasswordViewController"

#define VIEW_TAB                                                    @"BFTabBarViewController"
#define VIEW_TAB_BEARSFEED                                          @"BFTabBearsFeedViewController"
#define VIEW_TAB_PROFILE                                            @"BFTabProfileViewController"
#define VIEW_TAB_NOTIFICATION                                       @"BFTabNotificationViewController"
#define VIEW_TAB_EXPLORE                                            @"BFTabExploreViewController"

#define VIEW_NEWEST_POSTS                                           @"BFNewestPostsViewController"
#define VIEW_MOST_COMMENTED                                         @"BFMostCommentedViewController"
#define VIEW_MOST_VOTES                                             @"BFMostVotesViewController"
#define VIEW_TWITTER_HOME                                           @"BFTwitterHomeTimelineViewController"

#define VIEW_CHANGE_PROFILE                                         @"BFChangeProfileViewController"
#define VIEW_CHANGE_PASSWORD                                        @"BFChangePasswordViewController"

#define VIEW_CREATE_POST                                            @"BFCreatePostViewController"
#define VIEW_TWITTER_FEED                                           @"BFTwitterFeedViewController"
#define VIEW_TWITTER_USER                                           @"BFTwitterUserTimelineViewController"
#define VIEW_TWITTER_HOME                                           @"BFTwitterHomeTimelineViewController"

#define VIEW_PHOTO                                                  @"BFPhotoViewController"
#define VIEW_COMMENT                                                @"BFCommentViewController"
#define VIEW_SEARCH                                                 @"BFSearchViewController"
#define VIEW_USER_PROFILE                                           @"BFUserProfileViewController"
#define VIEW_POST_DETAILS                                           @"BFPostDetailsViewController"

#define VIEW_STANDING_LOADING                                       @"BFStandingLoadingViewController"
#define VIEW_LAST_BEAR_STANDING                                     @"BFLastBearStandingViewController"
#define VIEW_ELIMINATED_TARGET                                      @"BFEliminatedTargetViewController"
#define VIEW_ELIMINATE                                              @"BFEliminateViewController"
#define VIEW_BEAR_RESULT                                            @"BFBearResultViewController"
#define VIEW_BERKSHIRE_STORE                                        @"BFBerkShireStoreViewController"

#define SEGUE_SEARCH                                                @"segue_search"
#define SEGUE_NEW_POST                                              @"segue_new_post"
#define SEGUE_PHOTO                                                 @"segue_photo"
#define SEGUE_NEW_TWITTER                                           @"segue_new_twitter"
#define SEGUE_PHOTO_TWITTER                                         @"segue_photo_twitter"
#define SEGUE_LINK_TWITTER                                          @"segue_link_twitter"

#define UNWIND_LOGOUT                                               @"unwindLogOut"
#define UNWIND_VERIFY                                               @"unwindVerify"
#define UNWIND_NEW_POST                                             @"unwindNewPost"
#define UNWIND_BEAR_STANDING                                        @"unwindBearStanding"
#define UNWIND_TWITTER_POST                                         @"unwindTwitterPost"
#define UNWIND_TWITTER_EDIT                                         @"unwindTwitterEdit"

#define USER_SIGNUP                                                 @"signup"
#define USER_LOGOUT                                                 @"logout"
#define USER_VERIFY                                                 @"verify"
#define USER_DISABLE                                                @"disable"

#define SELECT_NEWEST                                               @"select_newest"
#define SELECT_MOST_COMMENTED                                       @"select_most_commented"
#define SELECT_MOST_VOTES                                           @"select_most_votes"
#define SELECT_TWITTER_FEED                                         @"select_twitter_feed"

#define USER_NORMAL                                                 @"normalUser"
#define USER_FACEBOOK                                               @"facebookUser"

#define POST_TYPE_PHOTO                                             @"photo"
#define POST_TYPE_TEXT                                              @"text"

#define NOTI_POST                                                   @"broadcast_post"
#define NOTI_COMMENT                                                @"comment"
#define NOTI_UPVOTE                                                 @"upvote"
#define NOTI_DOWNVOTE                                               @"downvote"
#define NOTI_COMMENT_UPVOTE                                         @"upvote_comment"
#define NOTI_COMMENT_DOWNVOTE                                       @"downvote_comment"
#define NOTI_REPORT                                                 @"report"
#define NOTI_ELIMINATE                                              @"eliminate"

#define ALERT_POST                                                  @"posted a news!"
#define ALERT_COMMENT                                               @"Commented on your post!"
#define ALERT_UPVOTE                                                @"Upvoted your post!"
#define ALERT_DOWNVOTE                                              @"Downvoted your post!"
#define ALERT_COMMENT_UPVOTE                                        @"Upvoted your comment!"
#define ALERT_COMMENT_DOWNVOTE                                      @"Downvoted your comment!"
#define ALERT_REPORT                                                @"Reported your post!"
#define ALERT_ELIMINATED                                            @"You are eliminated!"

#define LIKE_TYPE                                                   @"like"
#define DISLIKE_TYPE                                                @"dislike"

#define MESSAGING_CHANNEL                                           @"default"

#define BEAR_SCORE                                                  10

#define PUSH_BADGE                                                  @"1"
#define PUSH_SOUND                                                  @"chime"
#define PUSH_TITLE                                                  @"BearsFeed"

#define SUPPORT_EMAIL                                               @"berkshire.bearsfeed@gmail.com"
#define BEARSFEED_EMAIL                                             @"@berkshireschool.org"

#define BEARS_LAST                                                  @"BearsLast"
#define BEARS_ELIMINATED                                            @"BearsEliminated"
#define BEARS_END                                                   @"BearsEnd"

#define RESULT_LAST_BEAR_STANDING                                   @"Congratulations, you are the Last Bear Standing!"
#define RESULT_ELIMINATED                                           @"Sorry, you have been eliminated!"
#define RESULT_END                                                  @"Last Bear Standing"

#define TITLE_HELP                                                  @"HELP"
#define TITLE_TERMS_OF_USE                                          @"TERMS OF USE"
#define TITLE_PRIVACY_POLICY                                        @"PRIVACY POLICY"
#define TITLE_BERKSHIRE_STORE                                       @"BERKSHIRE SCHOOL STORE"

// show SVProgressHUD

#define SVPROGRESSHUD_SHOW                                          [SVProgressHUD showWithStatus:@"please wait..." maskType:SVProgressHUDMaskTypeClear]
#define SVPROGRESSHUD_DISMISS                                       [SVProgressHUD dismiss]
#define SVPROGRESSHUD_SUCCESS(status)                               [SVProgressHUD showSuccessWithStatus:status]
#define SVPROGRESSHUD_ERROR(status)                                 [SVProgressHUD showErrorWithStatus:status]
#define SVPROGRESSHUD_NETWORK_ERROR                                 [SVProgressHUD showErrorWithStatus:NETWORK_ERR_MESSAGE]

// Reset Password Email format

#define mail_reset_your_password                                    @"Reset your password"
#define mail_reset_password_body1                                   @"<body class='full-padding' style='margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #f5f7fa;'> <div class='wrapper' style='background-color: #f5f7fa;'> <table style='border-collapse: collapse;table-layout: fixed;color: #b9b9b9;font-family: &quot;Open Sans&quot;,sans-serif;' align='center'> <tbody><tr> <td class='preheader__snippet' style='padding: 10px 0 5px 0;vertical-align: top;width: 280px;'> </td> <td class='preheader__webversion' style='text-align: right;padding: 10px 0 5px 0;vertical-align: top;width: 280px;'> </td> </tr> </tbody></table> <table class='layout layout--no-gutter' style='border-collapse: collapse;table-layout: fixed;Margin-left: auto;Margin-right: auto;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #2ecc71;' align='center'> <tbody><tr> <td class='column' style='padding: 0;text-align: left;vertical-align: top;color: #60666d;font-size: 14px;line-height: 21px;font-family: &quot;Open Sans&quot;,sans-serif;width: 600px;'> <div style='Margin-left: 20px;Margin-right: 20px;Margin-top: 24px;Margin-bottom: 24px;'> <h1 class='size-30' style='Margin-top: 0;Margin-bottom: 0;font-style: normal;font-weight: normal;color: #44a8c7;font-size: 30px;line-height: 38px;font-family: sans-serif;text-align: center;'><span class='font-sans-serif'><strong><span style='color:#fcfcfc'>BearsFeed</span></strong></span></h1> </div> </td> </tr> </tbody></table> <table class='layout layout--no-gutter' style='border-collapse: collapse;table-layout: fixed;Margin-left: auto;Margin-right: auto;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #ffffff;' align='center'> <tbody><tr> <td class='column' style='padding: 0;text-align: left;vertical-align: top;color: #60666d;font-size: 14px;line-height: 21px;font-family: &quot;Open Sans&quot;,sans-serif;width: 600px;'> <div style='Margin-left: 20px;Margin-right: 20px;Margin-top: 24px;Margin-bottom: 24px;'> <h2 class='size-18' style='Margin-top: 0;Margin-bottom: 0;font-style: normal;font-weight: normal;color: #03b04c;font-size: 18px;line-height: 26px;font-family: sans-serif;text-align: center;'><span class='font-sans-serif'><strong> Reset your password </strong></span></h2><p class='size-13' style='Margin-top: 16px;Margin-bottom: 0;font-size: 13px;line-height: 21px;text-align: left;'>Hello</p><p class='size-13' style='Margin-top: 20px;Margin-bottom: 0;font-size: 13px;line-height: 21px;text-align: left;'>Looks like you've forgotten your password. That's okay, we've got you covered!</p><p class='size-13' style='Margin-top: 20px;Margin-bottom: 0;font-size: 13px;line-height: 21px;text-align: left;'>Please find your login and new password below.<br> <br> <strong>Login : "
#define mail_reset_password_body2                                   @"<br>Password : "
#define mail_reset_password_body3                                   @"</strong><br> <br>Once logged in, you may change your password from within the the app.<br> <br>If you did not request this password reset, someone may be attempting to access your account without your permission.<br> <br>Have a lovely day.<br> <br>Best regards<br>The BearsFeed Team</p> </div> </td> </tr> </tbody></table> <table class='footer' style='border-collapse: collapse;table-layout: fixed;Margin-right: auto;Margin-left: auto;border-spacing: 0;width: 560px;' align='center'> <tbody><tr> <td style='padding: 0 0 40px 0;'> <table class='footer__right' style='border-collapse: collapse;table-layout: auto;border-spacing: 0;' align='right'> <tbody><tr> <td class='footer__inner' style='padding: 0;'> </td> </tr> </tbody></table> <table class='footer__left' style='border-collapse: collapse;table-layout: fixed;border-spacing: 0;color: #b9b9b9;font-family: &quot;Open Sans&quot;,sans-serif;width: 380px;'> <tbody><tr> <td class='footer__inner' style='padding: 0;font-size: 12px;line-height: 19px;'> <div> </div> <div class='footer__permission' style='Margin-top: 18px;'> </div> </td> </tr> </tbody></table> </td> </tr> </tbody></table> </div> <img style='visibility: hidden !important; display: block !important; height:1px !important; width:1px !important; border: 0 !important; margin: 0 !important; padding: 0 !important' src='https://appscreationtechltd.createsend1.com/t/i-o-hjuikrk-l/o.gif' width='1' height='1' border='0' alt=''> <script type='text/javascript' src='https://js.createsend1.com/js/jquery-1.7.2.min.js?h=C99A46590401'></script><script type='text/javascript'>$(function(){$('area,a').attr('target', '_blank');});</script> </body>"

// Verification Email format

#define mail_verification_email                                     @"Please verify your email address"
#define mail_verification_email_body1                               @"<body class='full-padding' style='margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #f5f7fa;'> <div class='wrapper' style='background-color: #f5f7fa;'> <table style='border-collapse: collapse;table-layout: fixed;color: #b9b9b9;font-family: &quot;Open Sans&quot;,sans-serif;' align='center'> <tbody><tr> <td class='preheader__snippet' style='padding: 10px 0 5px 0;vertical-align: top;width: 280px;'> </td> <td class='preheader__webversion' style='text-align: right;padding: 10px 0 5px 0;vertical-align: top;width: 280px;'> </td> </tr> </tbody></table> <table class='layout layout--no-gutter' style='border-collapse: collapse;table-layout: fixed;Margin-left: auto;Margin-right: auto;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #2ecc71;' align='center'> <tbody><tr> <td class='column' style='padding: 0;text-align: left;vertical-align: top;color: #60666d;font-size: 14px;line-height: 21px;font-family: &quot;Open Sans&quot;,sans-serif;width: 600px;'> <div style='Margin-left: 20px;Margin-right: 20px;Margin-top: 24px;Margin-bottom: 24px;'> <h1 class='size-30' style='Margin-top: 0;Margin-bottom: 0;font-style: normal;font-weight: normal;color: #44a8c7;font-size: 30px;line-height: 38px;font-family: sans-serif;text-align: center;'><span class='font-sans-serif'><strong><span style='color:#fcfcfc'>BearsFeed</span></strong></span></h1> </div> </td> </tr> </tbody></table> <table class='layout layout--no-gutter' style='border-collapse: collapse;table-layout: fixed;Margin-left: auto;Margin-right: auto;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #ffffff;' align='center'> <tbody><tr> <td class='column' style='padding: 0;text-align: left;vertical-align: top;color: #60666d;font-size: 14px;line-height: 21px;font-family: &quot;Open Sans&quot;,sans-serif;width: 600px;'> <div style='Margin-left: 20px;Margin-right: 20px;Margin-top: 24px;Margin-bottom: 24px;'> <h2 class='size-18' style='Margin-top: 0;Margin-bottom: 0;font-style: normal;font-weight: normal;color: #03b04c;font-size: 18px;line-height: 26px;font-family: sans-serif;text-align: center;'><span class='font-sans-serif'><strong> Please verify your email address </strong></span></h2><p class='size-13' style='Margin-top: 16px;Margin-bottom: 0;font-size: 13px;line-height: 21px;text-align: left;'>Hello</p><p class='size-13' style='Margin-top: 20px;Margin-bottom: 0;font-size: 13px;line-height: 21px;text-align: left;'>Thank you for registering and creating an account with the BearsFeed application.</p><p class='size-13' style='Margin-top: 20px;Margin-bottom: 0;font-size: 13px;line-height: 21px;text-align: left;'>Before you begin working with the application, please confirm your email address by following the link below:<br> <br> <strong>Verification Code : "
#define mail_verification_email_body2                                @"</strong><br> <br>We are excited about you joining our community and would love to help any way we can.<br> <br>Have a lovely day.<br> <br>Best regards<br>The BearsFeed Team</p> </div> </td> </tr> </tbody></table> <table class='footer' style='border-collapse: collapse;table-layout: fixed;Margin-right: auto;Margin-left: auto;border-spacing: 0;width: 560px;' align='center'> <tbody><tr> <td style='padding: 0 0 40px 0;'> <table class='footer__right' style='border-collapse: collapse;table-layout: auto;border-spacing: 0;' align='right'> <tbody><tr> <td class='footer__inner' style='padding: 0;'> </td> </tr> </tbody></table> <table class='footer__left' style='border-collapse: collapse;table-layout: fixed;border-spacing: 0;color: #b9b9b9;font-family: &quot;Open Sans&quot;,sans-serif;width: 380px;'> <tbody><tr> <td class='footer__inner' style='padding: 0;font-size: 12px;line-height: 19px;'> <div> </div> <div class='footer__permission' style='Margin-top: 18px;'> </div> </td> </tr> </tbody></table> </td> </tr> </tbody></table> </div> <img style='visibility: hidden !important; display: block !important; height:1px !important; width:1px !important; border: 0 !important; margin: 0 !important; padding: 0 !important' src='https://appscreationtechltd.createsend1.com/t/i-o-hjuikrk-l/o.gif' width='1' height='1' border='0' alt=''> <script type='text/javascript' src='https://js.createsend1.com/js/jquery-1.7.2.min.js?h=C99A46590401'></script><script type='text/javascript'>$(function(){$('area,a').attr('target', '_blank');});</script> </body>"

// Backend api Key

#define BACKEND_URL_AVATAR                                          @"imgAvatar"
#define BACKEND_URL_POST                                            @"imgPost"

#define KEY_OBJECT_ID                                               @"objectId"
#define KEY_DEVICE_ID                                               @"deviceId"
#define KEY_NAME                                                    @"name"
#define KEY_EMAIL                                                   @"email"
#define KEY_PASSWORD                                                @"password"
#define KEY_BIO                                                     @"bio"
#define KEY_PHOTO_URL                                               @"photoUrl"
#define KEY_SOCIAL                                                  @"socialRole"
#define KEY_FB_ID                                                   @"fbId"
#define KEY_SCORE                                                   @"score"
#define KEY_VERIFY                                                  @"verify"

#define KEY_COMMENT_COUNT                                           @"commentCount"
#define KEY_VOTE_COUNT                                              @"likeCount"

#define KEY_USER_ID                                                 @"userId"
#define KEY_TYPE                                                    @"type"
#define KEY_CONTENT                                                 @"content"
#define KEY_POST_ID                                                 @"postID"
#define KEY_LIKE_TYPE                                               @"likeType"
#define KEY_COMMENT_TYPE                                            @"commentType"


#endif
