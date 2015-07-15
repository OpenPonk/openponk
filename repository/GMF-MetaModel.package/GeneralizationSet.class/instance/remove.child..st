add/remove
remove: aParentName child: aChildName
	| removed |
	removed := self generalizations detect: [ :any | any parent name = aParentName and: [ any child name = aChildName ] ].
	generalizations remove: removed.
	^ removed