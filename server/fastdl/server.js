const http         = require("http"),
      fs           = require("fs"),
      qs           = require("querystring"),
      port         = 3000

const server = http.createServer(function(request, response) {
    // headers should be an array of all the headers we need to write
    // end is what to end the response with
    // consoleMsg is a string to write in the console if provided
    function serverResponse(headers, end, consoleMsg) {
        response.writeHeader(...headers)
        response.end(end)
        if (typeof consoleMsg !== undefined) {console.log(consoleMsg)}
    }

    if (request.method === "GET") {
        // we are dealing with a request for a file (most likely lmao)
        // remove /garrysmod/ from start of path if it exists - if not, error code 404
        if (decodeURIComponent(request.url).split("/")[1] === "garrysmod") {
            var rawPath = decodeURIComponent(request.url).slice(11)
            var path = ""
        } else {
            serverResponse(
                [404], 
                "404 Error: File not found",
                "Not serving a request without /garrysmod/ in the path"
            )
            return
        }

        // check all our various places we might be able to find the file
        if (fs.existsSync("../garrysmod/" + rawPath)) {
            path = "../garrysmod/" + rawPath
        } else if (fs.existsSync("../garrysmod/gamemodes/terrortown/" + rawPath)) {
            path = "../garrysmod/gamemodes/terrortown/" + rawPath
        } else if (fs.existsSync("../garrysmod/gamemodes/terrortown/content/" + rawPath)) {
            path = "../garrysmod/gamemodes/terrortown/content/" + rawPath
        }

        // iterate over addons
        addons = fs.readdirSync("../garrysmod/addons/", { withFileTypes: true });
        addons.forEach(file => {
            if (file.isDirectory()) { // sanity check to make sure we don't include weird shit if present
                if (fs.existsSync("../garrysmod/addons/" + file.name + "/" + rawPath)) {
                    path = "../garrysmod/addons/" + file.name + "/" + rawPath
                    return
                }
            }
        })

        // can't find the file requested, respond with 404
        if (path === "") {
            serverResponse(
                [500], 
                "500 Error: Unable to serve file",
                "Failed to find file at " + request.url
            )
            return
        }

        // are we about to try and serve a request for a directory? if so, 404
        if (fs.lstatSync(path).isDirectory()) {
            serverResponse(
                [500], 
                "500 Error: Unable to serve directories",
                "Not serving a request for a directory at " + request.url
            )
            return
        }

        // all checks passed, file can now be sent out
        const fileStream = fs.createReadStream(path)
        const stats = fs.statSync(path)

        response.writeHead(200, {
            "Content-Length": stats.size
        });
        fileStream.pipe(response)
        fileStream.on('error', (error) => {
            console.error('Error streaming file:', error);
            res.writeHead(404);
            res.end('File not found.');
        });
        console.log("Serving file " + path + "; Content-Length: " + stats.size)

    } else if (request.method === "POST") {
        console.log("Serving POST request")
        //this is a request to log an error
        var body = ""
        request.on("data", function(data) {
            body += data
        })
        request.on("end", function(data) {
            console.log("POST request parsed, body:")
            var bodyParsed = qs.parse(body)
            console.log(bodyParsed.error)
            console.log(bodyParsed.stack)
            console.log(bodyParsed.realm)
            console.log(bodyParsed.addon)
            console.log(bodyParsed.hash)
            console.log(bodyParsed.gamemode)
            console.log(bodyParsed.gmv)
            console.log(bodyParsed.os)
            console.log(bodyParsed.ds)
            console.log(bodyParsed.v)
            serverResponse(
                [200],
                "200 OK",
                "Responded OK to POST request, all data received"
            )
        })
    } else {
        serverResponse(
            [500],
            "500 Error: Unsupported request type",
            "Not serving a " + request.method + " request"
        )
        return
    }
})

console.log("Starting FastDL server... \n")
server.listen(port)