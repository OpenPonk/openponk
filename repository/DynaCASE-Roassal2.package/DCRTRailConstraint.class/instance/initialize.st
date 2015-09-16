building
initialize
	(gripShape := RTBox new)
		size: 0;
		color: Color red.
	(gripLine := RTLine new)
		attachPoint: RTRectangleAttachPoint new;
		color: Color black