as yet unclassified
removeLine: index
	| el textHolder cb |
	el := elements removeAt: index.
	textHolder := textHolders removeAt: index.
	textHolder whenChangedDo: nil.
	cb := callbacks removeAt: index.
	background trachelShape removeCallback: cb ifAbsent: [  ].
	view removeElement: el.
	parent ifNil: [ self update ] ifNotNil: [ parent update ]