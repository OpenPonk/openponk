add/remove
remove: aChildName
	| removed |
	removed := self generalizations select: [ :each | each child name = aChildName ].
	removed do: [ :each | generalizations remove: each ].
	
	^ removed
