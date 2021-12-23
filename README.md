# image2ascii
<img src="images/emoji.png" width="200">
Convert images to custom ASCII art with code or from the command-line

Installation
----------

`$ gem install image2ascii`

Use with code
----------

  #### - With defaults -

      require "image2ASCII"
      
      ascii = Image2ASCII.new("/path/to/img.jpg")
      ascii.generate
      
  #### - Change width -
  
        ascii = Image2ASCII.new("/path/to/img.jpg")
        
        ascii.generate(width: 30)
        ascii.generate(width: ascii.winsize)        #default
        ascii.generate(width: ascii.winsize / 2)    #half of window size
        
  #### - Change color -
  
        ascii = Image2ASCII.new("/path/to/img.jpg")
        
        ascii.generate(color: "full")          #default
        ascii.generate(color: "greyscale")
        ascii.generate(color: "#FFFFFF")
        ascii.generate(color: [255, 255, 255])
        ascii.generate(color: "white")
        
  #### - Print as blocks -
  this will print to the terminal as blocks. Works with greyscale or full color.
  
        ascii.generate(block: false)  #default
        ascii.generate(block: true)
        
  #### - Hide from terminal -
  The "generate" command returns a string, to capture this string without outputting to the terminal we can stop it from printing
  
        image_as_ascii = ascii.generate(hidden: true)
        puts image_as_ascii
        
  #### - Change character map -
  The character map can be changed. It is crucial that they are ordered ascending or descending in apparent brightness
  
        ascii = Image2ASCII.new("/path/to/img.jpg")
        
        ascii.chars = "@#-."   #@ appears brighter than #,  # is brighter than -, etc
        ascii.generate
        
        #default = ".'`^",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$"
        
   To reverse the order for an "inverted" effect you can reverse the default string
   
        ascii.chars = ascii.chars.reverse
        ascii.generate

Use from command-line
----------

