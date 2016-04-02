instance creation
autosaveFileFor: aUUID
	self autosavePath ensureCreateDirectory.
	^ self autosavePath / aUUID asString , 'graphml'