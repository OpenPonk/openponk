converting
updateFromInfo: anInfo
	self isOpen: anInfo isOpen.
	self isSelected: anInfo isSelected.
	self order: anInfo order