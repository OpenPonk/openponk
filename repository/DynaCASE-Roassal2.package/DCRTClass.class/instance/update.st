updating
update
	| hTop hAttrs |
	
	self
		deepCleanGroup: attributesGroup;
		deepCleanGroup: methodsGroup.
	group removeAll.
	
	stereotype value = ''
		ifTrue: [ 
			topGroup first view ifNotNil: [ topGroup first remove ].
			group add: topGroup last ]
		ifFalse: [ 
			topGroup first view ifNil: [ background view add: topGroup first ].
			group addAll: topGroup ].
		
	RTVerticalLineLayout new
		gapSize: 0;
		on: group.		
	RTNest new centerOn: background elements: group.
	
	hTop := self updateSubgroup: attributesGroup of: attributes.
	hAttrs := self updateSubgroup: methodsGroup of: methods.
	
	topGroup do: [ :each | each translateTo: group center x @ each trachelShape center y ].
	
	self updateSeparatorsWith: hTop with: hAttrs.
	
	background view signalUpdate.
	background updateConnectedEdges