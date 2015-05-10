require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox

driver.navigate.to "http://www.csuivi.courrier.laposte.fr/suivi"
driver.manage.window.maximize

element = driver.find_element(:id, 'masqueRechercheInit')
element.send_keys "00000000000"
element.submit

driver.save_screenshot("./screen.png")

sleep 5

driver.quit
