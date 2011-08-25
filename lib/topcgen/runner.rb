$:.unshift(File.dirname(__FILE__))
require 'topcgen/version'
require 'net/https'
require 'optparse'
require 'pp'
require 'json'

module Topcgen
  def self.run
    options = parse_options
    settings = Settings.read 'settings.yml'
    settings['credentials'] = { 'user' => options[:user] } unless !options[:user]
    settings['credentials'] = { 'pass' => options[:pass] } unless !options[:pass]
    browser = Browser.new

    browser.login settings[:credentials]
    browser.search options[:class]

    # TODO: search 
    #       let user select the correct problem if necessary
    #       get the problem doc
    #       get the problem tests
    #       generate class
    #       generate unit tests
  end

  def self.parse_options
    options = {}

    parser = OptionParser.new do |opts|
      opts.on '-c', '--class CLASS_NAME', 'The problem class name' do |name|
        options[:class] = name
      end

      opts.on '-u', '--user [USER_NAME]', 'The topcoder user name' do |user|
        options[:user] = user
      end

      opts.on '-p', '--pass [PASSWORD]', 'The topcoder password' do |pass|
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

      puts 'options detected'
      puts '----------------'
      pp options
      puts '----------------'

      options
    rescue OptionParser::InvalidOption
      puts parser
      exit
    end
  end
end
