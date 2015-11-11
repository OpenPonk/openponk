initialize-release
initialize
	super initialize.
	labels := nil.
	visualizer := DCRTEdgeLabelLayoutVisualizer new layouter: self.
	spacing := self defaultSpacing.
	edgeForLabel := [ :label :me | label model ].
	labelForEdge := [ :edge :me | unassignedLabels detect: [ :label | label model = edge ] ].
	withProgressBar := false.
	withVisualization := false.
	labelsStrategy := [ :edge |  ].
	preferences := Dictionary new