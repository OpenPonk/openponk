private
removeCallbacksOfEdge
	callbacks
		do: [ :each | 
			edge from trachelShape removeCallback: each ifAbsent: [ self error ].
			edge to trachelShape removeCallback: each ifAbsent: [ self error ] ].
	callbacks := Bag new