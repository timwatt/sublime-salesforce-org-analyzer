
Given(/^all profiles with license type of "(.*?)"$/) do |licenseType|
  @profiles = Salesforce.profiles_by_license_type[licenseType]
  if @profiles.nil? 
    @profiles = Hash.new
  end
  @profiles
end

Given(/^all custom settings$/) do
  @custom_settings = Salesforce.custom_settings
end


Given(/^all custom settings that contain credentials$/) do
  @custom_settings = Salesforce.custom_settings.select{|name, body| body.content.matches_credentials?}
end

Given(/^Apex classes that do not have "(.*?)"$/) do |text|
  @classes =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false && apex.body.downcase.include?(text.downcase)==false && apex.name.downcase.include?('test')==false}
end

Given(/^Apex classes that do not have "(.*?)" except for$/) do |text, exceptions|
  exceptionNames = exceptions.hashes.collect{|row| row[:name].downcase}
  @classes =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false && apex.body.downcase.include?(text.downcase)==false  && apex.name.downcase.include?('test')==false && exceptionNames.include?(name.downcase) == false}
end

Given(/^all Apex classes$/) do
   @classes =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false &&  apex.name.downcase.include?('test')==false}
end

Given(/^all Apex classes except for$/) do |exceptions|
  exceptionNames = exceptions.hashes.collect{|row| row[:name].downcase}
  @classes =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false &&  apex.name.downcase.include?('test')==false && exceptionNames.include?(name.downcase) == false}
end

Given(/^all Apex classes that contain test methods$/) do
  @classes =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false && (apex.body.downcase.include?('@istest')==true || apex.body.downcase.include?('testmethod')==true)}
end

Given(/^all Apex classes that contain DML statements$/) do
   @classes =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false && apex.name.downcase.include?('test')==false   && (apex.body.downcase.include?('insert') || apex.body.downcase.include?('update') || apex.body.downcase.include?('upsert') || apex.body.downcase.include?('delete'))}
end

Given(/^all Apex triggers$/) do
   @triggers =  Salesforce.apex_triggers.select{|name, apex| name.include?('__')==false}
end

Given(/^all Visualforce pages$/) do
   @pages =  Salesforce.apex_pages
end

Given(/^all Visualforce components$/) do
   @components =  Salesforce.apex_components.select{|name, body| name.include?('__')==false}
end

Given(/^all apex classes that they have access to$/) do
  classesByProfile = Hash.new
  if @profiles.nil?
    @classes['ALL'] =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false &&  apex.body.downcase.include?('@istest')==false}
  else
      @profiles.each do |name, xml|
         class_names = xml.xpath('//xmlns:classAccesses').select{|obj|obj.at_xpath(".//xmlns:enabled").content.eql?("true")}.collect{|obj|obj.at_xpath(".//xmlns:apexClass").content}
        @classes[name] =  Salesforce.apex_classes.select{|name, apex| name.include?('__')==false &&  apex.body.downcase.include?('@istest')==false && class_names.include?(name)}
      end
  end
end

Given(/^all fields whose name may indicate sensitive data$/) do
   @fields = Hash.new
    @profiles.each do |name, xml|
       @fields = xml.xpath('//xmlns:fieldPermissions').select{|obj|obj.at_xpath(".//xmlns:field").content.matches_pii?}
   #   unless matchingFieldElements.empty?
      # matchingFieldElements.each {|obj| matchingFields << obj}
    #  end
    end
  #  @fields = matchingFields
end

Given(/^all fields whose name includes:$/) do |table|
  matchingFields = Array.new
   table.hashes.each do |hash|
      text = hash["text value"]
      matchingFieldElements  = @actor.salesforce.profile.xpath('//xmlns:fieldPermissions').select{|obj|obj.at_xpath(".//xmlns:field").content.downcase.include?(text) }
      unless matchingFieldElements.empty?
       matchingFieldElements.each {|obj| matchingFields << obj}
      end
    end
    @fields = matchingFields
end


Then(/^the user "(.*?)" have "(.*?)" access to any object except for "(.*?)"$/) do |condition, permission, exceptions|
  booleanCondition = (condition=="should").to_s
  permissionField = case permission
                  when "create" then :allowCreate
                  when "edit" then :allowEdit
                  when "delete" then :allowDelete
                  when "read"   then :allowRead
                  when "view all"   then :viewAllRecords
                  when "modify all"   then :modifyAllRecords
                end
  failures = @actor.salesforce.profile.xpath('//xmlns:objectPermissions').select{|obj|obj.at_xpath(".//xmlns:#{permissionField}").content.eql?(booleanCondition)==false}.collect{|obj| obj.at_xpath('.//xmlns:object').content}
  failures = failures -  exceptions.split(',').collect{|obj| obj.strip}
  expectNoMatches(failures)
end

Then(/^the user "(.*?)" have "(.*?)" access to any object$/) do |condition, permission|
  booleanCondition = (condition=="should").to_s
  permissionField = case permission
                  when "create" then :allowCreate
                  when "edit" then :allowEdit
                  when "delete" then :allowDelete
                  when "read"   then :allowRead
                  when "view all"   then :viewAllRecords
                  when "modify all"   then :modifyAllRecords
                end
  #TODO need to add code to filter based on object input
  failures = @actor.salesforce.profile.xpath('//xmlns:objectPermissions').select{|obj|obj.at_xpath(".//xmlns:#{permissionField}").content.eql?(booleanCondition)==false}.collect{|obj| obj.at_xpath('.//xmlns:object').content}
   expectNoMatches(failures)
end

Then(/^the user "(.*?)" have access to any Apex$/) do |condition|
  booleanCondition = (condition=="should").to_s
  failures = Array.new
  @profiles.each do |name, xml|
    failures = xml.xpath('//xmlns:classAccesses').select{|obj|obj.at_xpath(".//xmlns:enabled").content.eql?(booleanCondition)==false}.collect{|obj| obj.at_xpath('.//xmlns:apexClass').content}
  end
    expectNoMatches(failures)
end

Then(/^the user "(.*?)" have access to any Apex except for "(.*?)"$/) do |condition,exceptions|
  booleanCondition = (condition=="should").to_s
  failures = @actor.salesforce.profile.xpath('//xmlns:classAccesses').select{|obj|obj.at_xpath(".//xmlns:enabled").content.eql?(booleanCondition)==false}
  failures = failures -  exceptions.split(',').collect{|obj| obj.strip}
   expectNoMatches(failures)
end


Then(/^all objects should have "(.*?)" visiblity set to "(.*?)"$/) do |model, visibility|
  modelAttribute = model.downcase.eql?('internal') ? 'sharingModel' : 'externalSharingModel'
  failures =  Hash.new
  Salesforce.sobjects.each do |name,obj| 
      sharingModel =  model.downcase.eql?('internal') ? obj.sharingModel : obj.externalSharingModel
      if sharingModel.nil? == false && sharingModel.eql?(visibility) == false && sharingModel.eql?('ControlledByParent') == false
        failures[name]=sharingModel
      end
  end
  expectNoMatches(failures)
end

Then(/^all objects should have "(.*?)" visiblity set to "(.*?)" except for "(.*?)"$/) do |model, visibility,exceptions|
  failures =  Hash.new
  Salesforce.sobjects.each do |name,obj| 
      sharingModel =  model.downcase.eql?('internal') ? obj.sharingModel : obj.externalSharingModel
      if sharingModel.nil? == false && sharingModel.eql?(visibility) == false  && sharingModel.eql?('ControlledByParent') == false
        failures[name]=sharingModel
      end
  end
  finalFailures = failures.keys - exceptions
  expectNoMatches( finalFailures)
end

Then(/^the contents of the "(.*?)" "(.*?)" include the text "(.*?)"$/) do |type, condition,text|
  objects = case type.downcase 
              when "page" then @pages
              when "class" then @classes
              when "component" then @components
              end
  booleanCondition = (condition=="should")
  unless objects.nil?
    failures =objects.select{|name,obj| obj.body.downcase.include?(text.downcase) != booleanCondition}
    expectNoMatches(failures)
  end
end

Then(/^the fields "(.*?)" be "(.*?)"$/) do |condition, property|
  booleanCondition = (condition=="should").to_s

  unless @fields.empty?
     failures = @fields.select{|field| field.at_xpath(".//xmlns:#{property}").content.eql?(booleanCondition) == false}.collect{|obj| obj.at_xpath('.//xmlns:field').content}
     expectNoMatches(failures)
  end
end

Then(/^objects should be in the validated list$/) do |exceptions|
  failures = @custom_settings.collect{|key,xml| key.downcase} - exceptions.hashes.collect{|row| row[:name].downcase}
  expectNoMatches(failures)
end

Then(/^the user permission "([^"]*)" should be set to "([^"]*)"$/) do |permission, value|
  failures = Hash.new
  @profiles.each do |name, xml|
      api= xml.at_xpath("//xmlns:userPermissions/name[contains(text(), \'#{permission}\')]")
      puts api.content + ' - ' + api.previous.content unless api.nil? || api.previous.nil?
  end
   expectNoMatches(failures)
end

Then(/^there is only one trigger per object$/) do
  failures = Hash.new
  triggers_by_object = Hash.new
  @triggers.each do |name, apex|     
    object =/(?<=\bon\s)(\w+)/.match(apex.source).to_s
    unless triggers_by_object.key?(object)
      triggers_by_object[object] = Hash.new
    end
    triggers_by_object[object] [name] = apex
  end
  triggers_by_object.each do |object, triggers|
   # puts "#{object}: #{triggers.count} #{triggers.keys}"
    if triggers.count > 1
      failures[object] = triggers.keys.join(', ')
    end
  end
  puts failures
     expectNoMatches(failures)
end
