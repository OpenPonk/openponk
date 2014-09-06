as yet unclassified
initialize
	super initialize.
	viewBlock := [ 
	| builder composite |
	composite := DCDynamicCompositionBuilder new.
	builder := DCDynamicTextBuilder new.
	builder addLine: self model name.
	composite add: builder.
	builder := DCDynamicTextBuilder new.
	self model attributes do: [ :attr | builder addLine: attr ].
	composite add: builder.
	composite renderIn: self parent view.
	self model nameHolder whenChangedDo: [ :newValue | builder textHolders first value: newValue ].
	self model attributesHolder
		whenChangedDo: [ :newCollection | 
			| linesCount |
			linesCount := builder textHolders size - 1.
			(1 to: newCollection size)
				do: [ :i | 
					| val |
					val := newCollection at: i.
					i > linesCount
						ifTrue: [ builder addLine: val ]
						ifFalse: [ (builder textHolders at: i + 1) value: val ] ].
			(1 to: linesCount - newCollection size) do: [ :i | builder removeLastLine ] ].
	composite background ]