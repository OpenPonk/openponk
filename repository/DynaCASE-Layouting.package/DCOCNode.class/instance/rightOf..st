as yet unclassified
rightOf: aDirection
	^ {(#top -> #right).
	(#right -> #bottom).
	(#bottom -> #left).
	(#left -> #top)} asDictionary at: aDirection