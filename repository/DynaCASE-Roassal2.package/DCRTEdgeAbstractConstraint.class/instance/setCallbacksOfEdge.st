private
setCallbacksOfEdge
	self removeCallbacksOfEdge.
	callbacks ifEmpty: [ callbacks := Bag with: TRTranslationCallback new with: TRExtentCallback new ].
	callbacks
		do: [ :each | 
			each block: [ self move ].
			edge from addCallback: each.
			edge to addCallback: each ]