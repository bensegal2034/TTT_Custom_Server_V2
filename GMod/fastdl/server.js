const http = require('http'),
      fs   = require('fs'),
      mime = require('mime'),
      path = require('path'),
      compressjs = require('compressjs')
      dir  = '../'
      port = 3000

const server = http.createServer(function(request, response) {
    // we don't respond to non-GET requests
    if (request.method !== 'GET') {
        console.log("Got a " + request.method + " request?")
        return
    }

    // remove /garrysmod/ from start of path
    var rawPath = request.url.slice(11)
    var rawPathSplit = rawPath.split(".")
    var rawPathSplitSlash = rawPath.split("/")
    var path = ""

    // TODO: figure out how to compress maps and other large files
    if (rawPathSplit.includes("bz2") && rawPathSplitSlash.includes("maps")) {
        console.log("!!!!!!! FAILED TO SERVE REQUEST FOR COMPRESSED MAP " + rawPath + " !!!!!!! \n")
        response.writeHeader(404)
        response.end('404 Error: File Not Found')
        return
    }

    // remove .bz2 if it exists from the filename & set up the flag for later compression
    if (rawPathSplit.includes("bz2")) {
        rawPathSplit.pop()
        rawPath = rawPathSplit.join(".")
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

    // can't find the file requested, respond with 404
    if (path === "") {
        console.log("!!!!!!! FAILED TO SERVE REQUEST FOR " + rawPath + " !!!!!!! \n")
        response.writeHeader(404)
        response.end('404 Error: File Not Found')
        return
    }

    // if path contains a request for a compressed file, compress it & overwrite 
    // regardless of if it's already compressed (prevents old data being sent to clients)
    if (shouldCompFile) {
        console.log("Compressing file before sending..")
        
        var pathContent = fs.readFileSync(path)
        var compFile = path + ".bz2"
        var algorithm = compressjs.Bzip2
        var data = new Buffer.alloc(Buffer.byteLength(pathContent), path)
        var compressedData = algorithm.compressFile(data)
        fs.writeFileSync(compFile, compressedData)
        console.log("Compression complete!")
    }
    
    //file can now be sent out
    fs.readFile(path, function(err, content) {
        console.log("Serving request for " + path + "\n")
        response.writeHeader(200, {'Content-Length': Buffer.byteLength(content)})
        response.end(content)
    })
})

console.log("Starting FastDL server...")
server.listen(port)