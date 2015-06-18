add/remove
remove: aChildName
	| removed |
	removed := self generalizations detect: [ :each | each child name = aChildName ].
	
	generalizations remove: removed.
	
	^ removed
