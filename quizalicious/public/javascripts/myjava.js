$(document).ready(function() {

	
	$(".tab_content").hide(); //On page load hide all the contents of all tabs
	$("ul.tabs li:first").addClass("active").show(); //Default to the first tab
	$(".tab_content:first").show(); //Show the default tabs content

	//When the user clicks on the tab
	$("ul.tabs li").click(function() {

		$("ul.tabs li").removeClass("active"); //Remove the active class
		$(this).addClass("active"); //Add the active tab to the selected tab
		$(".tab_content").hide(); //Hide all other tab content

		var activeTab = $(this).find("a").attr("href"); //Get the href's attribute value (class) and fade in the corresponding tabs content
		$(activeTab).fadeIn(); //Fade the tab in
		return false;
	});

	
	

});