## 1.1.3

* @maxy removed unused variable assignments
* fixed readme and code climate integration
* fixed additional rubocop offenses

## 1.1.2

* fixed Rake test invocation, thanks @maxy
* test integration turned on and pass
* rubocop added and some simple offenses fixed

## 1.1.1

* fixed Time.zone.now call to use Time.now.utc

## 1.1.0

* Add ability to override default parameters in Servicenow::Change methods

## 1.0.0

### breaking changes

* Servicenow::Client#snow_base_url is renamed
Servicenow::Client#snow_api_base_url for consistency with other variables
* Logger is moved from Servicenow::Client to Servicenow; passing logger to
Client has no effect
* renamed Servicenow::Client#submit_change to Servicenow::Client#create_change

### other changes

* moved configuration to the module level
* added methods to post work notes to a Change
* added methods to start and stop a Change
* Servicenow.logger by default logs to STDOUT, INFO level.  A future improvement
  will attempt to mask passwords
* basic tests

## 0.0.3

## 0.0.2

