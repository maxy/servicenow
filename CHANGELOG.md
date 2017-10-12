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

