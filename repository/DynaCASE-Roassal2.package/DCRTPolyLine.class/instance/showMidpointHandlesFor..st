public
showMidpointHandlesFor: anEdge
	midpointHandles := {(anEdge from)} , (handles collect: [ :each | each element ]) , {(anEdge to)}
		overlappingPairsCollect: [ :from :to | DCRTMidpointHandle new on: anEdge between: from and: to ].
	midpointHandles do: [ :each | each renderIn: anEdge view ]