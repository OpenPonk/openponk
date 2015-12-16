as yet unclassified
reverseOf: aDirection
	^ {(#top -> #bottom).
	(#right -> #left).
	(#bottom -> #top).
	(#left -> #right)} asDictionary at: aDirection