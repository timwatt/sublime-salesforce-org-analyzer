require 'cucumber/formatter/html'


module Cucumber
  module Formatter
  	class HtmlCS < Html
  		def before_features(features)
        @step_count = features && features.step_count || 0 #TODO: Make this work with core!

        # <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        @builder.declare!(
          :DOCTYPE,
          :html,
          :PUBLIC,
          '-//W3C//DTD XHTML 1.0 Strict//EN',
          'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
        )
     
        
          @builder << '<html xmlns ="http://www.w3.org/1999/xhtml">'
            @builder.head do
            @builder.meta('http-equiv' => 'Content-Type', :content => 'text/html;charset=utf-8')
            @builder.title "Security Audit"
            inline_css
            inline_js
          end
          @builder << '<body>'
          @builder << "<!-- Step count #{@step_count}-->"
          @builder << '<div class="cucumber">'
         #   @builder << '<img height="50px" src="https://www.cloudsherpas.com/thecloud/wp-content/themes/cloudsherpas/assets/images/logo.svg"/>'
          
          @builder.div(:id => 'cucumber-header') do
            @builder.div(:id => 'label') do
            	@builder.h1("Security Audit")
            end
            @builder.div(:id => 'summary') do
              @builder.p('',:id => 'totals')
              @builder.p('',:id => 'duration')
              @builder.div(:id => 'expand-collapse') do
                @builder.p('Expand All', :id => 'expander')
                @builder.p('Collapse All', :id => 'collapser')
              end
            end 
        end
      end
  		def embed_table (data)
  			#puts data.first.class
  			if data.kind_of? Hash 

  				xm = Builder::XmlMarkup.new(:indent => 2)
				xm.table {
				 # xm.tr { data[0].keys.each { |key| xm.th(key)}}
				  data.each  do |key,value| 
              xm.tr {
                xm.td(key)
                xm.td(value)
             }
          end
				}
			else
				xm = Builder::XmlMarkup.new(:indent => 2)
				xm.table {
				 # xm.tr { data[0].keys.each { |key| xm.th(key)}}
				  data.each { |value| xm.tr {  xm.td(value)}}
				}
			end
			xm
  		end
  		def print_messages
	        return if @delayed_messages.empty?

	        #@builder.ol do
	          @delayed_messages.each do |ann|
	          	if ann.kind_of? Array 
               
	          		@builder << embed_table(ann)
	          	elsif ann.kind_of? Hash
               	@builder << embed_table(ann)
	          	else  
                
                @builder.li(:class => 'step message') do
		              @builder << ann
		            end
		          end
	          end
	        #end
	        empty_messages
      	end

  		def exception(exception, status)
        	return if @hide_this_step
        	print_messages
        	#build_exception_detail(exception)
      	end
  	end
  end
end