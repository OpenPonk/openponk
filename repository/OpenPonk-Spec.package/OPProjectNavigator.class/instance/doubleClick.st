private
doubleClick
	| element |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	element := self selectedItem.
	OPPluginRegistry default plugins
		detect: [ :each | each modelClass = element class ]
		ifFound: [ self openCommand: element ]
		ifNone: [  ]