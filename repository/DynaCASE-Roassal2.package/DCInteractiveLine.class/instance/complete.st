accessing
complete
	| result |
	result := onCompleteBlock value: source value: target.
	self cleanup.
	^ result