registering
registerAdapters
	self registerAdapter: DCDefaultNavigatorAdapter new.
	DCNavigatorAdapter allSubclassesDo: [ :class | class registerAdapter: self ]