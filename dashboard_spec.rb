require_relative '../../shared/watir_helper'
require_relative '../../config/ui/dashboard_cfg'
require_relative '../../lib/ui/dashboard_helper'

describe "Dashboard Test Suites" do

  before(:each) do
    open_browser
    init_dashboard_variables    
    login_to_application
  end

  after(:each) do |tc|
    take_screenshot if (tc.exception != nil || tc.instance_variable_get("@exception") != nil )
    close_all_windows
  end

  it "test UI left nav" do        
    ## CHECK LEFT NAV
    checkleftnav_link_exists('Dashboards')
    checkleftnav_link_exists('Actions')
    checkleftnav_link_exists('Admin')
    checkleftnav_link_exists('Favorites')
    checkleftnav_link_exists('History')
  end 

  it "test logo" do
    ## CHECK LOGO (DISPLAY ANY LOGO)
    raise "Logo doesn't exists" unless browser.img(:class=>"logo").exists?
  end

  it 'test UI search bar' do
    ## CHECK search-bar
    browser.form(:class=>/search-bar/).input.send_keys "wawa"
    browser.form(:class=>/search-bar/).button(:class=>"btn btn-search").click 
    browser.div(:class=>"search-results-list").wait_until_present
    raise "No records found" unless browser.table(:class=>"table table-bordered table-striped table-condensed table-hover").trs.count>1
  end
  
  it 'test icons on right of dashboard header' do  
    ##CHECK THE ALERT SYMBOL
    raise "No alert icon found" unless browser.div(:id=>"header").a(:class=>"dropdown-toggle").i(:class=>"fa fa-2x fa-bell").exists?
    raise "No favorite symbol present on the header" unless browser.div(:id=>"header").as(:class=>"dropdown-toggle")[1].i(:class=>"fa fa-2x fa-star").exists?
    browser.li(:class=>/navbar-user/).click
    raise "Admin (Global) setting not found under logged in user" unless browser.div(:id=>"header").a(:text=>/Admin \(Global\) S/).exists?
    raise "Logout link not shown under logged in user" unless browser.div(:id=>"header").a(:text=>/Log Out/).exists?
  end

  it 'test change avatar' do
    browser.div(:class=>/navbar-fixed-top/).image(:src=>/avatar/).fire_event(:onmouseover)
    browser.div(:class=>/navbar-fixed-top/).image(:src=>/avatar/).click
    browser.div(:class=>/navbar-fixed-top/).image(:src=>/avatar/).click unless browser.link(:text=>'Preferences').exists?
    browser.link(:text=>'Preferences').click
    browser.link(:text=>'Preferences').click unless browser.div(:class=>'content').h2(:text=>'Preferences').exists?
    orig_avatar=browser.li(:class=>/selected/).text
    new_avatar=browser.lis(:class=>/picker-grid-item/)[0].text
    if orig_avatar==new_avatar
      new_avatar=browser.lis(:class=>/picker-grid-item/)[1].text
    end
    browser.image(:src=>/\/img\/avatars\/#{new_avatar}.png/).double_click
    browser.image(:src=>/\/img\/avatars\/#{new_avatar}.png/).double_click unless (browser.li(:class=>/selected/).text == new_avatar)

    browser.button(:text=>'Save').click
    raise unless browser.div(:class=>'toast-message').text =~ /Saved preferences/
    raise unless browser.div(:class=>/navbar-fixed-top/).image(:src=>/#{new_avatar}/).exists?
  end
  
end