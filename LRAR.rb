#!/usr/bin/ruby
#
# Shots screenshots on LaPoste.fr
#
# (c) Benjamin Vialle, 2015.

begin
  # in order to log
  require 'logger'
  # in order to parse console arguments
  require 'getoptlong'
  # we use selenium to drive Firefox
  require "selenium-webdriver"
  # used for DateTime functions
  require 'time'
rescue LoadError => e
  puts "Required library not found: '#{e.message}'."
  exit(1)
end

opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--file', '-f', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--lrar', '-l', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--debug', '-d', GetoptLong::NO_ARGUMENT ]
    )

LOGLEVEL = 'INFO'

opts.each do |opt, arg|
  case opt
  when '--help'
    puts <<-EOF
     -h, --help:
        show help

     -f, --file <file>:
        NOT IMPLEMENTED YET
        reads LRAR numbers from text file
        one LRAR number per line

     -l, --lrar <LRAR>:
        reads LRAR number from CLI

     -d, --debug:
        debug level (INFO, WARN, DEBUG)

    EOF
    exit (0)
  when '--file'
    puts "Reading from file is not implemented yet."
    exit (0)
  when '--lrar'
    #TODO: arg correctly formated
    LRAR = arg
  when '--debug'
    LOGLEVEL = 'DEBUG'
  end
end

if ARGV.length != 0
  puts "No argument is required (try --help)"
  exit 0
end

class LRARRecovery

  # Start Logging
  logger = Logger.new(STDOUT)
  # Set the log level here
  case LOGLEVEL
  when 'INFO'
    logger.level = Logger::INFO
  when 'DEBUG'
    logger.level = Logger::DEBUG
  when 'WARN'
    logger.level = Logger::WARN
  end
  logger.debug("Log level is set to #{LOGLEVEL}")

  #LRAR = "2C09912810639"
  d = DateTime.now
  DATE = "#{d.year}-#{d.month}-#{d.day}_#{d.hour}h#{d.min}.#{d.sec}"
  URL = "http://www.csuivi.courrier.laposte.fr/suivi"

  logger.debug("LRAR=#{LRAR}")
  logger.debug("DATE=#{DATE}")

  driver = Selenium::WebDriver.for :firefox

  begin

    driver.navigate.to "http://www.csuivi.courrier.laposte.fr/suivi"
    driver.manage.window.maximize

    element = driver.find_element(:id, 'masqueRechercheInit')
    element.send_keys LRAR
    element.submit

    driver.save_screenshot("./#{LRAR}-#{DATE}.png")

    sleep 5

    driver.quit

    #if Firefox window is closed before end of script
  rescue Errno::ECONNREFUSED => e
    logger.fatal("Caught exception for element #{LRAR}; exiting")
    logger.fatal(e.message)
    exit(1)

    #if website or div element is not available
  rescue Selenium::WebDriver::Error::NoSuchElementError => e
    logger.fatal("Caught exception for element #{LRAR}; exiting")
    logger.fatal(e.message)
    exit(1)
  end

end
