#import "MessageTextView.h"

#import "iRCMobileApp.h"

@implementation MessageTextView

- (void)mouseUp:(struct __GSEvent *)fp8
{
	NSLog(@"inside  uitext view mouseUp");
	//[[[iRCMobileApp sharedInstance] keyboard] showKeyboardForView:[[iRCMobileApp sharedInstance] channelView]];
	
	[super mouseUp:fp8];
}


- (BOOL)webView:(id)fp8 shouldDeleteDOMRange:(id)fp12
{
  // This captures the delete button and sends it to the SubProcess.  It will
  // get reflected on the screen when the output is read back from the
  // SubProcess.
  //const char delete_cstr = 0x08;
  //if (write(_fd, &delete_cstr, 1) == -1) {
  // perror("write");
  // exit(1);
  //}
  
  /*
  
  NSLog(@"inside shouldDeleteDOMRange");
  
  int newIndex = [[self text] length];
  newIndex = newIndex - 1;
  
  if(newIndex >= 0)
  {
	NSString *newText = [[self text] substringToIndex:newIndex];
	[self setText: newText];
  } else
  {
	NSLog(@"error backspacing.. nowhere to backspace");
  } */
  
  
  // See if the shell echo'd back what we just wrote
  return YES;
}



- (BOOL)webView:(id)fp8 shouldInsertText:(id)character replacingDOMRange:(id)fp16 givenAction:(int)fp20
{
  NSLog(@"inserting.. %#x", [character characterAtIndex:0]);
  if([character length] != 1) {
    NSLog(@"Unhandled multiple character insert!");
    return YES;  //or just loop through
  }

  char cmd_char = [character characterAtIndex:0];

  if(cmd_char == 0xA)
  {
	//they pressed return! zomg!
	NSLog(@"WE DETECTED U PRESSED RETURN!!!");
	//do some simple parsing for /join or /part and stuff
	
	NSArray *spacedItems = [ [[self text] copy] componentsSeparatedByString:@" "];
	int spacedItemCount = [spacedItems count];
	//NSLog(@"item count: %d", spacedItemCount);
	if(spacedItemCount > 0)
	{
		if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/join"] == 0)
		{
			[[ServerManager sharedServerManager] tryToJoin: [spacedItems objectAtIndex:1] forServer: [[ServerManager sharedServerManager] currentServer]];
		} 
		else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/nick"] == 0)
		{
			[[ServerManager sharedServerManager] setNickname: [spacedItems objectAtIndex:1] forServer: [[ServerManager sharedServerManager] currentServer]];
		}
		else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/raw"] == 0)
		{
			[[ServerManager sharedServerManager] sendRawMessage:[[self text] substringFromIndex:4] forServer: [[ServerManager sharedServerManager] currentServer]];
		}
		else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/msg"] == 0)
		{
			
			//[[ServerManager sharedServerManager] sendPM:[[self text] substringFromIndex:4] forServer: [[ServerManager sharedServerManager] currentServer]];
		}
		else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/topic"] == 0)
		{
			NSMutableString *topic = [[NSMutableString alloc] initWithString:@""];
			int i;
			
			for (i=1; i< [spacedItems count]; i++) {
				topic = [topic stringByAppendingString:[spacedItems objectAtIndex:i]];
				topic = [topic stringByAppendingString:@" "];
			}
            
			[[ServerManager sharedServerManager] setCurrentChannelTopic:topic forServer: [[ServerManager sharedServerManager] currentServer]];
			[topic autorelease];
		}
        else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/mode"] == 0)
		{
            NSMutableString *modestr = [[NSMutableString alloc] initWithString:@""];
			int i;
			
			for (i=1; i< [spacedItems count]; i++) {
				modestr = [modestr stringByAppendingString:[spacedItems objectAtIndex:i]];
				modestr = [modestr stringByAppendingString:@" "];
			}
			
			[[ServerManager sharedServerManager] setCurrentChannelModeString:modestr forServer: [[ServerManager sharedServerManager] currentServer]];
			[modestr autorelease];
        }
        else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/op"] == 0)
		{
            NSMutableString *modestr = [[NSMutableString alloc] initWithString:@""];
			int i;
			
			if ( [spacedItems count] > 1 ) {
                modestr = [modestr stringByAppendingString:@"+o "];
                modestr = [modestr stringByAppendingString:[spacedItems objectAtIndex:1]];
        
                [[ServerManager sharedServerManager] setCurrentChannelModeString:modestr forServer: [[ServerManager sharedServerManager] currentServer]];
                [modestr autorelease];
            }
        }
        else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/deop"] == 0)
		{
            NSMutableString *modestr = [[NSMutableString alloc] initWithString:@""];
			int i;
			
			if ( [spacedItems count] > 1 ) {
                modestr = [modestr stringByAppendingString:@"-o "];
                modestr = [modestr stringByAppendingString:[spacedItems objectAtIndex:1]];
        
                [[ServerManager sharedServerManager] setCurrentChannelModeString:modestr forServer: [[ServerManager sharedServerManager] currentServer]];
                [modestr autorelease];
            }
        }
        else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/voice"] == 0)
		{
            NSMutableString *modestr = [[NSMutableString alloc] initWithString:@""];
			int i;
			
			if ( [spacedItems count] > 1 ) {
                modestr = [modestr stringByAppendingString:@"+v "];
                modestr = [modestr stringByAppendingString:[spacedItems objectAtIndex:1]];
        
                [[ServerManager sharedServerManager] setCurrentChannelModeString:modestr forServer: [[ServerManager sharedServerManager] currentServer]];
                [modestr autorelease];
            }
        }
        else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/devoice"] == 0)
		{
            NSMutableString *modestr = [[NSMutableString alloc] initWithString:@""];
			int i;
			
			if ( [spacedItems count] > 1 ) {
                modestr = [modestr stringByAppendingString:@"-v "];
                modestr = [modestr stringByAppendingString:[spacedItems objectAtIndex:1]];
        
                [[ServerManager sharedServerManager] setCurrentChannelModeString:modestr forServer: [[ServerManager sharedServerManager] currentServer]];
                [modestr autorelease];
            }
        }
        else if([[spacedItems objectAtIndex:0] caseInsensitiveCompare: @"/kick" == 0)
		{
            NSMutableString *reason = [[NSMutableString alloc] initWithString:@""];
			int i;
			
            if ( [spacedItems count] > 3 ) {
                for (i=2; i< [spacedItems count]; i++) {
                    reason = [reason stringByAppendingString:[spacedItems objectAtIndex:i]];
                    reason = [reason stringByAppendingString:@" "];
                }
            
                [[ServerManager sharedServerManager] kickUserFromCurrentChannel:[spacedItems objectAtIndex:1] withReason:reason forServer: [[ServerManager sharedServerManager] currentServer]];
                [reason autorelease];
            }
        }
		else
		{
			[[[iRCMobileApp sharedInstance] channelView] sendMessage: [[self text] copy] ];
		}
	}
	
	[self setText: @""];
	return NO;
  }	

/*
  if (!_controlKeyMode) {
    if ([character characterAtIndex:0] == 0x2022) {
      //debug(@"ctrl key mode");
      _controlKeyMode = YES;
      return NO;
    }
  } else {
    // was in ctrl key mode, got another key
    //debug(@"sending ctrl key");
    if (cmd_char < 0x60 && cmd_char > 0x40) {
      // Uppercase
      cmd_char -= 0x40;      
    } else if (cmd_char < 0x7B && cmd_char > 0x61) {
      // Lowercase
      cmd_char -= 0x60;
    }
    _controlKeyMode = NO;
  }*/
 
 /*
  NSLog(@"got string from char: %c", cmd_char);
  NSString *newString = [[self text] stringByAppendingString:[NSString stringWithFormat:@"%c", cmd_char] ];
  NSLog(@"appended string to old string, here's the new one: %@", newString);
  [self setText:[newString copy]];
  NSLog(@"now we're done adding it to the text field");
  */
  //if (write(_fd, &cmd_char, 1) == -1) {
  //  perror("write");
  //  exit(1);
  //}
  
  
  // See if the shell echo'd back what we just wrote
  return YES;
}

- (int)writeData:(const char*)data length:(unsigned int)length
{
	NSLog(@"writeData was called....???");
	return 0;
}




@end