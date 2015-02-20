public - hooks
startingPointOf: anEdge
	Transcript
		show: 'STARTING: ' , anEdge from position asString , ' -> ' , anEdge to position asString;
		cr.
	^ self attachPointFrom: anEdge from to: anEdge to