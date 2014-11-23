setting
defaultCenteringBlock
	centeringBlock := [ :srcs :tgts | 
	| sourcesAvg targetsAvg |
	sourcesAvg := (srcs collect: [ :each | each position ]) average.
	targetsAvg := (tgts inject: 0 @ 0 into: [ :sum :each | each position + sum ]) / tgts size.
	(sourcesAvg + targetsAvg) * 0.5 ]