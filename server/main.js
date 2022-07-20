const {WebSocketServer} = require("ws")
const {port} = require("../client/config.json")

const wss = new WebSocketServer({port: port})


module.exports = () => {

    //TODO: make this proper
    let buffer = new Buffer(JSON.stringify({
        status: 1,
        data: "print'hi'"
    }))

    //This is probably the worst code i've ever written
    wss.on("connection", async ws => {
        while (true) {
            ws.send(buffer.toString("base64"))
            await new Promise(resolve => setTimeout(resolve, 1000))
        }
    })
}