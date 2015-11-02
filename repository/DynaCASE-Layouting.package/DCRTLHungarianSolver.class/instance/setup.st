private
setup
	size := matrix numberOfRows.
	marks := Matrix rows: size columns: size element: self empty.
	self resetCovers