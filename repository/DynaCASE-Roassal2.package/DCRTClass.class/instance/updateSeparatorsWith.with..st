updating
updateSeparatorsWith: nameBottom with: attributesBottom
	| r |
	r := group encompassingRectangle.
	Transcript show: attributes value; cr.
	attributes value size > 0
		ifTrue: [ 
			separatorGroup first renderIn: background view.
			separatorGroup first update: r offset: nameBottom.
			group addAll: separatorGroup first ]
		ifFalse: [ separatorGroup first hide ].
	methods value size > 0
		ifTrue: [ 
			separatorGroup second renderIn: background view.
			separatorGroup second update: r offset: attributesBottom.
			group addAll: separatorGroup second ]
		ifFalse: [ separatorGroup second hide ]