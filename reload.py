#!/usr/bin/env python

from livereload import Server, shell

server = Server()

server.watch('*.elm', shell('elm make --output elm.js SlideShow.elm'))

server.serve(root='./')
