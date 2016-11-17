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


  def test_simple_override_with_correct_filename_option
    paths = %w(theme core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    all_path =
      File.expand_path(File.dirname(__FILE__) + '/stylesheets/core/all.scss')

    custom_path =
      File.expand_path(File.dirname(__FILE__) + '/stylesheets/theme/custom.scss')

    options = { :load_paths => paths,
                :syntax => :scss,
                :filename => custom_path,
                :original_filename => all_path }

    template =
      File.read(
        File.expand_path(
          File.dirname(__FILE__) + '/stylesheets/core/all.scss'))

    engine = Sass::Engine.new(template, options)

    assert engine.render =~ /custom_theme/,
            'scss output does not match custom_theme'
  end

  def test_simple_override_with_incorrect_filename_option
    paths = %w(theme core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    all_path =
      File.expand_path(File.dirname(__FILE__) + '/stylesheets/core/all.scss')

    custom_path =
      File.expand_path(File.dirname(__FILE__) + '/stylesheets/core/custom.scss')

    options = { :load_paths => paths,
                :syntax => :scss,
                :filename => custom_path,
                :original_filename => all_path }

    template =
      File.read(
        File.expand_path(
          File.dirname(__FILE__) + '/stylesheets/core/all.scss'))

    engine = Sass::Engine.new(template, options)

    # Given both filename options point to the core dir, the rendered css should
    # NOT match the theme override
    assert engine.render !=~ /custom_theme/,
            'scss output matches custom_theme'
  end

end
