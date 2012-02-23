require 'test/unit'
require_relative '../rycompressor.rb'

class RYCompressorTest < Test::Unit::TestCase

  FIXTURE_PATH = File.expand_path( 'fixture', File.dirname(__FILE__) )

  def setup
    @core = RYCompressor.new
  end

  def teardown
    minified = File.join FIXTURE_PATH, '*-min.*' 
    Dir.glob( minified ) { |f| File.delete f }
  end

  def test_css_file_will_be_compressed
    file = fixture('test.js')
    assert @core.to_compress? file

    @core.compress file
    assert File.exist? fixture('test-min.js')
  end

  def test_js_file_will_be_compressed
    file = fixture('test.css')
    assert @core.to_compress? file

    @core.compress file
    assert File.exist? fixture('test-min.css')
  end

  def test_other_files_will_not_be_compressed
    file = fixture('test.html')
    assert !@core.to_compress?( file )

    assert !@core.compress( file )
  end

  def test_non_existing_file
    file = fixture('you-will-never-catch-me.js')

    # 'to_compress?' method only check by name
    assert @core.to_compress?( file )

    # compressing will fail natively 
    assert !@core.compress( file )
    assert !File.exist?( fixture('you-will-never-catch-me-min.css') )
  end

  def test_merge_file_will_not_be_compressed
    file = fixture('test-merge.css')
    assert !@core.to_compress?( file )
    assert !@core.compress( file )
    assert !File.exist?( fixture('test-merge-min.css') )
  end

  def test_on_folder_as_target
    @core.compress FIXTURE_PATH
    assert File.exist? fixture('test-min.js')
    assert File.exist? fixture('test-min.css')
  end

  private
  def fixture(file)
    File.join FIXTURE_PATH, file
  end

end
