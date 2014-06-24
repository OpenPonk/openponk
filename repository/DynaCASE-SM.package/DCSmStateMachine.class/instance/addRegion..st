adding
addRegion: aRegion
	region addIfNotPresent: aRegion ifPresentDo: [self announce: (DCObjectAdded object: aRegion container: self) ]