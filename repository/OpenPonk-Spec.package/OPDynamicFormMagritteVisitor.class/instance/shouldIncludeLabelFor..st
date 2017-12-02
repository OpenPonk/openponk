testing
shouldIncludeLabelFor: aContainer
	"container priority = 0 is the root container"

	^ aContainer priority > 0 & aContainer label isNotNil