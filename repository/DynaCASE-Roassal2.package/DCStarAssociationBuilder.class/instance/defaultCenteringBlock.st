setting
defaultCenteringBlock
	"sets centering to dynamic, using default centering block"

	self
		dynamicCenteringBlock: [ :srcs :tgts | 
			| sourcesAvg targetsAvg |
			targetsAvg := [ (tgts collect: [ :each | each position ]) average ].
			sourcesAvg := [ (srcs collect: [ :each | each position ]) average ].
			srcs size = 0
				ifTrue: [ targetsAvg value ]
				ifFalse: [ 
					tgts size = 0
						ifTrue: [ sourcesAvg value ]
						ifFalse: [ (sourcesAvg value + targetsAvg value) * 0.5 ] ] ]