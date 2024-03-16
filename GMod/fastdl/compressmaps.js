const mapDir       = "../garrysmod/maps",
      compressjs   = require("compressjs"),
      fs           = require("fs")

function compress(map) {
    var pathContent = fs.readFileSync(map)
    var compFile = map + ".bz2"
    var algorithm = compressjs.Bzip2
    console.log("Compressing file at " + compFile)
    var bufferedData = new Buffer.alloc(Buffer.byteLength(pathContent), map)
    var compressedData = algorithm.compressFile(bufferedData)
    fs.writeFileSync(compFile, compressedData)
    console.log("Compression of " + compFile + " complete!")
}

async function compressMaps() {
    const dir = await fs.promises.opendir(mapDir)
    for await (const dirent of dir) {
        fullPath = dirent.path + "/" + dirent.name
        if (fullPath.split(".").includes("bsp") && !(fullPath.split(".").includes("bz2"))) {
            compress(fullPath)
        }
    }
}

module.exports = compressMaps()