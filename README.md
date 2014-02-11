Helsinki interactive travel map
============================================

Demo: http://users.tkk.fi/~ituomi/Raideliikennekartta/

This interactive map was the result of contemplation on Harry Beck's famous London Underground map and similar new mapping conventions which could emerge in society.
The tram and metro lines of Helsinki are displayed.
Distance from the center of map is determined by travel time instead of geographical coordinates.
Temporal information can be exchanged for geographical and viewing the tracks can be turned off.

**Tools used:**

* Travel times and locations mined and normalized from Reittiopas API with custom Python script (over 100k values fetched)
* App coded in Java using Processing.org
* Converted to Javascript on the fly with processing.js
