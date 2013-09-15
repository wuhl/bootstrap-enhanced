# config/initializers/high_voltage.rb

# Top level routes
#
# You can remove the directory pages from the URL path and serve up routes from the root of the domain path:
# 
# http://www.example.com/about
# http://www.example.com/company
# Would look for corresponding files:
# 
# app/views/pages/about.html.erb
# app/views/pages/company.html.erb
# This is accomplished by changing the HighVoltage.route_drawer to HighVoltage::RouteDrawers::Root
HighVoltage.route_drawer = HighVoltage::RouteDrawers::Root

# Disabling routes
# 
# The default routes can be completely removed by changing the HighVoltage.routes to false:
# HighVoltage.routes = false

# Content path
#
# High Voltage uses a default path and folder of 'pages', i.e. 'url.com/pages/contact', 'app/views/pages'.
# HighVoltage.content_path = 'site/'

# Caching
#
# High Voltage supports both page and action caching.
#
# To enable them you can add the following to your initializer:
#
# HighVoltage.action_caching = true
# # OR
# HighVoltage.page_caching = true
# High Voltage will use your default cache store to store action caches.
#
# Using caching with Ruby on Rails 4 or higher requires gems:
#
# # Gemfile
# gem 'actionpack-action_caching'
# gem 'actionpack-page_caching'
#

#
# more see https://github.com/thoughtbot/high_voltage
#