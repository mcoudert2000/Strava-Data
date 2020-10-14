#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#DOWNLOADING PACKAGES
library(shiny) 
library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)


# Creating endpoint to use in oath2.0_token
my_endpoint <- oauth_endpoint(
    request = NULL,
    authorize = "https://www.strava.com/oauth/authorize?client_id=54363&response_type=code&redirect_uri=http://matthewcoudert.digital&approval_prompt=force",
    access = "https://www.strava.com/api/v3/oauth/token"
)

# Getting approval from Strava to access API for my data
my_token = oauth2.0_token(
    endpoint = my_endpoint,
    app = oauth_app("strava", key = 54363, secret = Sys.getenv("strava_secret")),
    as_header = FALSE,
    scope = "activity:read_all",
    use_oob = FALSE
)

# Fetching my data from the API
athl_res = GET("https://www.strava.com/api/v3/athlete/activities",
               query = list(page = 1, per_page = 200), my_token)
# Converting raw data into usable format
activity_data <- fromJSON(rawToChar(athl_res$content)) 
#tidying
activity_data <- activity_data %>%
    select(-c("pr_count", "commute", "from_accepted_tag","athlete_count",
              "resource_state", "comment_count", "photo_count", "has_kudoed",
              "photo_count", "visibility","private","external_id","upload_id",
              "utc_offset","achievement_count","timezone",
              "location_city","location_state","location_country","flagged",
              "private","upload_id_str","manual","gear_id","heartrate_opt_out",
              "display_hide_heartrate_option"))



#UI 
ui <- fluidPage(
)

#SERVER
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
