updating
update
	"moves center if centeric is dynamic"

	dynamicCentering & (sources size + targets size > 0)
		ifTrue: [ centerDragBox translateTo: (centeringBlock value: sources value: targets) ]