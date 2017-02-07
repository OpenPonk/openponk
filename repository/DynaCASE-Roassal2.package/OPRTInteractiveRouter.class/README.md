I provide (user-)interactive router for DCRTConnection.

After clicking on the edge draggable handle points will be added.

!! Example
[[[
edge := DCRTStyledConnection new
	edgeFrom: a to: b.
edge @ DCRTInteractiveRouter.
]]]