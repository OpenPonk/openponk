accessing - defaults
defaultDiagram
	| stateMachine region |
	stateMachine := DCSmStateMachine new.
	region := DCSmRegion new.
	stateMachine addRegion: region.
	^ region