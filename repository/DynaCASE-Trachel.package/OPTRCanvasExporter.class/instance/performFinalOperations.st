private
performFinalOperations
	"Last step before export.
Due to applying oversize and scaling to morph limits it is recommended to use only once for single instance right before exporting."

	canvas ifNil: [ self error: 'No canvas selected' ].
	fileName ifNil: [ self error: 'File name not set' ].
	self
		applyOversize;
		scaleToMorphLimits;
		applyMargin.
	finalized := true