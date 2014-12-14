as yet unclassified
openFile
	| item |
	item := self recentProjectsList selectedItem.
	item ifNil: [ ^ self ].
	self openFile: item value