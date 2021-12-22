Gem::Specification.new do |s|
    s.name        = 'image2ascii'
    s.version     = '1.0.0'
    s.summary     = "Convert images to custom ASCII art"
    s.executables << 'image2ascii'
    s.description = 
    "An RMagick-based ASCII art generator that allows custom characters, colors, ands widths. Can also detect terminal window size for responsive output."
    s.authors     = ["Michael Kofron"]
    s.email       = 'kofronmichael@gmail.com'
    s.files       = ["lib/image2ascii.rb"]
    s.homepage    =
      'https://rubygems.org/gems/image2ascii'
    s.license       = 'MIT'
  end