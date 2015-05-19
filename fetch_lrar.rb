def fetch_lrar lrar, logger
  #lrar = "2C09912810639"
  d = DateTime.now
  date = "#{d.year}-#{d.month}-#{d.day}_#{d.hour}h#{d.min}.#{d.sec}"

  logger.debug("LRAR number is #{lrar}")
  logger.debug("DATE format is #{date}")

  driver = Selenium::WebDriver.for :firefox

  begin

    driver.navigate.to "http://www.csuivi.courrier.laposte.fr/suivi"
    driver.manage.window.maximize

    element = driver.find_element(:id, 'masqueRechercheInit')
    element.send_keys lrar
    element.submit

    driver.save_screenshot("./#{lrar}/#{lrar}-#{date}.png")

    logger.debug("Screenshot saved to #{lrar}-#{date}.png")

    driver.quit

    #if Firefox window is closed before end of script
  rescue Errno::ECONNREFUSED => e
    logger.fatal("Caught exception for element #{lrar}; exiting")
    logger.fatal(e.message)

    #if website or div element is not available
  rescue Selenium::WebDriver::Error::NoSuchElementError => e
    logger.fatal("Caught exception for element #{lrar}; exiting")
    logger.fatal(e.message)

    #if Firefox window is closed before end of script
  rescue EOFError => e
    logger.fatal("Caught exception for element #{lrar}; exiting")
    logger.fatal(e.message)

    #if website timeout
  rescue Net::ReadTimeout => e
    logger.fatal("Caught exception for element #{lrar}; exiting")
    logger.fatal(e.message)

  end
end
