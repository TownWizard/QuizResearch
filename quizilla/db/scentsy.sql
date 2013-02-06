insert into `surveys`(`id`,`survey_template_id`,`survey_display_instance`,`quiz_id`,`partner_site_id`,`deleted_at`,`created_at`,`updated_at`,`reward_interstitial`,`reward_url`)

values (42,18,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>synapse scentsy customer survey</title>
    <script src="/javascripts/prototype.js" type="text/javascript"></script>
    <style type="text/css">
                body {
            background-color: #7e9db6;
            margin: 0;
            font-family: georgia;
        }
        .header_wrapper {
            height: 101px;
            min-height: 101px;
            max-height: 101px;
            background-color: #1e71af;
        }
        .footer_wrapper {
            height: 50px;
            min-height: 50px;
            max-height: 50px;
            background-color: #7e9db6;
        }
            .footer_wrapper, .footer_wrapper a {
                color: #fff;
                font-family: verdana;
                font-size: 10px;
                text-decoration: none;
            }
            .footer_wrapper a:hover {
                color: #666;
            }
        .survey_wrapper {
            background: #ddecf6 url("/images/surveys/synapse/scentsy/background_grad.gif") top left repeat-x;
        }
        .survey_bg {
            background: #fff url("/images/surveys/synapse/scentsy/survey_background.gif") top left repeat-y;
            min-height: 350px;
        }
        .survey {
            padding: 15px;
        }
        .header, .footer, .survey_bg {
            width: 720px;
            margin: 0 auto;
        }
        h1, h2 {
          display: inline;
        }
        h1 {
            font-size: 2.0em;
        }
        h2 {
          font-size: 1.2em;
          font-weight: normal;
        }
        img, input[type="image"] {
            border: 0;
        }
        label {
          font-size: .80em;
          font-weight: bold;
        }
        .progress_bar_wrapper {
          background: url("/images/surveys/synapse/scentsy/progress_bar.gif") no-repeat top left;
          width: 693px;
          height: 18px;
        }
        .progress_bar {
          margin-left: 83px;
          background: url("/images/surveys/synapse/scentsy/progress_bar_on.gif") repeat-x top left;
          text-align: right;
          color: #fff;
          font-family: verdana, sans-serif;
          font-size: 10px;
          font-weight: bold;
        }
        .progress_bar img {
          vertical-align: middle;
        }
    </style>
  </head>
  <body>
    <div class="header_wrapper">
        <div class="header">
            <img src="/images/surveys/synapse/scentsy/logo.jpg" alt="scentsy" style="float: left; margin: 0px 0 0 0px;" />
        </div>
    </div>

    <div class="survey_wrapper">
        <div class="survey_bg">
            <div class="survey">
                {{survey}}
            </div>
        </div>
    </div>

    <div class="footer_wrapper">
        <div class="footer">
            <img src="/images/surveys/synapse/scentsy/powered_by_synapse.gif" alt="Powered by Synapse" style="vertical-align: bottom; margin: 15px 15px 0 9px;" />
            &copy;2010 SynapseGroup, Inc. | <a href="#" onclick="Element.toggle(''privacy''); return false;">Privacy Policy</a>
        </div>
    </div>

    <div style="display: none; background-color: #fff; border: 1px #000 solid; padding: 15px; position: absolute; left: 150px; top: 150px; width: 450px; min-height: 100px;" id="privacy">
        <div style="float: right; font-size: .85em;">
            <a href="#" onclick="Element.toggle(''privacy''); return false;">[x]close</a>
        </div>
         Privacy Policy
    </div>
</body>
</html>',101,2,null,null,null,'Thank you for completing our survey.','http://321mags.com/survey-sample/scentsy/');
