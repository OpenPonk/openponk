private
joinProps: aCollection
	^ (aCollection collect: #asString) joinUsing: String cr