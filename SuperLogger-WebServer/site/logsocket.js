
(function() {
	var socket;

	if ("WebSocket" in window) {
		console.log("Browser supports websockets")

    	socket = new WebSocket("%%WEBSOCKET_URL%%");
    	socket.onopen = function() {
    		console.log("Superlogger websocket opened");

            document.getElementById("connect-state").innerHTML = "Connected";

            // TODO: Doesn't work for some reason
    		socket.send("A quick test");
    	};

    	socket.onmessage = function(message) {
    		console.log("Superlogger message received");
    		console.log(message.data);

            var p = document.createElement("p");
            p.textContent = message.data;
            document.getElementById("log-strings").appendChild(p);

            // TODO: Doesn't work for some reason
            socket.send("message received");
    	};

    	socket.onclose = function() {
    		console.log("Superlogger websocket closed");

            document.getElementById("connect-state").innerHTML = "Not Connected";
    	};

    	socket.onerror = function(error) {
    		console.error("Superlogger websocket error");
    		console.error(error);
    	};
	} else {
		// This browser doesn't support websockets
		console.error("Browser does not support websockets");
        document.getElementById("connect-state").innerHTML = "Browser does not support websockets";
	}
})();
