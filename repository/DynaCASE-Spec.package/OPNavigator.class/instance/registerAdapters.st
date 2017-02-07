registering
registerAdapters
	self registerAdapter: OPDefaultNavigatorAdapter new.
	OPNavigatorAdapter allSubclassesDo: [ :class | class registerAdapter: self ]