updating
update
	| y hTop hAttrs r labelShape |
	labelShape := RTLabel new height: 10.
	self deepCleanGroup: attributesGroup.
	self deepCleanGroup: methodsGroup.
	group removeAll.

	stereotype value = ''
		ifTrue: [ 
			topGroup first view ifNotNil: [ topGroup first remove ].
			group add: topGroup last ]
		ifFalse: [ 
			topGroup first view ifNil: [ background view add: topGroup first ].
			group addAll: topGroup ].

	RTVerticalLineLayout new gapSize: 0; on: group.
	RTNest new centerOn: background elements: group.

	hTop := group height.
	attributesGroup addAll: (labelShape elementsOn: attributes value).
	group addAll: attributesGroup.
	background view addAll: attributesGroup.
	
	RTVerticalLineLayout new gapSize: 0; on: group.
	RTNest new centerOn: background elements: group.
	
	hAttrs := group height.
	methodsGroup addAll: (labelShape elementsOn: methods value).
	group addAll: methodsGroup.
	background view addAll: methodsGroup.
	
	RTVerticalLineLayout new gapSize: 0; on: group.
	RTNest new centerOn: background elements: group.
	
	topGroup do: [ :each | each translateTo: group center x @ each trachelShape center y ].
	r := group encompassingRectangle.
	y := r top + hTop.
	self updateSeparatorsWith: hTop with: hAttrs.
	
	background view signalUpdate.
	background updateConnectedEdges