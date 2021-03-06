$:.unshift(File.dirname(__FILE__))
require 'topcgen/version'
require 'net/https'
require 'optparse'
require 'json'
require 'readline'
require 'fileutils'
require 'logger'

module Topcgen
  $log_file = '.topcgen.log'

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
    settings[:tab_size] = 4 if settings[:tab_size].nil?
    settings[:credentials][:user] = options[:user] unless options[:user].nil?
    settings[:credentials][:pass] = options[:pass] unless options[:pass].nil?
    options[:tab_size] = settings[:tab_size]
    browser = Browser.new

    begin
      puts "logging in with user #{settings[:credentials][:user]} ..."

      browser.login settings[:credentials]
      puts "running search for class #{options[:class]} ..."

      $log.info "login for user #{settings[:credentials][:user]} #{browser.logged_in ? 'succeeded' : 'failed'}"

      results = browser.search options[:class]
      selected = []

      $log.info "search for class #{options[:class]} returned #{results.length} results"

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
          s[:package_root]        = settings[:package_root]
          s[:main_imports]        = settings[:main_imports]
          s[:test_imports]        = settings[:test_imports]
          s[:test_runner_path]    = settings[:test_runner_path]
          s[:test_runner_imports] = settings[:test_runner_imports]

          puts "generating files for class #{s[:name]} ..."
          $log.info "generating files for class #{s[:name]}"

          begin
            problem               = {}
            problem[:info]        = s
            problem[:statement]   = get_statement(browser, s[:statement_link])
            problem[:solution]    = get_solution(browser, s)

            generate_java_files(problem, options)
          rescue Exception => e
            $log.error e.message
            $log.error e.backtrace.join("\n\t")
            puts "failed to generate files see #{$log_file} for details"
          end
        end
      end
    ensure
      puts "logging out ..."
      browser.logout
    end
  end

  private

  def self.get_solution(browser, info)
    links = [ info[:solution_java], info[:solution_cpp], info[:solution_csharp], info[:solution_vb] ]

    solution = nil
    index = 0
    while (solution == nil || solution.tests == nil || solution.tests.length == 0) && (index < links.count)
      begin
        link = links[index]
        index += 1
        solution = browser.get_solution link
      rescue Exception => e
        $log.error "failed to get the problem solution"
        $log.error "solution link: #{link}"
        $log.error e.message
        $log.error e.backtrace.join("\n\t")
      end
    end

    solution
  end

  def self.get_statement(browser, link)
    browser.get_statement link
  end

  def self.generate_java_files(problem, options)
    info = problem[:info]
    statement = problem[:statement]
    tests = problem[:solution].nil? ? statement.tests : problem[:solution].tests

    method = MethodParser.new(statement[:method],
                              statement[:parameters],
                              statement[:returns],
                              statement[:signature])
    test_values = tests.map do |t|
      arg_types = method.parameters.map { |a| a[:type] }
      ret_types = [ statement[:returns] ]
      { :arguments  => ValueParser.parse(arg_types, t[:arguments]),
        :expected   => ValueParser.parse(ret_types, t[:expected])[0] }
    end

    package = JAVA::Package.new(info[:name], info[:package_root], info[:categories])

    JAVA.set_tab_size(options[:tab_size])

    write_file(package.src_file, options[:force]) do |f|
      JAVA.main_class f, package, method, info
    end
    write_file(package.test_file, options[:force]) do |f|
      JAVA.test_class f, package, method, info, test_values
    end
    write_file(package.test_runner_file, options[:runner]) do |f|
      JAVA.test_runner_class f, package, method, info
    end
  end

  def self.write_file(file, force)
    dir = File.dirname file
    FileUtils.mkdir_p dir unless Dir.exists? dir

    exists = File.exists? file
    if exists && !force
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

      opts.on '-f', '--force', 'overwrite existing files' do |force|
        options[:force] = force
      end

      opts.on '-r', '--runner', 'also generate a test runner class' do |runner|
        options[:runner] = runner
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
