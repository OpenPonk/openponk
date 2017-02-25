private
doubleClick
	| element |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	element := tree selectedItem content.
	OPPluginRegistry default plugins
		detect: [ :each | each modelClass = element class ]
		ifFound: [ self openCommand: element ]
		ifNone: [  ]