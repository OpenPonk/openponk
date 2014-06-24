removing
removeRegion: aRegion
	(region includes: aRegion)
		ifTrue: [ 
			region remove: aRegion.
			self announce: (DCObjectRemoved object: aRegion container: self) ]