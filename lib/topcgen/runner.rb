$:.unshift(File.dirname(__FILE__))
require 'topcgen/version'
require 'net/https'
require 'optparse'
require 'pp'
require 'json'
require 'readline'

module Topcgen
  def self.run
    options = parse_options
    settings = Settings.read_file '.topcgen.yml'
    settings[:credentials] = {} if settings[:credentials].nil?
    settings[:credentials][:user] = options[:user] unless options[:user].nil?
    settings[:credentials][:pass] = options[:pass] unless options[:pass].nil?
    browser = Browser.new

    begin
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

        message = 'please select an number or enter 0 for all (empty exits):'
        line = Readline.readline(message, false)

        selection = number line
        if !selection.nil? && selection >= 00 && selection < results.length
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
          problem = { :info => s }
          problem[:statement] = browser.get_statement s[:statement_link]
          problem[:tests] = browser.get_solution s[:solution_java]
          generate_java_files problem
        end
      end
    ensure
      browser.logout
    end
  end

  private
  
  def self.generate_java_files problems
    problems.each do |p|
      puts "generating: #{p}"

      info = p[:info]
      statement = p[:statement]
      tests = p[:tests]

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
     
      #paths = JAVA.get_paths
      #paths[:src_folder]
      #paths[:src_file]
      #paths[:test_folder]
      #paths[:test_file]
      #paths[:main_class_name]
      #paths[:test_class_name]
      
      src_folder = 'src'      # TODO: get main package
      src_file = "#{info[:name]}.java"
      
      test_folder = 'test'    # TODO: get test package
      test_file = "#{info[:name]}Test.java"
      
      File.open(src_file, 'w') do |f|
        f.rewind
        JAVA.main_class f, method, info
      end

      File.open(test_file, 'w') do |f|
        f.rewind
        JAVA.test_class f, method, info, test_values
      end

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

      raise OptionParser::MissingArgument.new '--class' if options[:class].nil?

      puts 'options detected'
      puts '----------------'
      pp options
      puts '----------------'

      options
    rescue OptionParser::MissingArgument => err
      puts err
      exit
    rescue OptionParser::InvalidOption
      puts parser
      exit
    end
  end
end
