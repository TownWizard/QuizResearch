#SurveyTemplate.create(:template_code => '<h2>Sample Revenue Generation Survey Template</h2><hr />{{survey}}<hr /><h2>Footer</h2>', :deleted_at => nil)

#template_ids = SurveyTemplate.find(:all, :conditions => "template_code LIKE '%Revenue Generation Survey%'").collect {|t| t.id}

#1.times do |s|
#t = template_ids[rand(template_ids.size)]
#ri = 'Thanks! interstitial for template '.concat( t.to_s )
#st = SurveyTemplate.find_by_id(t).template_code.concat( t.to_s )

#Survey.create(
#   :survey_template_id => t,
#   :survey_display_instance => st,
#   :quiz_id => 1,
#   :partner_site_id => 1,
#   :deleted_at => nil,
#   :reward_interstitial => ri,
#   :reward_url => 'http://www.thankyou.com'
#)
#end


#Survey.create(:survey_template_id => 16, :survey_display_instance => '<h2>Sample Revenue Generation Survey Template</h2><hr />{{survey}}<hr /><h2>Footer</h2>', :quiz_id => 25, :partner_site_id => 1, :deleted_at => nil, :reward_interstitial => 'Your survey has been submitted and your feedback is appreciated.<br />Now claim your reward valued at up to $100.00!', :reward_url => 'http://www.thankyou.com' )

#SharedQuiz.create(:quiz_id =>25, :partner_site_id=>1, :deleted_at => nil)

template = '
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>

    <title>Welcome to our Demo Survey!</title>
    <link href="/stylesheets/survey_template_1.css" media="screen" rel="stylesheet" type="text/css" />

  </head>
  <body>
    
    <div class="wrapper">
      <img src="/images/surveys/synapse_synapseconnect.gif" style="float:right;" />
      <img src="/images/surveys/synapse_proflowers.gif" style="margin-bottom: 10px;" />
      <br style="clear: right;" />
      <div class="content_wrapper_outer">
        <div class="content_wrapper_inner" style="margin-bottom: 10px;">
          <h2>Tell us about your recent purchase!</h2>
          <div class="content_wrapper_reward">
            As our thanks for your feedback, get a gift valued at up to <span style="color: #c00;">$100.00!</span>
          </div>
        </div>
        <div class="content_wrapper_inner">
          {{survey}}
        </div>
      </div>
    </div>

</body>
</html>'

i = Survey.find_by_id(111)
i.survey_display_instance = template
i.save

j = SurveyTemplate.find(:first, :conditions => "template_code LIKE '%content_wrapper_reward%'")
j.template_code = template
j.save