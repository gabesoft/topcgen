$:.unshift(File.dirname(__FILE__))
require 'topcgen/version'
require 'net/https'
require 'optparse'
require 'pp'
require 'json'
require 'readline'
require 'fileutils'
require 'logger'

# TODO: see file in topc_test/src/math/Islands.java
#       see error when selecting 0 on -c island

module Topcgen
  $log_file = '.topcgen.log'
  $log = Logger.new($log_file)

  def self.initialize_logger
    File.delete $log_file if File.exists? $log_file
    $log = Logger.new($log_file)
    $log.level = Logger::DEBUG
  end

  def self.run
    initialize_logger

    options = parse_options
    settings = Settings.read_file '.topcgen.yml'
    settings[:credentials] = {} if settings[:credentials].nil?
    settings[:credentials][:user] = options[:user] unless options[:user].nil?
    settings[:credentials][:pass] = options[:pass] unless options[:pass].nil?
    browser = Browser.new

    begin
      puts "running search for class #{options[:class]} ..."

      browser.login settings[:credentials]
      results = browser.search options[:class]
      selected = []

      if results.length == 0
        puts 'no problems were found that match your search criteria'
      elsif results.length > 1 
        puts "found #{results.length} results"
        results.each_with_index do |v, i| 
          puts "#{i + 1}: #{v[:name]} #{v[:used_in]} #{v[:point_value]}"
        end

        message = 'please select a number or enter 0 for all (empty exits): '
        line = Readline.readline(message, false)

        selection = number line
        if !selection.nil? && selection >= 0 && selection <= results.length
          selected = selection == 0 ? results : [ results[selection - 1] ]
        else
          puts 'invalid selection ... exiting'
        end
      else
        selected.push(results[0])
      end

      if selected.length > 0
        selected.each do |s|
          s[:package_root] = settings[:package_root]
          s[:main_imports] = settings[:main_imports]
          s[:test_imports] = settings[:test_imports]

          puts "generating files for class #{s[:name]} ..."
          #puts s[:name]
          #puts s[:statement_link_full]
          #puts s[:solution_java]

          problem = {}
          problem[:info] = s
          problem[:statement] = browser.get_statement s[:statement_link]
          problem[:solution] = browser.get_solution s[:solution_java]
          generate_java_files problem
        end
      end
    ensure
      browser.logout
    end
  end

  private

  def self.generate_java_files problem
    info = problem[:info]
    statement = problem[:statement]
    tests = problem[:solution].tests

    method = MethodParser.new(statement[:method], 
                              statement[:parameters], 
                              statement[:returns], 
                              statement[:signature])
    test_values = tests.map do |t|
      arg_types = method.parameters.map { |a| a[:type] }
      ret_types = [ statement[:returns] ]
      { :arguments  => ValueParser.parse(arg_types, t[:arguments]),
        :expected   => ValueParser.parse(ret_types, t[:expected]) }
    end

    package = JAVA::Package.new(info[:name], info[:package_root], info[:categories])

    write_file(package.src_file) do |f|
      JAVA.main_class f, package, method, info
    end
    write_file(package.test_file) do |f|
      JAVA.test_class f, package, method, info, test_values
    end
  end

  def self.write_file file
    dir = File.dirname file
    FileUtils.mkdir_p dir unless Dir.exists? dir

    if File.exists? file
      puts "skipped file #{file} (already exists)"
    else
      File.open(file, 'w') do |f|
        f.rewind
        yield f
      end
      puts "created file #{file}"
    end
  end

  def self.number str
    Integer(str) rescue nil
  end

  def self.parse_options
    options = {}

    parser = OptionParser.new do |opts|
      opts.on '-c', '--class CLASS_NAME', 'the problem class name' do |name|
        options[:class] = name
      end

      opts.on '-u', '--user [USER_NAME]', 'the topcoder user name' do |user|
        options[:user] = user
      end

      opts.on '-p', '--pass [PASSWORD]', 'the topcoder password' do |pass|
        options[:pass] = pass
      end

      opts.on_tail '-h', '--help', 'display this screen' do
        puts opts
        exit
      end

      opts.on_tail '-v', '--version', 'show version' do
        puts 'topcgen ' + Topcgen::VERSION
        exit
      end
    end

    begin
      parser.parse!
      options[:class] = ARGV[0] if options[:class].nil? && ARGV.length > 0
      raise OptionParser::MissingArgument.new '--class' if options[:class].nil?
      options
    rescue OptionParser::MissingArgument => err
      puts err
      puts parser
      exit
    rescue OptionParser::InvalidOption
      puts parser
      exit
    end
  end
end
