#!/usr/bin/ruby
#
# Shots screenshots on LaPoste.fr
#
# (c) Benjamin Vialle, 2015.
#
# 0 ; OK
# 1 ; WARNING
# 2 ; CRITICAL
# 3 ; UNKNOWN

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
  $stderr.puts "Required library not found: '#{e.message}'."
  exit(2)
end

OPTS = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--debug', '-d', GetoptLong::OPTIONAL_ARGUMENT ]
    )

class LRAR

  LRAR = "2C09912810639"
  URL = "http://www.csuivi.courrier.laposte.fr/suivi"

  # Start Logging
  log = Logger.new(STDOUT)
  # Set the log level here
  log.level = Logger::INFO


  driver = Selenium::WebDriver.for :firefox

  begin

    driver.navigate.to "http://www.csuivi.courrier.laposte.fr/suivi"
    driver.manage.window.maximize

    element = driver.find_element(:id, 'masqueRechercheInit')
    element.send_keys LRAR
    element.submit

    driver.save_screenshot("./#{LRAR}-screen.png")

    sleep 5

    driver.quit

    #if Firefox window is closed before end of script
  rescue Errno::ECONNREFUSED => e
    $stderr.puts e.message
    exit(2)
  end

end
