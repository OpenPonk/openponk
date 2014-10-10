updating
update
	| y hTop hAttrs r lineShape |
	lineShape := RTLabel new height: 10.
	attributesGroup do: [ :each | each remove ].
	attributesGroup removeAll.
	methodsGroup do: [ :each | each remove ].
	methodsGroup removeAll.
	group removeAll.
	stereotype value = ''
		ifTrue: [ 
			group add: topGroup last.
			topGroup first view ifNotNil: [ topGroup first remove ] ]
		ifFalse: [ 
			topGroup first view ifNil: [ background view add: topGroup first ].
			group addAll: topGroup ].
	RTNest new
		layout: (RTVerticalLineLayout new gapSize: 0);
		centerOn: background elements: group.
	hTop := group height.
	attributesGroup addAll: (lineShape elementsOn: attributes value).
	group addAll: attributesGroup.
	background view addAll: attributesGroup.
	RTNest new
		layout: (RTVerticalLineLayout new gapSize: 0);
		centerOn: background elements: group.
	hAttrs := group height.
	methodsGroup addAll: (lineShape elementsOn: methods value).
	group addAll: methodsGroup.
	background view addAll: methodsGroup.
	RTNest new
		layout: (RTVerticalLineLayout new gapSize: 0);
		centerOn: background elements: group.
	topGroup do: [ :each | each translateTo: group center x @ each trachelShape center y ].
	r := group encompassingRectangle.
	y := r top + hTop.
	self updateSeparatorsWith: hTop with: hAttrs.
	background view signalUpdate