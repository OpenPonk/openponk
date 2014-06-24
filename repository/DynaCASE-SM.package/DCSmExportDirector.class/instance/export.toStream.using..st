as yet unclassified
export: aStateMachine toStream: aStream using: aBuilder
	| states regions transitions |
	aBuilder reset.
	aBuilder buildHeader.
	regions := aStateMachine region.
	regions
		do: [ :region | 
			states := region subvertex.
			transitions := region transition.
			states do: [ :state | aBuilder buildVertex: state ].
			transitions
				do: [ :transition | aBuilder buildEdgeFrom: transition source to: transition target withLabel: transition name ] ].
	aBuilder buildFooter.
	aStream nextPutAll: aBuilder contents