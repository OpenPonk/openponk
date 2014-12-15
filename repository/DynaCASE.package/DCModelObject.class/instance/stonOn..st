*DynaCASE-Serialization
stonOn: stonWriter
	| instanceVariableNames |
	(instanceVariableNames := self class allInstVarNames) isEmpty
		ifTrue: [ stonWriter writeObject: self do: [ self encodeMap: #() ] ]
		ifFalse: [ 
			stonWriter
				writeObject: self
				streamMap: [ :dictionary | 
					instanceVariableNames
						do: [ :each | 
							each asSymbol = #announcer
								ifFalse: [ 
									(self instVarNamed: each)
										ifNotNil: [ :value | dictionary at: each asSymbol put: value ]
										ifNil: [ dictionary at: each asSymbol put: nil ] ] ] ] ]