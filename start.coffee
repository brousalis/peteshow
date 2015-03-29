#!/usr/bin/env coffee
runCommand = require('run-command')
dotenv     = require('dotenv')
dotenv.load()

console.log("[NODE_ENV] " + process.env.NODE_ENV)

runCommand("gulp", ['server'])
