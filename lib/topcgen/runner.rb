$:.unshift(File.dirname(__FILE__))
require 'topcgen/version'
require 'net/https'
require 'optparse'
require 'pp'
require 'json'

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

      # TODO: implement the correct logic below
      #
      if results.length == 0
        puts 'no problems found that match your search criteria'
      elsif results.length > 1 
        puts "found #{results.length} results"
        results.each_with_index do |v, i| 
          puts "#{i}: #{v[:name]} #{v[:used_in]} #{v[:point_value]}"
        end
      else
        puts results[0]
        puts browser.get_statement results[0][:statement_link]
        solution = browser.get_solution results[0][:solution_java ]
        puts solution.tests
      end


      # TODO: search 
      #       let user select the correct problem if necessary
      #       get the problem doc
      #       get the problem tests
      #       generate class
      #       generate unit tests
    ensure
      browser.logout
    end
  end

  private

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
