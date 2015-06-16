initialization
initialize
	super initialize.
	announcer := Announcer new.
	accepts := nil.
	completed := nil.
	delay := 0.
	remainder := #()