as yet unclassified
openConfiguration
	<script>
	| ui options specLayout |
	ui := DynamicComposableModel new.
	ui title: 'Visualizer configuration'.
	options := #(#highlightLabels #edgeMarks #labelPositions #overlapGraph #clusterGraphs #completeClusters #matchingGraph).
	ui
		instantiateModels:
			(options
				flatCollect: [ :each | 
					{each.
					#CheckBoxModel} ]).
	ui
		instantiateModels: #(#positionLabels #LabelModel #index #RadioButtonModel #penalty #RadioButtonModel).
	ui widgets keys
		do:
			[ :each | 
			(ui perform: each) label: each.
			each = #positionLabels
				ifFalse:
					[ (ui perform: each)
						whenChangedDo: [ DCRTEdgeLabelLayoutVisualizer Configuration at: each put: (ui perform: each) state ] ] ].
	RadioButtonGroup new
		addRadioButton: ui index;
		addRadioButton: ui penalty;
		default:
			((DCRTEdgeLabelLayoutVisualizer Configuration at: #index)
				ifTrue: [ ui index ]
				ifFalse: [ ui penalty ]).
	DCRTEdgeLabelLayoutVisualizer Configuration
		keysAndValuesDo: [ :key :value | (ui perform: key) state: value ].
	specLayout := SpecColumnLayout new.
	ui widgets keys do: [ :each | specLayout add: each ].
	ui openWithSpecLayout: specLayout