"use strict"

const PORT_NUMBER = process.env.PORT || 8080

var http = require('http')
var fs = require('fs')
var path = require('path')
var mime = require('mime')

var server = http.createServer(function(request, response) {
    var filePath = false
    if (request.url == '/') {
        filePath = 'public/index.html'
    }
    else {
        filePath = 'public' + request.url
    }
    var absPath = './' + filePath
    serveStatic(response, absPath)
})

server.listen(PORT_NUMBER, function() {
    console.log(`Server is listening on port ${PORT_NUMBER}`)
})

function serveStatic(response, absPath) {
    fs.access(absPath, function(err) {
        if (!err) {
            fs.readFile(absPath, function(err, data) {
                if (err) {
                    send404(response)
                }
                else {
                    sendFile(response, absPath, data)
                }
            })
        }
        else {
            send404(response)
        }  
    })
}

function send404(response) {
    response.writeHead(404, {'Content-Type' : 'text/plain'})
    response.write('Error 404: resource not found.')
	response.end()
}

function sendFile(response, filePath, fileContents) {
	response.writeHead(
		200,
		{"content-type": mime.lookup(path.basename(filePath))}
	)
	response.end(fileContents)
}


