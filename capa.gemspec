# frozen_string_literal: true

require_relative 'lib/capa/version'

Gem::Specification.new do |spec|
  spec.name = 'capa'
  spec.version = Capa::VERSION
  spec.authors = ['Shannon Skipper']
  spec.email = ['shannonskipper@gmail.com']

  spec.summary = 'Introspect the internal memory capacity of Ruby collections'
  spec.description = 'Uses Fiddle to expose the capacity of Array, Hash, Set, String and WeakKeyMap'
  spec.homepage = 'https://github.com/havenwood/capa'
  spec.required_ruby_version = '>= 4.0.0'
  spec.requirements = ['CRuby']
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'fiddle'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |filename|
      (filename == gemspec) || filename.start_with?(*%w[test/ .git Gemfile])
    end
  end
end
