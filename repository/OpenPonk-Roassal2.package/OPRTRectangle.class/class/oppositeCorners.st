as yet unclassified
oppositeCorners
	^ oppositeCorners
		ifNil: [ 
			oppositeCorners := {#topRight -> #bottomLeft.
			#bottomLeft -> #topRight.
			#bottomRight -> #topLeft.
			#topLeft -> #bottomRight.
			#top -> #bottom.
			#bottom -> #top.
			#left -> #right.
			#right -> #left} asDictionary ]