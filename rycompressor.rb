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
    elsif File.directory?(file) 
      # support recursion!
      Dir.glob(File.join(file, "*")) do |f| 
        compress(f)
      end
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
    type    = file[/\.(css|js)$/, 1]
    minfile = file.sub /(?=\.(css|js)$)/, "-min"

    # SECURITY NOTICE:
    # some fields come from user specificated source
    # e.g. charset can be ' gbk && sudo rm / '
    # This is dangerous especially when this script 
    # acts as a web service.
    result  = %x[
      java  -jar      #{@options[:core_jar_path]} \
            --type    #{type} \
            --charset #{@options[:charset]} \
            -o        #{minfile} #{file}
      ] 

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
  if ARGV.empty?
    RYCompressor.usage
  else
    cpsr = RYCompressor.new
    ARGV.each { |src| cpsr.compress(src) }
  end
end
