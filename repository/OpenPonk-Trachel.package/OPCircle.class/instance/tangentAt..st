accessing
tangentAt: aPoint
	^ aPoint + ((aPoint y - center y) @ (center x - aPoint x))