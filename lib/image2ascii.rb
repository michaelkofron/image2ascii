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
        # quantum conversion factor for dealing with quantum depth color values
        @qcf = 1

        if Magick::MAGICKCORE_QUANTUM_DEPTH > 16
            raise "ImageMagick quantum depth is set to #{Magick::MAGICKCORE_QUANTUM_DEPTH}. It needs to be 16 or less"
        elsif Magick::MAGICKCORE_QUANTUM_DEPTH == 16
            # divides quantum depth color space into usable rgb values
            @qcf = 257
        end
    end

    def generate(args={})

        args[:width]   ||= @winsize
        args[:color]   ||= "full"
        args[:hidden]  ||= false
        args[:block]   ||= false

        if args[:format] == :html
            generate_html(args)
        else
            generate_string(args)
        end
    end

    private

    def generate_string(args={})
        ascii_string = ""

        resource = URI.open(@uri)
        img = Magick::ImageList.new
        img.from_blob(resource.read)

        img = correct_aspect_ratio(img, args[:width])

        img.each_pixel do |pixel, col, row|
            r, g, b, brightness = get_pixel_values(pixel)

            char = select_character(brightness)
            ascii_string << char

            chosen_color = get_chosen_color(args[:color], r, g, b)

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

        return ascii_string
    end

    def generate_html(args={})
        html = ""

        resource = URI.open(@uri)
        img = Magick::ImageList.new
        img.from_blob(resource.read)

        img = correct_aspect_ratio(img, args[:width])

        img.each_pixel do |pixel, col, row|
            r, g, b, brightness = get_pixel_values(pixel)

            char = select_character(brightness)
            chosen_color = "rgb(#{r}, #{g}, #{b})"

            html << "<span style=\"color: #{chosen_color};\">#{char}</span>"

            if (col % (args[:width] - 1) == 0) and (col != 0)
                html << "<br>"
            end
        end

        return html
    end

    def correct_aspect_ratio(img, width)
        img = img.scale(width / img.columns.to_f)
        img = img.scale(img.columns, img.rows / 2)
    end

    def get_pixel_values(pixel)
        r = pixel.red / @qcf
        g = pixel.green / @qcf
        b = pixel.blue / @qcf
        brightness = (0.2126 * r + 0.7152 * g + 0.0722 * b)

        return r, g, b, brightness
    end

    def select_character(brightness)
        char_index = brightness / (255.0 / @chars.length)
        @chars[char_index.floor]
    end

    def get_chosen_color(color, r, g, b)
        if color == "full"
            [r, g, b]
        elsif color == "greyscale"
            [r, r, r]
        else
            color
        end
    end
end
