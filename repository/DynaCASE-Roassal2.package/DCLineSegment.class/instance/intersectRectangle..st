comparing
intersectRectangle: aRectangle
	"point of intersection with rectanhle or nil if it does not exists"

	| topLeft topRight bottomLeft bottomRight intersection |
	topLeft := aRectangle topLeft.
	topRight := aRectangle topRight.
	bottomLeft := aRectangle bottomLeft.
	bottomRight := aRectangle bottomRight.
	intersection := self intersectionFrom: topLeft to: topRight.
	intersection
		ifNil: [ 
			intersection := self intersectionFrom: bottomLeft to: bottomRight.
			intersection
				ifNil: [ 
					intersection := self intersectionFrom: topLeft to: bottomLeft.
					intersection
						ifNil: [ 
							intersection := self intersectionFrom: topRight to: bottomRight.
							intersection ifNil: [ ^ nil ] ] ] ].
	^ intersection