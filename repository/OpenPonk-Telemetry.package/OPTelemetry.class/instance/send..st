reporting
send: data
	[ | response |
	[ response := ZnEasy post: self url data: (self serializedData: data) ]
		on: NetworkError
		do: [ :error | response := error ].
	self class reports add: data -> response ] fork