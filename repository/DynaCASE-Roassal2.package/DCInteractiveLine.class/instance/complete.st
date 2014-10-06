accessing
complete
	| result |
	running := false.
	result := onCompleteBlock value: source value: target.
	self cleanup.
	^ result