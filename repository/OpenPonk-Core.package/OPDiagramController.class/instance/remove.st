actions
remove
	super remove.
	self controllers do: [ :each | each remove ]