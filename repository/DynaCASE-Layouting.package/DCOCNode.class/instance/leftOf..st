as yet unclassified
leftOf: aDirection
	^ {(#top -> #left).
	(#left -> #bottom).
	(#bottom -> #right).
	(#right -> #top)} asDictionary at: aDirection