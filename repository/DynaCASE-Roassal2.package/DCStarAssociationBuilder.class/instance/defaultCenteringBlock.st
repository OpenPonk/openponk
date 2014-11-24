setting
defaultCenteringBlock
	centeringBlock := [ :srcs :tgts | 
	| sourcesAvg targetsAvg |
	sourcesAvg := (srcs collect: [ :each | each position ]) average.
	targetsAvg := (tgts collect: [ :each | each position ]) average.
	(sourcesAvg + targetsAvg) * 0.5 ]