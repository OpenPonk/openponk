I attach a RTElement to a RTEdge (works for both line and connection shapes). When the edge or it's extremities are moved, so is the anchor.

Furthermore I will try to move the Element in such a way that it doesn't overlap neither the edge, nor it's extremities, nor their other lines. I will not however prevent overlapping of another elements (e.g. another element or edge nearby).

!! API

==#balance: aNumber==
Specify where the anchor should be positioned. x \in [0, 1] for relative positions (so 0.5 will be exactly middle, 1 at the end, etc.).
x > 1 or x < 0 for absolute positioning. E.g.: 10 - position the anchor 10 pixels from the beginning; -20 - 20 pixels from the end

==#minDistance: aNumber==
A minimum distance (in pixels) that should be maintained between the edge and the element


