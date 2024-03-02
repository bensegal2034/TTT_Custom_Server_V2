const http = require('http'),
      fs   = require('fs'),
      mime = require('mime'),
      dir  = '../'
      port = 3000

const server = http.createServer(function(request, response) {
    if (request.method !== 'GET') {
        console.log("Got a " + request.method + " request?")
        return
    }

    const filename = dir + request.url.slice(1) 

    const type = mime.getType(filename) 

    fs.readFile(filename, function(err, content) {
        // if the error = null, then we've loaded the file successfully
        if (err === null) {
            console.log("Serving request for " + filename)
            response.writeHeader(200, {'Content-Length': Buffer.byteLength(content)})
            response.end(content)

        } else {
            // file not found, error code 404
            console.log("Failed to serve request for " + filename)
            response.writeHeader(404)
            response.end('404 Error: File Not Found')

        }
    })
})

console.log("Starting server...")
server.listen(port)
