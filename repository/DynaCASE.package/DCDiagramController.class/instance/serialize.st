as yet unclassified
serialize
	| diagram layout |
	diagram := self model.
	layout := Dictionary new.
	diagram elements
		do: [ :each | 
			| v |
			v := (self findControllerByModel: each) view.
			(v isKindOf: RTElement)
				ifTrue: [ layout at: each put: v position ] ].
	^ {(#diagram -> diagram).
	(#layout -> layout)} asDictionary