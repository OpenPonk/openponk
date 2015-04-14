setting
defaultCenteringBlock
	"sets centering to dynamic, using default centering block"

	self
		dynamicCenteringBlock: [ :srcs :tgts | 
			| sourcesAvg targetsAvg |
			targetsAvg := [ (tgts collect: [ :each | each position ]) average ].
			sourcesAvg := [ (srcs collect: [ :each | each position ]) average ].
			srcs
				ifEmpty: [ targetsAvg value ]
				ifNotEmpty: [ tgts ifEmpty: [ sourcesAvg value ] ifNotEmpty: [ (sourcesAvg value + targetsAvg value) * 0.5 ] ] ]