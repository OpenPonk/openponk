as yet unclassified
initializeElement: element
	| visible |
	visible := false.
	element
		when: TRMouseLeftClick
		do: [ 
			visible
				ifTrue: [ element shape removeHandlesFor: element ]
				ifFalse: [ element shape showHandlesFor: element ].
			visible := visible not ]