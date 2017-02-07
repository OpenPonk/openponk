accessing
layout
	^ (self controllers collect: [ :each | each model uuid -> each layout ]) asDictionary