require 'bundler/setup'
Bundler.require(:default)
require 'test/unit'
 
class TestSassPaths < Test::Unit::TestCase
 
  def test_simple_override
    paths = %w(theme core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    options = { :load_paths => paths, :syntax => :scss }

    template =
      File.read(
        File.expand_path(
          File.dirname(__FILE__) + '/stylesheets/core/all.scss'))

    engine = Sass::Engine.new(template, options)

    assert engine.render =~ /custom_theme/,
            'scss output does not match custom_theme'
  end

end
