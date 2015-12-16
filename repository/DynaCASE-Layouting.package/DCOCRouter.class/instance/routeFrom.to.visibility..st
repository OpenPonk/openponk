as yet unclassified
routeFrom: src to: dst visibility: aVisGraph
	| queue srcEntry next reached top closed |
	queue := Heap new.
	queue
		sortBlock: [ :a :b | (a priorityFrom: src to: dst) < (b priorityFrom: src to: dst) ].
	(srcEntry := DCOCQueueEntry new)
		node: src;
		direction: (Set with: src direction).
	queue add: srcEntry.
	reached := false.
	closed := Dictionary new.
	[ reached not & queue isNotEmpty ]
		whileTrue:
			[ top := queue first.
			"self logCr: top node model -> top direction -> (top priorityFrom: src to: dst)."
			queue removeFirst.
			closed at: (Array with: top node model with: top direction) put: true.
			top node = dst
				ifTrue: [ reached := true ]
				ifFalse:
					[ (aVisGraph neighborsOf: top node)
						do:
							[ :each | 
							(next := DCOCQueueEntry new)
								parent: top;
								node: each;
								direction: (each dirnsFrom: top node).
							closed
								at: (Array with: next node model with: next direction)
								ifAbsent: [ queue add: next ] ] ] ].
	^ top