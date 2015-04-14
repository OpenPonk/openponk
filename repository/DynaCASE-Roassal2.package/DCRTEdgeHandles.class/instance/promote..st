as yet unclassified
promote: aMidpointHandle
	| index handle |
	index := handles indexOf: aMidpointHandle.
	handle := DCRTHandle new on: self between: (handles at: index - 1) and: (handles at: index + 1).
	handle promoteElement: aMidpointHandle element.
	edge view add: handle element.
	aMidpointHandle remove