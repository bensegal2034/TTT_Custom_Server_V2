const http         = require("http"),
      fs           = require("fs"),
      compressjs   = require("compressjs"),
      compressmaps = require("./compressmaps"),
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

    // we don"t respond to non-GET requests
    if (request.method !== "GET") {
        serverResponse(
            [404], 
            "404 Error: File not found",
            "Not serving a " + request.method + " request"
        )
        return
    }

    // remove /garrysmod/ from start of path if it exists - if not, error code 404
    if (request.url.split("/")[1] === "garrysmod") {
        var rawPath = request.url.slice(11)
        var path = ""
    } else {
        serverResponse(
            [404], 
            "404 Error: File not found",
            "Not serving a request without /garrysmod/ in the path"
        )
        return
    }
    
    // TODO: figure out how to compress maps and other large files
    if (rawPath.split(".").includes("bz2") && rawPath.split("/").includes("maps")) {
        serverResponse(
            [500], 
            "500 Error: Unable to serve request for compressed map",
            "Not serving a request for compressed map " + rawPath
        )
        return
    }

    // remove .bz2 if it exists from the filename & set up the flag for later compression
    if (rawPath.split(".").includes("bz2")) {
        const tempRawPath = rawPath.split(".")
        tempRawPath.pop()
        rawPath = tempRawPath.join(".")
        var shouldCompFile = true
    } else {
        var shouldCompFile = false
    }

    // check all our various places we might be able to find the file
    if (fs.existsSync("../garrysmod/" + rawPath)) {
        path = "../garrysmod/" + rawPath
    } else if (fs.existsSync("../garrysmod/gamemodes/terrortown/" + rawPath)) {
        path = "../garrysmod/gamemodes/terrortown/" + rawPath
    } else if (fs.existsSync("../garrysmod/gamemodes/terrortown/content/" + rawPath)) {
        path = "../garrysmod/gamemodes/terrortown/content/" + rawPath
    }

    // can"t find the file requested, respond with 404
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

    // if path contains a request for a compressed file, compress it & overwrite 
    // regardless of if it"s already compressed (prevents old data being sent to clients)
    if (shouldCompFile) {
        var pathContent = fs.readFileSync(path)
        var compFile = path + ".bz2"
        var algorithm = compressjs.Bzip2
        console.log("Compressing file at " + compFile)
        var bufferedData = new Buffer.alloc(Buffer.byteLength(pathContent), path)
        var compressedData = algorithm.compressFile(bufferedData)
        fs.writeFileSync(compFile, compressedData)
        path = compFile
    }
    
    // all checks passed, file can now be sent out
    fs.readFile(path, function(err, content) {
        serverResponse(
            [
                200, 
                {"Content-Length": Buffer.byteLength(content)}
            ],
            content,
            "Serving request for " + path
        )
    })
})

console.log("Starting FastDL server... \n")
server.listen(port)