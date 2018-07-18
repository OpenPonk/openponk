private
doubleClick
	| element |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	element := self selectedItem.
	self flag: 'no registration mechanism for double click available at the moment'.
	element class name = #NSPFlowElement
		ifTrue: [ element := element flowModel ].
	OPPluginRegistry default plugins
		detect: [ :each | each modelClass = element class ]
		ifFound: [ self openCommand: element ]
		ifNone: [  ]