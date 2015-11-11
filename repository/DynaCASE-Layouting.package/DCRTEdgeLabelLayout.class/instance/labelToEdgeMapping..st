accessing
labelToEdgeMapping: aDictionary
	labelToEdgeMapping := aDictionary.
	self edgeForLabelStrategy: [ :label :me | labelToEdgeMapping at: label ].
	self
		labelForEdgeStrategy:
			[ :edge :me | 
			((labelToEdgeMapping associations select: [ :pair | pair value = edge ]) collect: #key)
				detect: [ :lbl | unassignedLabels includes: lbl ] ]