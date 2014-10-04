as yet unclassified
createView
	| nameBuilder attrsBuilder composite |
	composite := DCDynamicCompositionBuilder new.
	nameBuilder := DCDynamicTextBuilder new.
	nameBuilder addLine: self model name.
	composite add: nameBuilder.
	attrsBuilder := DCDynamicTextBuilder new.
	self model attributes do: [ :attr | attrsBuilder addLine: attr ].
	composite add: attrsBuilder.
	composite renderIn: self parent view.
	self model nameHolder whenChangedDo: [ :newValue | nameBuilder textHolders first value: newValue ].
	self model attributesHolder
		whenChangedDo: [ :newCollection | 
			| linesCount |
			linesCount := attrsBuilder textHolders size.
			(1 to: newCollection size)
				do: [ :i | 
					| val |
					val := newCollection at: i.
					i > linesCount
						ifTrue: [ attrsBuilder addLine: val ]
						ifFalse: [ (attrsBuilder textHolders at: i) value: val ] ].
			(1 to: linesCount - newCollection size) do: [ :i | attrsBuilder removeLastLine ] ].
	^ composite background