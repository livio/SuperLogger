
(function() {
	var socket;

	if ("WebSocket" in window) {
		console.log("Browser supports websockets")

    	socket = new WebSocket("%%WEBSOCKET_URL%%");
    	socket.onopen = function() {
    		console.log("Superlogger websocket opened");
    		socket.send("A quick test");
    	};

    	socket.onmessage = function(message) {
    		console.log("Superlogger message received");
    		console.log(message.data);
    	};

    	socket.onclose = function() {
    		console.log("Superlogger websocket closed");
    	};

    	socket.onerror = function(error) {
    		console.error("Superlogger websocket error");
    		console.error(error);
    	};
	} else {
		// This browser doesn't support websockets
		console.error("Browser does not support websockets")
	}
})();
