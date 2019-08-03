# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bigipcookie/version'
require 'rake/file_list'

Gem::Specification.new do |s|
  s.name          = 'rabid'
  s.version       = Version::VERSION
  s.platform      = Gem::Platform::RUBY
  s.date          = '2019-07-16'
  s.summary       = 'RApid Big IP Decoder'
  s.description   = 'A library and CLI tool allowing to decode all 4 types'\
                    ' of BigIP cookies'
  s.authors       = ['Alexandre ZANNI']
  s.email         = 'alexandre.zanni@engineer.com'
  s.homepage      = 'https://orange-cyberdefense.github.io/rabid/'
  s.license       = 'MIT'

  s.files         = Rake::FileList['**/*'].exclude(*File.read('.gitignore').split)
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test)/})
  s.require_paths = ['lib']

  s.metadata = {
    'yard.run'          => 'yard',
    'bug_tracker_uri'   => 'https://github.com/Orange-Cyberdefense/rabid/issues',
    'changelog_uri'     => 'https://github.com/Orange-Cyberdefense/rabid/blob/master/docs/CHANGELOG.md',
    'documentation_uri' => 'https://orange-cyberdefense.github.io/rabid/',
    'homepage_uri'      => 'https://orange-cyberdefense.github.io/rabid/',
    'source_code_uri'   => 'https://github.com/Orange-Cyberdefense/rabid/',
  }

  s.required_ruby_version = '~> 2.4'

  s.add_runtime_dependency('docopt', '~> 0.6') # for argument parsing
  s.add_runtime_dependency('paint', '~> 2.1') # for colorized ouput

  s.add_development_dependency('bundler', '~> 2.0')
  s.add_development_dependency('commonmarker', '~> 0.18') # for GMF support in YARD
  s.add_development_dependency('github-markup', '~> 3.0') # for GMF support in YARD
  s.add_development_dependency('minitest', '~> 5.11')
  s.add_development_dependency('rake', '~> 12.3')
  s.add_development_dependency('redcarpet', '~> 3.4') # for GMF support in YARD
  s.add_development_dependency('rubocop', '~> 0.63')
  s.add_development_dependency('yard', '~> 0.9')
end
