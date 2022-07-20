const fs = require("fs-extra")
const fss = require("fs")


const load = () => {
    require("./server/main")()
}


let idx = process.argv.indexOf("--path") + 1

//indexOf returns -1 if element does not exist, so -1 + 1 = 0, and under normal condition argv[0] is node.exe
if (idx === 0) {
    console.log("Did you even provide a --path argument..?")
    process.exit()
}

let pathStr = process.argv[idx]

if (!pathStr.endsWith("/")) pathStr += "/"

for (let file of fss.readdirSync("./client")) {
    let source = "./client/" + file
    let destination = pathStr
    if (file === "config.json") {
        destination += "workspace/"
    } else {
        destination += "autoexec/"
    }
    destination += file

    fs.copy(source, destination).catch(error => {
        console.error(error)
    })

}

load()
