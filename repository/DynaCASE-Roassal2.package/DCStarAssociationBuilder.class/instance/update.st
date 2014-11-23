as yet unclassified
update
	selfCentering & (sources size > 0) & (targets size > 0)
		ifTrue: [ centerDragBox translateTo: (centeringBlock value: sources value: targets) ]