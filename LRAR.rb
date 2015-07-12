#!/usr/bin/ruby
#
# Shots screenshots on LaPoste.fr
#
# (c) Benjamin Vialle, 2015.

URL = "http://www.csuivi.courrier.laposte.fr/suivi"

begin
  # in order to log
  require 'logger'
  # in order to parse console arguments
  require 'getoptlong'
  # we use selenium to drive Firefox
  require "selenium-webdriver"
  # used for DateTime functions
  require 'time'
  # used to parse CSV file
  require 'csv'
rescue LoadError => e
  puts "Required library not found: '#{e.message}'."
  exit(1)
end

require_relative("fetch_lrar.rb")

opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--file', '-f', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--lrar', '-l', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--debug', '-d', GetoptLong::NO_ARGUMENT ]
    )

loglevel = 'INFO'

csv = ""
lrar = ""

opts.each do |opt, arg|
  case opt
  when '--help'
    puts <<-EOF
     -h, --help:
        show help

     -f, --file <file>:
        reads LRAR numbers from text file
        one LRAR number per line,one date per line


     -l, --lrar <LRAR>:
        reads LRAR number from CLI
        if -f option is used, -l option is desactivated

     -d, --debug:
        debug level (INFO, WARN, DEBUG)

    EOF
    exit (0)
  when '--file'
    csv = arg
  when '--lrar'
    #TODO: arg correctly formated
    lrar = arg
  when '--debug'
    loglevel = 'DEBUG'
  end

end

if ARGV.length != 0
  puts "No argument is required (try --help)"
  exit 0
end

# Start Logging
logger = Logger.new(STDOUT)
# Set the log level here
case loglevel
when 'INFO'
  logger.level = Logger::INFO
when 'DEBUG'
  logger.level = Logger::DEBUG
when 'WARN'
  logger.level = Logger::WARN
end

logger.debug("Log level is set to #{loglevel}")


if lrar.empty? and csv.empty?
  puts "Please give -l argument or -f argument"
  logger.info("Please give -l argument or -f argument")
  exit(1)
end

if lrar.empty?
  # some CSV file opened with Microsoft Excel contains ; instead of ,
  logger.info("Replacing ';' by ',' in #{csv}")
  text = File.read(csv)
  new_contents = text.gsub(/;/, ",")
  File.open("lrar_clean.csv", "w") {|file| file.puts new_contents }

  logger.info("Reading lrar from CSV file")
  rows = CSV.read("lrar_clean.csv")
  logger.info(rows.inspect)
  # Status :
  #          0 -> to be fetched
  #          1 -> deadline reached without having succeeded
  #          2 -> error on website
  #          3 -> lrar is delivered and screenshot proves it
  rows.each do |lrar, date|

    # Creates a directory to save the screenshot
    if not Dir.exist?(File.dirname(__FILE__) + "/#{lrar}")
      Dir.mkdir(File.dirname(__FILE__) + "/#{lrar}")
    end
    fetch_lrar(lrar, logger)
  end

  logger.info("End of file lrar_clean.csv")
  logger.info("Removing lrar_clean.csv")
  File.delete("lrar_clean.csv")

end

if csv.empty?
  logger.info("Reading lrar from command line")
  # Creates a directory to save the screenshot
  if not Dir.exist?(File.dirname(__FILE__) + "/#{lrar}")
    Dir.mkdir(File.dirname(__FILE__) + "/#{lrar}")
  end
  fetch_lrar(lrar, logger)
end
