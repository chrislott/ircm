CC = arm-apple-darwin-cc
LD = $(CC)
LDFLAGS = -ObjC -framework CoreFoundation -framework Foundation \
          -framework WebCore -framework Message -framework Webkit -framework UIKit -framework LayerKit -framework Coregraphics
CFLAGS = -Wall

all:	iRCMobileApp

iRCMobileApp: main.o iRCMobileApp.o  IRCServer.o ServerPrefsView.o ServerPrefTable.o iRCMTextView.o iRCMKeyboard.o ServerManager.o Channel.o ServerView.o ChannelView.o iRCMUITable.o
	$(LD) $(LDFLAGS) -o $@ $^
	rm -fr iRCm.app
	mkdir iRCm.app
	cp Default.png ./iRCm.app/
	cp Background.png ./iRCm.app/
	cp icon.png ./iRCm.app/
	cp Info.plist ./iRCm.app/
	cp iRCMobileApp ./iRCm.app/

%.o:	%.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:	
	rm -fr *.o iRCMobileApp
