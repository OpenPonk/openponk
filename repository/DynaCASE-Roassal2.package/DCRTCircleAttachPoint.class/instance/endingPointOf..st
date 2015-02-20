public - hooks
endingPointOf: anEdge
	Transcript
		show: 'ENDING: ' , anEdge to position asString , ' -> ' , anEdge from position asString;
		cr.
	^ self attachPointFrom: anEdge to to: anEdge from