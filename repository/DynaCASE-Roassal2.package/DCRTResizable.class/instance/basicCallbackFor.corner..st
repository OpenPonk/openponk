hooks
basicCallbackFor: aHandle corner: aCorner
	| newExtent oppositeCornerPosition distance oppositeCorner |
	"An absolute distance the handle has moved from it's assigned corner."
	distance := aHandle position
		- ((DCRTRectangle cornerDirectionFor: aCorner) abs * (element encompassingRectangle perform: aCorner)).
	"Resizing with RTElement>>extent: changes the element in all directions, so we have to move it back in the opposite direction of the movement. (So when resizing by topRight corner, then bottomLeft should be fixed in place."
	distance := self negate: distance forCorner: aCorner.
	newExtent := element extent + distance max: self minSize.
	oppositeCorner := DCRTRectangle oppositeCornerFor: aCorner.
	oppositeCornerPosition := element encompassingRectangle perform: oppositeCorner.
	element trachelShape
		doWithoutCallbacks: [ 
			element extent: newExtent.
			self translateCorner: oppositeCorner of: element to: oppositeCornerPosition ].
	"This is to trigger repositioning of subelements etc."
	element trachelShape triggerCallbacksForStep: 0