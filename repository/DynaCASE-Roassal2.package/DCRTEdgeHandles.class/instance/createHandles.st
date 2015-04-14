handles
createHandles
	bendPoints value
		overlappingPairsDo: [ :from :to | handles add: (DCRTMidpointHandle new on: self between: from and: to) ]
	"	bendPoints value do: [ :point | self addHandleFor: point ]"