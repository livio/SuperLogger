
(function() {
	var socket;

	if ("WebSocket" in window) {
    	socket = new WebSocket("%%WEBSOCKET_URL%%")
    	socket.onOpen = function () {
    		console.log("Superlogger websocket opened")
    		
    	}
	} else {
		// This browser doesn't support websockets
	}
})();
