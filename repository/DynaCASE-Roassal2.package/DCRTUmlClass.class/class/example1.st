as yet unclassified
example1
	| view element shape |
	view := RTView new.

	element := RTElement new.

	shape := DCRTUmlClass new.
	shape stereotype: '«kind»'.
	shape name: 'Train'.
	shape content: #(#('+first' '#second' '-third') #('+method()')).

	element + shape.
	element @ RTDraggable.

	view add: element.

	view open