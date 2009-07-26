require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |spec|
    spec.name = 'tea'
    spec.summary = 'A simple game development library for Ruby.'
    spec.files = FileList['README.rdoc', 'COPYING*',
                          'lib/tea.rb', 'lib/tea/*.rb',
                          'doc/*.textile',
                          'doc/example/*.rb', 'doc/example/smile.png'].to_a
    spec.add_dependency 'rubysdl'

    spec.author = 'Tung Nguyen'
    spec.email = 'tunginobi@gmail.com'
    spec.description = <<-DESCRIPTION
Tea is a library for making simpler games from a simpler age.
It's designed with these things in mind:

 - 0 is better than 1, and 1 is better than 2.
 - Simplicity beats speed.
 - Value and convenience can sometimes beat simplicity.
 - Procedural beats object-oriented in a dead-heat.
    DESCRIPTION
    spec.homepage = 'http://github.com/tung/tea'
    spec.has_rdoc = true
  end
rescue LoadError
  puts 'Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com'
end
