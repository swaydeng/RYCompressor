#!/usr/bin/env ruby

class RYCompressor
  DEFAULT_OPTIONS = { 
    jar: "yuicompressor-2.4.7.jar", # core jar path
    charset: "GBK"
  }.freeze
  
  def initialize(options = {})
    @options = DEFAULT_OPTIONS.merge(options.reject {|k, v| v.nil?})
  end

  def compress(src)
    file = File.absolute_path(src)
    if File.file?(file) 
      compress_file(file) if to_compress?(file)
    elsif File.directory?(file) # Do not support recursion
      Dir.glob(File.join(file, "*.{css,js}")) { |f| compress(f) }
    else
      puts "Legal file or directory must be supplied!"
    end
  end

  private
  # file: absolute file path,the file should be css or js file.
  def compress_file(file)
    ext = File.extname(file) 
    type = ext[1..-1]
    minfile = file.dup.insert(file.rindex("."), "-min")
    result = %x[java -jar #{@options[:jar]} --type #{type} --charset #{@options[:charset]} -o #{minfile} #{file}]
    puts "#{file} => #{minfile}"
  end
  # Return true if the file is a js or css file, and it hasn't been compressed, 
  # and (optional) it is not a merge file  
  def to_compress?(file)
      name = File.basename(file)
    ext = File.extname(file)
    merge_file = /-merge\.(css|js)$/ =~ name || name == "merge"+ext
    /\.(css|js)$/ =~ name && /-min\.(css|js)$/ !~ name && !merge_file
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
