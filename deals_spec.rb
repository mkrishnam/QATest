require_relative '../../shared/watir_helper'
require_relative '../../config/ui/deals_cfg'
require_relative '../../lib/ui/deals_helper'


describe "My Deals Test Suites" do 

 before(:each) do
    open_browser
    init_deals_variables
    login_to_application
  end

  after(:each) do |tc|
    take_screenshot if (tc.exception != nil || tc.instance_variable_get("@exception") != nil )
    close_all_windows
  end

  it "test my deals UI components" do 
    browser.span(:text=>/My Deals/i).parent.parent.parent.parent.parent.as[0].focus
    @deal= browser.span(:text=>/My Deals/i).parent.parent.parent.parent.parent.as[0].text
    browser.span(:text=>/My Deals/i).parent.parent.parent.parent.parent.as[0].click

    ##collateral name verification
    verify_deal_name
   
    ##verifying the collateral notebook view
    verify_notebook_view
    
    ##verifying collateral dashboard view 
    verify_dashboard_view
  end

end