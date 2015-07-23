accessing
cornerDirections
	^ cornerDirections
		ifNil: [ 
			cornerDirections := {#top -> (0 @ 1).
			#bottom -> (0 @ -1).
			#left -> (1 @ 0).
			#right -> (-1 @ 0).
			#topRight -> (-1 @ 1).
			#bottomRight -> (-1 @ -1).
			#bottomLeft -> (1 @ -1).
			#topLeft -> (1 @ 1)} asDictionary ]