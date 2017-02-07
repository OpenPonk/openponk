initialization
initialize
	super initialize.
	callbacks := Bag new.
	subscription := AnnouncementSubscription new
		announcementClass: TRMouseDragEnd;
		yourself.
	offset := 0