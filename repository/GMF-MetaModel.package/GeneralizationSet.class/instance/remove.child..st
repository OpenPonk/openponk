add/remove
remove: aParentName child: aChildName
	generalizations := self generalizations reject: [ :each | 
		each parent name = aParentName & each child name = aChildName ].
