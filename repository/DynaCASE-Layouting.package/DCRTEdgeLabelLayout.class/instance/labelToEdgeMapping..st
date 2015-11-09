accessing
labelToEdgeMapping: aDictionary
	labelToEdgeMapping := aDictionary.
	self edgeForLabelStrategy: [ :label :me | labelToEdgeMapping at: label ].
	self labelForEdgeStrategy: [ :edge :me | labelToEdgeMapping keyAtValue: edge ]