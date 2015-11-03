initialize-release
initialize
	super initialize.
	labels := #().
	visualizer := DCRTEdgeLabelLayoutVisualizer new layouter: self.
	spacing := self defaultSpacing.
	edgeForLabel := [ :label | label model ].
	labelForEdge := [ :edge | self labels detect: [ :label | label model = edge ] ].
	withProgressBar := false.
	withVisualization := false