Gem::Specification.new do |s|
  s.name          = "questiongenerator"
  s.summary       = "A Ruby utility for generating all questions for my music-ear-trainer project."
  s.description   = "This utility generates MIDI files for all permutations of chord roots, chord qualities, and chord inversions that are possible in my music ear trainer."
  s.license       = 'MIT'
  s.version       = "0.0.1"
  s.author        = "Juan Cortez"
  s.files         = Dir['**/**']
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.executables   = ['questiongenerator']
end
