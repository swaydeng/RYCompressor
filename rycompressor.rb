#!/usr/bin/env ruby

class RYCompressor
  DEFAULT_OPTIONS = { 
    core_jar_path: File.expand_path( "yuicompressor-2.4.7.jar", File.dirname(__FILE__) ),
    charset: "GBK"
  }.freeze
  
  def initialize(options = {})
    @options = DEFAULT_OPTIONS.merge(options.reject {|k, v| v.nil?})
  end

  def compress(file)
    if File.file?(file) 
      compress_file(file) if to_compress?(file)
    elsif File.directory?(file) # Do not support recursion
      Dir.glob(File.join(file, "*.{css,js}")) { |f| compress(f) }
    else
      warn "Legal file or directory must be supplied!"
    end
  end
  
  def to_compress?(file)
    is_normal_js_or_css? file and not is_merge_file? file
  end

  protected
  def is_normal_js_or_css? file
    file =~ /(?<!-min)\.(js|css)$/
  end

  def is_merge_file? file
    file =~ /merge\./
  end

  # file: absolute file path,the file should be css or js file.
  def compress_file(file)
    ext = File.extname(file) 
    type = ext[1..-1]
    minfile = file.dup.insert(file.rindex("."), "-min")
    result = %x[java -jar #{@options[:core_jar_path]} --type #{type} --charset #{@options[:charset]} -o #{minfile} #{file}]
    puts "#{file} => #{minfile}"
    result
  end
  # Simple help infomation
  def self.usage
    puts "You need supply at least one file or directory as parameter. e.g.:",
       "./rycompressor.rb some-file.js some/dir/"
  end
end

if __FILE__ == $0
  if ARGV.size == 0
    RYCompressor.usage
  else
    cpsr = RYCompressor.new
    ARGV.each { |src| cpsr.compress(src) }
  end
end
