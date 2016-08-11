as yet unclassified
setSelectedItem: anItem
	"Force the selection of the item anItem"

	| index realItem |
	index := self getList indexOf: anItem ifAbsent: [ ^ self addItem: anItem ].
	realItem := listHolder at: index.
	selectionHolder index value: index.
	selectionHolder selection value: realItem