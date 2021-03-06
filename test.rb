require 'bundler/setup'
Bundler.require(:default)
require 'test/unit'
 
class TestSassPaths < Test::Unit::TestCase
 
  def setup
    @core_all_path =
      File.expand_path(File.dirname(__FILE__) + '/stylesheets/core/all.scss')

    @core_custom_path =
      File.expand_path(File.dirname(__FILE__) + '/stylesheets/core/custom.scss')

    @theme_custom_path =
      File.expand_path(File.dirname(__FILE__) + '/stylesheets/theme/custom.scss')
  end

  # Expecting theme/custom.scss to be used over core/custom.scss
  #
  # stylesheets/
  # ├── core
  # │   ├── all.scss
  # │   └── custom.scss
  # └── theme
  #     └── custom.scss
  def test_simple_override
    paths = %w(theme core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    options = { :load_paths => paths, :syntax => :scss }

    template = File.read(@core_all_path)
    engine = Sass::Engine.new(template, options)

    assert engine.render =~ /custom_theme/,
            'scss output does not match custom_theme'
  end

  def test_no_override
    paths = %w(core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    options = { :load_paths => paths, :syntax => :scss }

    template = File.read(@core_all_path)
    engine = Sass::Engine.new(template, options)

    assert engine.render =~ /custom_core/,
            'scss output does not match custom_core'
  end

  def test_simple_override_with_all_filename_option
    paths = %w(theme core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    options = { :load_paths => paths,
                :syntax => :scss,
                :filename => @core_all_path }

    template = File.read(@core_all_path)
    engine = Sass::Engine.new(template, options)

    # Interesting. This fails, maybe because the default importer's
    # find_relative is looking relative to stylesheets/core?
    assert engine.render =~ /custom_theme/,
            'scss output does not match custom_theme'
  end

  def test_simple_override_with_correct_filename_option
    paths = %w(theme core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    options = { :load_paths => paths,
                :syntax => :scss,
                :filename => @theme_custom_path }

    template = File.read(@core_all_path)
    engine = Sass::Engine.new(template, options)

    assert engine.render =~ /custom_theme/,
            'scss output does not match custom_theme'
  end

  def test_simple_override_with_incorrect_filename_option
    paths = %w(theme core).map do |dir|
      File.expand_path(File.dirname(__FILE__) + "/stylesheets/#{ dir }")
    end

    options = { :load_paths => paths,
                :syntax => :scss,
                :filename => @core_custom_path }

    template = File.read(@core_all_path)
    engine = Sass::Engine.new(template, options)

    # If the :filename option is used "solely for reporting errors", then this
    # test should pass, but it doesn't
    assert engine.render =~ /custom_theme/,
            'scss output does not match custom_theme'
  end

end
