updating
update
	selfCentering & (sources size + targets size > 0)
		ifTrue: [ centerDragBox translateTo: (centeringBlock value: sources value: targets) ]