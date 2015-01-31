as yet unclassified
openFromList
	| item |
	item := self recentProjectsList selectedItem.
	item ifNil: [ ^ self ].
	item value asFileReference exists
		ifFalse: [ 
			UITheme builder inform: 'Project "' , item key , '" no longer exists.'.
			self removeCommand: item.
			self updateRecentProjects.
			^ self ].
	self openFile: item value