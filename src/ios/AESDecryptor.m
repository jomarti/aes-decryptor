#import "AESDecryptor.h"

@implementation AESDecryptor

/**
 *  encrypt
 *
 *  @param command An array of arguments passed from javascript
 */
- (void)encrypt:(CDVInvokedUrlCommand *)command {

  CDVPluginResult *pluginResult = nil;

  NSString *path = [self crypto:@"encrypt" command:command];

  if (path != nil) {
    pluginResult =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                          messageAsString:YES];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult
                              callbackId:command.callbackId];
}

/**
 *  decrypt
 *
 *  @param command An array of arguments passed from javascript
 */
- (void)decrypt:(CDVInvokedUrlCommand *)command {

  CDVPluginResult *pluginResult = nil;

  NSString *path = [self crypto:@"decrypt" command:command];

  if (path != nil) {
    pluginResult =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                          messageAsString:YES];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult
                              callbackId:command.callbackId];
}

/**
 *  Encrypts or decrypts file at given URI.
 *
 *
 *  @param action  Cryptographic operation
 *  @param command Cordova arguments
 *
 *  @return Boolean value representing success or failure
 */
- (NSString*)crypto:(NSString *)action command:(CDVInvokedUrlCommand *)command {

  NSData *data = nil;
  NSString *filePath = [command.arguments objectAtIndex:0];
  NSString *destFilePath = [command.arguments objectAtIndex:1];
  NSString *passPhase = [command.arguments objectAtIndex:2];
  NSString *iv = [command.arguments objectAtIndex:3];
  NSString *salt = [command.arguments objectAtIndex:4];
  NSString *fileName = [filePath lastPathComponent];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
  NSString *path = [documentsPath stringByAppendingPathComponent:fileName];

  BOOL fileExists = [fileManager fileExistsAtPath:path];

  // if path, destpath and passPhase args exist
  if (path != nil && [path length] > 0 && destFilePath != nil && [destFilePath length] > 0 && passPhase != nil && [passPhase length] > 0) {

    // if file exists
    if (fileExists) {

      // get file data
      NSData *fileData = [NSData dataWithContentsOfFile:path];

      NSError *error;
      if ([action isEqualToString:@"encrypt"]) {
        // encrypt data
        data = [RNEncryptor encryptData:fileData
                           withSettings:kRNCryptorAES256Settings
                               password:passPhase
                                  error:&error];

      } else if ([action isEqualToString:@"decrypt"]) {
        // decrypt data
        data = [RNDecryptor decryptData:fileData
                           withPassword:passPhase
                                  error:&error];
      }

      // write to generated path
      [data writeToFile:destFilePath atomically:YES];
    } else {
      destFilePath = nil;
    }
  }

  return destFilePath;
}

@end
