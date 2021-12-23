#!/usr/bin/env ruby
require 'io/console'
require 'rmagick'
require 'rainbow'
require 'open-uri'


class Image2ASCII

    attr_reader :winsize
    attr_accessor :chars

    def initialize(uri)
        @uri = uri
        @winsize = IO.console.winsize[1]
        @chars = %($@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,"^`'.).reverse
        #quantum conversion factor for dealing with quantum depth color values
        @qcf = 1 
        
        if Magick::MAGICKCORE_QUANTUM_DEPTH > 16
            raise "ImageMagick quantum depth is set to #{Magick::MAGICKCORE_QUANTUM_DEPTH}. It needs to be 16 or less"
        elsif Magick::MAGICKCORE_QUANTUM_DEPTH == 16
            #divides quantum depth color space into useable rgb values
            @qcf = 257
        end
    end

    def generate(args={})

        args[:width]   ||= @winsize
        args[:color]   ||= "full"
        args[:hidden]  ||= false
        args[:block]   ||= false
        as_string = ""

        #load the image
        resource = URI.open(@uri)
        img = Magick::ImageList.new
        img.from_blob(resource.read)

        #correct aspect ratio
        img = img.scale(args[:width] / img.columns.to_f)
        img = img.scale(img.columns, img.rows / 2)

        img.each_pixel do |pixel, col, row|

            #get RGB values and brightness of pixels
            r = pixel.red / @qcf
            g = pixel.green / @qcf
            b = pixel.blue / @qcf
            brightness = (0.2126*r + 0.7152*g + 0.0722*b)
            #select from chars that are already pre-ordered in brightness
            char_index = brightness / (255.0 / @chars.length)
            char = @chars[char_index.floor]
            as_string << char

            chosen_color =
            if args[:color] == "full"
                [r, g, b]
            elsif args[:color] == "greyscale"
                [brightness, brightness, brightness]
            else
                args[:color]
            end

            if args[:block]
                print Rainbow(" ").background(*chosen_color) if !args[:hidden]
            else
                print Rainbow(char).color(*chosen_color) if !args[:hidden]
            end

            #add line wrap once desired width is reached
            if (col % (args[:width] - 1) == 0) and (col != 0)
                print "\n" if !args[:hidden]
                as_string << "\n"
            end

        end

        return as_string
    end 
end

