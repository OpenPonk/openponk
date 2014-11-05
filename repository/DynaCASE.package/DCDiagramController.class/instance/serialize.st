as yet unclassified
serialize
	| diagram layout |
	diagram := self model.
	layout := Dictionary new.
	diagram elements
		do: [ :each | 
			| f |
			f := (self controllerForModel: each) figure.
			(f isKindOf: RTElement)
				ifTrue: [ layout at: each put: f position ] ].
	^ {(#diagram -> diagram).
	(#layout -> layout)} asDictionary