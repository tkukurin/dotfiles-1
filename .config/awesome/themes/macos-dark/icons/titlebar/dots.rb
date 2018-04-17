#!/usr/bin/ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

path = "#{File.dirname(__FILE__)}"

configuration = {}
if File.exist?(path + '/dots.yml')
	configuration = YAML::load(File.read(path + '/dots.yml')) || {}
end

def drawCircle(dot, defaults)
	translate = (defaults['canvasSize'] / 2).to_s
	edge = defaults['canvasSize'].to_s

	# Generate base image
	system("convert -size " + edge + "x" + edge + " xc:none \
						-stroke '#" + dot['stroke'] + "' \
						-fill '#" + dot['fill'] + "' \
						-strokewidth " + defaults['strokeWidth'].to_s + " \
						-draw 'translate " + translate + "," + translate + " circle 0,0 " + defaults['radius'].to_s + ",0' \
						" + dot['name'] + ".png")

	# Compress image
	def hasOptipng
		return system('optipng -v')
	end
	if hasOptipng
		system('optipng -o7 ' + dot['name'] + '.png')
	end

	# Copy image to its filenames
	dot['filenames'].each do |name|
		system('cp ' + dot['name'] + '.png ' + name)
	end

	# Remove base image
	system('unlink ' + dot['name'] + '.png ')
end

configuration['dots'].each do |dot|
	drawCircle(dot, configuration['defaults'])
end

