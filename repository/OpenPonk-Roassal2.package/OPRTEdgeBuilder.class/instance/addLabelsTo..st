private
addLabelsTo: anEdge
	labels
		keysAndValuesDo: [ :name :label | 
			label model: anEdge.
			anEdge trachelShape
				addCallback:
					(TRRemoveCallback new
						block: [ :removedShape | 
							anEdge labels removeKey: name.
							label remove ]).
			anEdge labels at: name put: label.
			anEdge view add: label ]