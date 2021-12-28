require 'rmagick'
require 'image2ascii'
require 'json'
require 'fileutils'


animated = Magick::Image.read("image.gif")
count = 0
tempHash = {}
animated.each do |x|
    x.write("./images/image#{count}.jpg")
    dude = Image2ASCII.new("./images/image#{count}.jpg")
    dude.chars = dude.chars.gsub!("'", "").gsub!("<", "").gsub!(">", "") #remove characters that don't jive with our HTML (or characters you dont want included)
    text = dude.generate(hidden: true, width: 100)
    puts text
    tempHash["#{count}"] = text.gsub!("\n", "<br>")
    count = count + 1
end

FileUtils.rm_rf("./images/.", secure: true)

File.open("steps.json","w") do |f|
    f.write(tempHash.to_json)
end