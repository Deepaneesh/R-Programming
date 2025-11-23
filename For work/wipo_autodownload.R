library(chromote)
library(rvest)

desired_year <- 2024
# --- 1. Start Chrome ---
b <- ChromoteSession$new()
b$view()  # launches browser

# --- 2. Navigate to WIPO page ---
b$Page$navigate("https://www3.wipo.int/ipstats/key-search/indicator")
b$Page$waitForLoad()
Sys.sleep(2)

# --- 3. Click navigation button ---
nav_button_xpath <- "/html/body/app-root/div/app-key-search/app-navigation/w-sticky-bar/div/nav/ul[1]/w-sticky-bar-link[4]/a"
b$Runtime$evaluate(sprintf("
var elem = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(elem) { elem.click(); } else { console.log('Nav button not found'); }
", nav_button_xpath))
Sys.sleep(2)

# --- 4. Select first dropdown ---
dropdown1_xpath <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/w-edit-panel[1]/div[1]/w-section[1]/div[2]/w-slot/w-select-one[1]/div/div/select"
option1_xpath   <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/w-edit-panel[1]/div[1]/w-section[1]/div[2]/w-slot/w-select-one[1]/div/div/select/option[3]"

b$Runtime$evaluate(sprintf("
var select = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
var option = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(select && option) { select.value = option.value; select.dispatchEvent(new Event('change')); } else { console.log('Dropdown1 not found'); }
", dropdown1_xpath, option1_xpath))
Sys.sleep(1)

# --- 5. Select second dropdown ---
dropdown2_xpath <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/w-edit-panel[1]/div[1]/w-section[1]/div[2]/w-slot/w-select-one[2]/div/div/select"
option2_xpath   <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/w-edit-panel[1]/div[1]/w-section[1]/div[2]/w-slot/w-select-one[2]/div/div/select/option[3]"

b$Runtime$evaluate(sprintf("
var select = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
var option = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(select && option) { select.value = option.value; select.dispatchEvent(new Event('change')); } else { console.log('Dropdown2 not found'); }
", dropdown2_xpath, option2_xpath))
Sys.sleep(1)

# --- 6. Select year dynamically ---
year_dropdown_xpath <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/w-edit-panel[1]/div[1]/w-section[2]/div[2]/w-slot[2]/w-select-one/div/div/select"


b$Runtime$evaluate(sprintf("
var select = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(select) {
  var options = select.options;
  for(var i = 0; i < options.length; i++) {
    if(options[i].text == '%d') { select.value = options[i].value; select.dispatchEvent(new Event('change')); break; }
  }
} else { console.log('Year dropdown not found'); }
", year_dropdown_xpath, desired_year))
Sys.sleep(1)

# --- 7. Click picklist buttons / list items ---
picklist1_xpath <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/p-picklist[1]/div/div[2]/button[2]"
b$Runtime$evaluate(sprintf("
var elem = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(elem) { elem.click(); } else { console.log('Picklist1 button not found'); }
", picklist1_xpath))
Sys.sleep(1)

list_item_xpath <- '//*[@id="cdk-drop-list-2"]/li[1]/div'
b$Runtime$evaluate(sprintf("
var elem = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(elem) { elem.click(); } else { console.log('List item not found'); }
", list_item_xpath))
Sys.sleep(1)

picklist2_xpath <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/p-picklist[2]/div/div[2]/button[1]/anglerighticon"
b$Runtime$evaluate(sprintf("
var elem = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(elem) { elem.click(); } else { console.log('Picklist2 button not found'); }
", picklist2_xpath))
Sys.sleep(1)

final_button_xpath <- "/html/body/app-root/div/app-trademark/w-step/div/div/div[2]/f-facet/app-ips-form/w-edit-panel[4]/div[2]/f-facet/button[4]"
b$Runtime$evaluate(sprintf("
var elem = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
if(elem) { elem.click(); } else { console.log('Final button not found'); }
", final_button_xpath))
Sys.sleep(10)  # wait for table to render

# --- 8. Extract the table ---
table_xpath <- '//*[@id="pr_id_3"]/div'

table_html <- b$Runtime$evaluate(sprintf("
var elem = document.evaluate('%s', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
elem ? elem.outerHTML : '';
", table_xpath))$result$value

# Parse table with rvest
page <- read_html(table_html)
tbl <- page %>% html_node("table") %>% html_table(fill = TRUE)

tbl <- tbl[,-1]

